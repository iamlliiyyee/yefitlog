import SwiftUI

enum AppTab: String, Hashable {
    case train, library, history, settings
}

struct ContentView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var restTimer: RestTimer
    @Environment(\.scenePhase) private var scenePhase
    @State private var selection: AppTab = .train

    var body: some View {
        ZStack {
            TabView(selection: $selection) {
                TrainView(selection: $selection)
                    .tabItem { Label("训练", systemImage: "dumbbell.fill") }
                    .tag(AppTab.train)
                    .accessibilityLabel("训练标签页")

                LibraryView()
                    .tabItem { Label("动作库", systemImage: "list.bullet.rectangle.fill") }
                    .tag(AppTab.library)
                    .accessibilityLabel("动作库标签页")

                HistoryView()
                    .tabItem { Label("记录", systemImage: "clock.arrow.circlepath") }
                    .tag(AppTab.history)
                    .accessibilityLabel("训练记录标签页")

                SettingsView()
                    .tabItem { Label("设置", systemImage: "gearshape.fill") }
                    .tag(AppTab.settings)
                    .accessibilityLabel("设置标签页")
            }

            // 到点提醒层：盖在所有标签页之上，点遮罩或「知道了」都能关闭。
            if restTimer.showAlert {
                RestAlertOverlay()
                    .transition(.opacity.combined(with: .scale(scale: 0.92)))
            }
        }
        .animation(.easeInOut(duration: 0.22), value: restTimer.showAlert)
        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }
            Task { @MainActor in
                restTimer.resumeIfNeeded(
                    sound: store.data.settings.sound,
                    vibrate: store.data.settings.vibrate
                )
            }
        }
    }
}

// MARK: - 组歇到点提醒

struct RestAlertOverlay: View {
    @EnvironmentObject private var restTimer: RestTimer
    @State private var pulse = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { restTimer.acknowledge() }
                .accessibilityHidden(true)

            VStack(spacing: Theme.s3) {
                Image(systemName: "bell.badge.fill")
                    .font(.system(size: 46, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 88, height: 88)
                    .background(Theme.accent, in: Circle())
                    .scaleEffect(pulse ? 1.08 : 1.0)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
                    .accessibilityHidden(true)

                VStack(spacing: Theme.s1) {
                    Text("休息结束")
                        .font(.title2.weight(.bold))
                    Text("开始下一组训练")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel("休息结束，开始下一组训练")

                HStack(spacing: Theme.s2) {
                    Button {
                        restTimer.snooze()
                    } label: {
                        Text("再休息 30 秒")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: Theme.minTap)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("再休息 30 秒")

                    Button {
                        restTimer.acknowledge()
                    } label: {
                        Text("知道了")
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: Theme.minTap)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Theme.accent)
                    .accessibilityLabel("知道了，关闭提醒")
                }
            }
            .padding(Theme.s4)
            .frame(maxWidth: 340)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(Theme.s3)
            .onAppear { pulse = true }
            .accessibilityAddTraits(.isModal)
        }
    }
}
