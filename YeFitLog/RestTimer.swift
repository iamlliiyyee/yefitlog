import Foundation
import UIKit

/// 组间休息计时。核心设计：**用绝对结束时间戳判断，不累加秒数**——
/// 后台被系统节流/冻结后，回到前台依然能算出真实的到点状态。
/// 到点提醒由「页内弹窗 + 5 秒 Core Haptics + 系统本地通知」三重保障。
@MainActor
final class RestTimer: ObservableObject {
    @Published private(set) var remaining = 0
    @Published private(set) var total = 0
    @Published private(set) var isRunning = false
    @Published private(set) var isFinished = false
    @Published var showAlert = false

    private var endsAt: Date?
    private var ticker: Timer?
    private var fired = false
    private var observer: (any NSObjectProtocol)?
    private var soundEnabled = true
    private var vibrateEnabled = true
    private var notifyEnabled = true

    init() {
        // 前台时通知也会送达，转发为统一的 App 内提醒，避免同时出现系统横幅和页内弹窗。
        observer = NotificationCenter.default.addObserver(
            forName: .restTimeUp,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in self?.fire() }
        }
    }

    func start(seconds: Int, sound: Bool, vibrate: Bool, notify: Bool) {
        stop()
        let secs = max(5, seconds)
        soundEnabled = sound
        vibrateEnabled = vibrate
        notifyEnabled = notify
        total = secs
        remaining = secs
        isRunning = true
        isFinished = false
        showAlert = false
        fired = false
        endsAt = Date().addingTimeInterval(TimeInterval(secs))
        UserDefaults.standard.removeObject(forKey: RestNotification.pendingKey)

        if notify { NotificationManager.shared.scheduleRest(seconds: secs) }
        HapticsManager.shared.prepare()
        // 训练中保持屏幕常亮，避免自动锁屏把计时冻住（原生能力，网页版 iOS 无此能力）
        UIApplication.shared.isIdleTimerDisabled = true

        ticker = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.tick() }
        }
    }

    private func tick() {
        guard isRunning, let endsAt else { return }
        let left = max(0, Int(ceil(endsAt.timeIntervalSinceNow)))
        remaining = left
        if left == 0 { fire() }
    }

    /// 到点。fired 保证 Timer 与通知转发两条路径只触发一次。
    func fire() {
        guard !fired else { return }
        fired = true
        isRunning = false
        isFinished = true
        remaining = 0
        ticker?.invalidate()
        ticker = nil
        NotificationManager.shared.cancelRest()
        UserDefaults.standard.set(true, forKey: RestNotification.pendingKey)

        HapticsManager.shared.playBeep(enabled: soundEnabled)
        HapticsManager.shared.playRestBuzz(enabled: vibrateEnabled)
        showAlert = true
    }

    func acknowledge() {
        HapticsManager.shared.stopBuzz()
        showAlert = false
        isFinished = false
        total = 0
        endsAt = nil
        UserDefaults.standard.removeObject(forKey: RestNotification.pendingKey)
        NotificationManager.shared.cancelRest()
    }

    func snooze() {
        HapticsManager.shared.stopBuzz()
        UserDefaults.standard.removeObject(forKey: RestNotification.pendingKey)
        start(seconds: 30, sound: soundEnabled, vibrate: vibrateEnabled, notify: notifyEnabled)
    }

    func stop() {
        ticker?.invalidate()
        ticker = nil
        NotificationManager.shared.cancelRest()
        isRunning = false
        endsAt = nil
    }

    /// App 回到前台时调用：校正被冻结的倒计时；若后台期间已到点且未确认，补一次震动 + 弹窗。
    func resumeIfNeeded(sound: Bool, vibrate: Bool) {
        soundEnabled = sound
        vibrateEnabled = vibrate
        if isRunning, let endsAt {
            if endsAt.timeIntervalSinceNow <= 0 {
                fire()
            } else {
                remaining = Int(ceil(endsAt.timeIntervalSinceNow))
            }
            return
        }
        if UserDefaults.standard.bool(forKey: RestNotification.pendingKey), !showAlert {
            HapticsManager.shared.prepare()
            HapticsManager.shared.playBeep(enabled: sound)
            HapticsManager.shared.playRestBuzz(enabled: vibrate)
            isFinished = true
            showAlert = true
        }
    }

    var progress: Double {
        total > 0 ? Double(total - remaining) / Double(total) : 0
    }
}
