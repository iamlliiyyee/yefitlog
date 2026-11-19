import SwiftUI
import UIKit

@main
struct YeFitLogApp: App {
    @StateObject private var store = WorkoutStore()
    @StateObject private var restTimer = RestTimer()

    init() {
        // 只注册通知分类与 delegate；权限在用户点「开始训练」或「开启后台提醒」时才申请。
        NotificationManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(restTimer)
                .onAppear {
                    Task { @MainActor in
                        HapticsManager.shared.unlockAudio()
                        HapticsManager.shared.prepare()
                    }
                }
        }
    }
}
