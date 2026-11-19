import SwiftUI
import UIKit
import UserNotifications
import UniformTypeIdentifiers

struct SettingsView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var restTimer: RestTimer
    @State private var auth: UNAuthorizationStatus = .notDetermined
    @State private var showImporter = false
    @State private var importMessage: String?
    @State private var exportURL: URL?
    @State private var showShare = false

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Toggle("提示音", isOn: settingsBinding(\.sound))
                        .accessibilityLabel("提示音开关")
                    Toggle("震动提醒", isOn: settingsBinding(\.vibrate))
                        .accessibilityLabel("震动提醒开关")

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("后台提醒").font(.body)
                            Text(authDetail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: Theme.s1)
                        Button(authButtonTitle) { handleAuthButton() }
                            .font(.subheadline.weight(.semibold))
                            .buttonStyle(.borderless)
                            .accessibilityLabel(authButtonTitle)
                    }

                    Button {
                        testReminder()
                    } label: {
                        Label("试一下（立即震动 5 秒 + 提示音 + 弹窗）", systemImage: "waveform.path.ecg")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: Theme.minTap, alignment: .leading)
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("测试提醒，立即震动五秒并弹出提醒")
                } header: {
                    Text("组歇提醒")
                } footer: {
                    Text(capabilityNote)
                }

                Section("训练参数") {
                    Stepper(value: settingsBinding(\.defaultRest), in: 60...480, step: 15) {
                        HStack {
                            Text("默认组歇")
                            Spacer()
                            Text("\(store.data.settings.defaultRest) 秒")
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                    .accessibilityLabel("默认组歇 \(store.data.settings.defaultRest) 秒")

                    Stepper(value: settingsBinding(\.bodyWeight), in: 30.0...200.0, step: 1.0) {
                        HStack {
                            Text("体重")
                            Spacer()
                            Text("\(Int(store.data.settings.bodyWeight)) kg")
                                .foregroundStyle(.secondary)
                                .monospacedDigit()
                        }
                    }
                    .accessibilityLabel("体重 \(Int(store.data.settings.bodyWeight)) 公斤")
                }

                Section("数据") {
                    Button {
                        showImporter = true
                    } label: {
                        Label("导入网页版备份", systemImage: "square.and.arrow.down")
                    }
                    .accessibilityLabel("导入网页版导出的 JSON 备份")

                    Button {
                        exportURL = makeExportFile()
                        showShare = exportURL != nil
                    } label: {
                        Label("导出本机备份", systemImage: "square.and.arrow.up")
                    }
                    .accessibilityLabel("导出本机训练记录")
                } footer: {
                    Text("在网页版「我的 · 数据管理 · 导出数据」拿到 JSON 后，用「导入网页版备份」把历史记录带过来。进行中的训练不会迁移。")
                }

                Section("关于") {
                    HStack {
                        Text("动作库")
                        Spacer()
                        Text("\(ExerciseDatabase.all.count) 个动作")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("训练记录")
                        Spacer()
                        Text("\(store.data.sessions.count) 次")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("震动能力")
                        Spacer()
                        Text(HapticsManager.shared.supportsHaptics ? "支持 Core Haptics" : "降级为轻反馈")
                            .foregroundStyle(.secondary)
                    }
                    Text("数据只存在本机，不上传、不依赖网络和网页端。")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("设置")
            .task { refreshAuth() }
            .fileImporter(
                isPresented: $showImporter,
                allowedContentTypes: [.json],
                allowsMultipleSelection: false
            ) { result in
                handleImport(result)
            }
            .alert(
                "导入结果",
                isPresented: Binding(
                    get: { importMessage != nil },
                    set: { if !$0 { importMessage = nil } }
                )
            ) {
                Button("好", role: .cancel) {}
            } message: {
                Text(importMessage ?? "")
            }
            .sheet(isPresented: $showShare) {
                if let exportURL {
                    ShareSheet(url: exportURL)
                }
            }
        }
    }

    // MARK: 逻辑

    private func settingsBinding<T>(_ keyPath: WritableKeyPath<AppSettings, T>) -> Binding<T> {
        Binding(
            get: { store.data.settings[keyPath: keyPath] },
            set: { newValue in
                var d = store.data
                d.settings[keyPath: keyPath] = newValue
                store.data = d
            }
        )
    }

    private var capabilityNote: String {
        """
        组歇到点会震动约 5 秒、响一声并弹出提醒。训练中自动保持屏幕常亮，避免锁屏把倒计时冻住。\
        锁屏或切到后台时由系统通知在到点提醒（带系统声音与振动）；回到 App 会再补一次震动和弹窗。\
        iPhone 8 及以上支持完整震动，更早机型降级为 5 次触觉反馈。
        """
    }

    private var authDetail: String {
        switch auth {
        case .authorized: return "已授权 · 后台到点会收到系统通知"
        case .provisional, .ephemeral: return "临时授权 · 可重新开启"
        case .denied: return "未授权 · 后台到点不会有系统通知"
        case .notDetermined: return "尚未开启 · 建议开启以便后台提醒"
        @unknown default: return "状态未知"
        }
    }

    private var authButtonTitle: String {
        switch auth {
        case .authorized: return "已开启"
        case .denied: return "去系统设置"
        case .notDetermined: return "去开启"
        default: return "重新开启"
        }
    }

    private func refreshAuth() {
        NotificationManager.shared.currentAuthorization { status in
            Task { @MainActor in auth = status }
        }
    }

    private func handleAuthButton() {
        if auth == .denied {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
            return
        }
        // 权限只在用户主动点击时申请，符合 Apple HIG。
        NotificationManager.shared.requestAuthorization { granted in
            Task { @MainActor in
                auth = granted ? .authorized : .denied
                if granted {
                    var d = store.data
                    d.settings.notify = true
                    store.data = d
                }
            }
        }
    }

    private func testReminder() {
        HapticsManager.shared.unlockAudio()
        HapticsManager.shared.prepare()
        HapticsManager.shared.playBeep(enabled: store.data.settings.sound)
        HapticsManager.shared.playRestBuzz(enabled: store.data.settings.vibrate)
        restTimer.showAlert = true
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            let scoped = url.startAccessingSecurityScopedResource()
            defer { if scoped { url.stopAccessingSecurityScopedResource() } }
            let raw = try? Data(contentsOf: url)
            // fileImporter 的回调非隔离；切回 MainActor 再调用 @MainActor 的存储方法。
            Task { @MainActor in
                guard let raw else {
                    importMessage = "读取文件失败，请确认选择的是 JSON 备份"
                    return
                }
                do {
                    let count = try store.importLegacyBackup(raw)
                    importMessage = count > 0
                        ? "成功导入 \(count) 条训练记录，可在「记录」中查看"
                        : "备份里的记录之前已经导入过了"
                } catch {
                    importMessage = "导入失败：\(error.localizedDescription)"
                }
            }
        case .failure(let error):
            Task { @MainActor in
                importMessage = "读取文件失败：\(error.localizedDescription)"
            }
        }
    }

    private func makeExportFile() -> URL? {
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("fitlog-native-\(Fmt.date(Date())).json")
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            try encoder.encode(store.data).write(to: url, options: .atomic)
            return url
        } catch {
            importMessage = "导出失败：\(error.localizedDescription)"
            return nil
        }
    }
}

// MARK: 系统分享面板

struct ShareSheet: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: [url], applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}
