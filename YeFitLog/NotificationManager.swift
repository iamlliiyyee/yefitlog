import Foundation
import UserNotifications

extension Notification.Name {
    /// 本地通知在前台送达时转发给 RestTimer，保证前台不重复弹系统横幅。
    static let restTimeUp = Notification.Name("yeFitLog.restTimeUp")
}

enum RestNotification {
    static let requestID = "yeFitLog.restTimer"
    static let categoryID = "YE_FITLOG_REST"
    static let actionAcknowledge = "YE_FITLOG_REST_ACK"
    static let actionSnooze = "YE_FITLOG_REST_SNOOZE30"
    static let pendingKey = "yeFitLog.restPending"
}

/// 本地通知是「后台到点提醒」的关键：由系统在到点时刻投递，
/// 即使 App 被挂起、屏幕熄灭、JS 计时器被冻结也能响。网页版做不到这一点。
final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() { super.init() }

    /// 启动时只注册分类与 delegate；**不在这里请求权限**（Apple HIG：权限应在用户操作上下文中申请）。
    func configure() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let acknowledge = UNNotificationAction(
            identifier: RestNotification.actionAcknowledge,
            title: "知道了",
            options: []
        )
        let snooze = UNNotificationAction(
            identifier: RestNotification.actionSnooze,
            title: "再休息 30 秒",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: RestNotification.categoryID,
            actions: [acknowledge, snooze],
            intentIdentifiers: [],
            options: []
        )
        center.setNotificationCategories([category])
    }

    /// 只在用户点「开始训练」或设置里的「开启后台提醒」时调用。
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    func currentAuthorization(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async { completion(settings.authorizationStatus) }
        }
    }

    /// 组歇开始时排一条到点通知；重复调用会先取消旧的。
    func scheduleRest(seconds: Int) {
        cancelRest()
        let content = UNMutableNotificationContent()
        content.title = "休息结束 · 开始下一组"
        content.body = "组间休息已到点，回到烨 · 健身记录继续训练"
        content.sound = .default
        content.categoryIdentifier = RestNotification.categoryID
        content.userInfo = ["kind": "rest"]
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(max(1, seconds)),
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: RestNotification.requestID,
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(request)
    }

    func cancelRest() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(
            withIdentifiers: [RestNotification.requestID]
        )
    }

    /// 通知操作「再休息 30 秒」在后台被点击时：直接排一条新的 30 秒通知，无需唤醒界面。
    func snoozeFromBackground() {
        scheduleRest(seconds: 30)
    }

    // MARK: UNUserNotificationCenterDelegate

    /// App 在前台时通知也会送达：不显示系统横幅，改为转发给 App 内部统一弹窗 + 5 秒震动。
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        if notification.request.content.userInfo["kind"] as? String == "rest" {
            UserDefaults.standard.set(true, forKey: RestNotification.pendingKey)
            NotificationCenter.default.post(name: .restTimeUp, object: nil)
            completionHandler([])
        } else {
            completionHandler([.banner, .sound, .list])
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        guard response.notification.request.content.userInfo["kind"] as? String == "rest" else {
            completionHandler()
            return
        }
        if response.actionIdentifier == RestNotification.actionSnooze {
            snoozeFromBackground()
            UserDefaults.standard.removeObject(forKey: RestNotification.pendingKey)
        } else {
            // 点通知正文或「知道了」：标记待确认，回到 App 时补弹窗 + 震动
            UserDefaults.standard.set(true, forKey: RestNotification.pendingKey)
            NotificationCenter.default.post(name: .restTimeUp, object: nil)
        }
        completionHandler()
    }
}
