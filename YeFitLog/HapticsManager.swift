import Foundation
import UIKit
import CoreHaptics
import AudioToolbox
import AVFoundation

/// 原生震动与提示音。
/// 网页版在 iOS 上完全没有震动能力（navigator.vibrate 不存在）；原生走 Core Haptics 才能真正震动。
/// iPhone 8 及以上支持 Core Haptics；更老的设备降级为 5 次重击反馈，仍覆盖约 5 秒。
final class HapticsManager: ObservableObject {
    // 类本身不标 @MainActor：static let 的初始化是非隔离上下文，
    // 若类被隔离，Swift 6 会把这里判为错误。逐个方法标注隔离更安全。
    static let shared = HapticsManager()

    @Published private(set) var engineReady = false

    var supportsHaptics: Bool { CHHapticEngine.capabilitiesForHardware().supportsHaptics }

    private var engine: CHHapticEngine?
    private var player: (any CHHapticPatternPlayer)?

    private init() {}

    /// 建好引擎并预热。应在前台调用（组歇开始或用户点「试一下」时）。
    @MainActor
    func prepare() {
        guard supportsHaptics else { engineReady = false; return }
        do {
            let newEngine = try CHHapticEngine()
            newEngine.playsHapticsOnly = true
            try newEngine.start()
            engine = newEngine
            engineReady = true
        } catch {
            engineReady = false
        }
    }

    /// 组歇到点：5 段 0.9 秒震动 + 0.16 秒间隔，合计 5.14 秒（与网页版 REST_BUZZ 一致）。
    @MainActor
    func playRestBuzz(enabled: Bool) {
        guard enabled else { return }
        if supportsHaptics {
            if engine == nil || !engineReady { prepare() }
            guard let engine else { fallbackBuzz(); return }
            do {
                let pattern = try Self.restPattern()
                let newPlayer = try engine.makePlayer(with: pattern)
                player = newPlayer
                try newPlayer.start(atTime: CHHapticTimeImmediate)
            } catch {
                fallbackBuzz()
            }
        } else {
            fallbackBuzz()
        }
    }

    /// 停止正在播放的震动（用户点「知道了」时）。
    @MainActor
    func stopBuzz() {
        try? player?.stop(atTime: CHHapticTimeImmediate)
        player = nil
    }

    /// 提示音：系统音效，无需额外资源文件；已在用户手势中解锁音频会话。
    @MainActor
    func playBeep(enabled: Bool) {
        guard enabled else { return }
        AudioServicesPlaySystemSound(SystemSoundID(1005))
    }

    /// 第一次用户交互时调用，避免 iOS 静默拦截首个音频播放。
    @MainActor
    func unlockAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch { /* 音频不可用不影响其它功能 */ }
    }

    // MARK: 内部

    private static func restPattern() throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        var at: TimeInterval = 0
        for _ in 0..<5 {
            events.append(CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.35)
                ],
                relativeTime: at,
                duration: 0.9
            ))
            at += 1.06      // 0.9 震动 + 0.16 间隔
        }
        return try CHHapticPattern(events: events, parameters: [])
    }

    @MainActor
    private func fallbackBuzz() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        Task { @MainActor in
            for _ in 0..<5 {
                generator.impactOccurred()
                try? await Task.sleep(nanoseconds: 1_020_000_000)
            }
        }
    }
}
