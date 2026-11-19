import SwiftUI
import UserNotifications

struct TrainView: View {
    @EnvironmentObject private var store: WorkoutStore
    @EnvironmentObject private var restTimer: RestTimer
    @Binding var selection: AppTab

    @State private var showPicker = false
    @State private var showFinishConfirm = false
    @State private var showCancelConfirm = false
    @State private var notice = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.s3) {
                    if !notice.isEmpty {
                        Text(notice)
                            .font(.caption)
                            .foregroundStyle(Theme.success)
                            .accessibilityLabel(notice)
                    }
                    if let session = store.data.active {
                        if session.startedAt == nil {
                            prepView(session)
                        } else {
                            runningView(session)
                        }
                    } else {
                        idleView
                    }
                }
                .padding(Theme.s2)
            }
            .background(Theme.page)
            .navigationTitle("训练")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showPicker) { ExercisePickerView() }
            .alert("结束并保存训练？", isPresented: $showFinishConfirm) {
                Button("取消", role: .cancel) {}
                Button("保存") { finishTraining() }
            } message: {
                Text("共完成 \(store.data.active?.completedSets ?? 0) 组，结束后可在「记录」里查看每个动作、每一组的明细。")
            }
            .confirmationDialog(
                "放弃这次训练？",
                isPresented: $showCancelConfirm,
                titleVisibility: .visible
            ) {
                Button("放弃", role: .destructive) {
                    restTimer.stop()
                    store.cancelActive()
                }
                Button("继续准备", role: .cancel) {}
            } message: {
                Text("准备阶段填好的动作会被清空。")
            }
        }
    }

    // MARK: 空闲态

    private var idleView: some View {
        VStack(alignment: .leading, spacing: Theme.s3) {
            VStack(alignment: .leading, spacing: Theme.s2) {
                Label("自由训练", systemImage: "dumbbell.fill")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Theme.accent)
                Text("点进去先进入准备页，挑好动作、改好组数，再按「开始训练」才开始计时。")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button {
                    if store.startFreeTraining() {
                        notice = ""
                    } else {
                        notice = "已有正在进行的训练，先结束它"
                    }
                } label: {
                    Text("开始自由训练")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: Theme.minTap)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
                .accessibilityLabel("开始自由训练，进入准备页")
            }
            .padding(Theme.s3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))

            Button {
                selection = .library
            } label: {
                Label("先去动作库看要点", systemImage: "list.bullet.rectangle")
                    .frame(maxWidth: .infinity, minHeight: Theme.minTap)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("前往动作库查看动作要点")

            if let last = store.data.sessions.first {
                VStack(alignment: .leading, spacing: Theme.s1) {
                    Text("最近一次训练").font(.headline)
                    Text("\(last.name) · \(Fmt.date(last.createdAt)) · \(last.totalSets) 组 · \(last.durationMinutes) 分钟")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Text("训练中会自动保持屏幕常亮；组歇到点会震动约 5 秒、响一声并弹出提醒，切到后台也有系统通知。")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: 准备态（计时未开始）

    private func prepView(_ session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: Theme.s3) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.name).font(.title2.weight(.bold))
                    Text("准备中 · 计时还没开始")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button("取消") { showCancelConfirm = true }
                    .buttonStyle(.borderless)
                    .foregroundStyle(Theme.danger)
                    .accessibilityLabel("取消这次训练")
            }

            VStack(alignment: .leading, spacing: Theme.s2) {
                Text("先挑动作，或直接开始")
                    .font(.headline)
                Text("已选 \(session.entries.count) 个动作")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button {
                    beginTraining()
                } label: {
                    Text("开始训练")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: Theme.minTap)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
                .accessibilityLabel("开始训练，此刻开始计时")
                Text("点「开始训练」之后才开始计时；动作随时可以增减。")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(Theme.s3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))

            Button {
                showPicker = true
            } label: {
                Label("添加动作（可先看要点）", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity, minHeight: Theme.minTap)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("添加动作，可先展开查看注意事项")

            entryList(session, editable: true)
        }
    }

    // MARK: 训练中

    private func runningView(_ session: WorkoutSession) -> some View {
        VStack(alignment: .leading, spacing: Theme.s3) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(session.name).font(.title2.weight(.bold))
                    if let startedAt = session.startedAt {
                        TimelineView(.periodic(from: .now, by: 1)) { context in
                            Text(Fmt.clock(context.date.timeIntervalSince(startedAt)) + " · \(session.completedSets) 组完成")
                                .font(.subheadline.monospacedDigit())
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                Spacer()
                Button("结束训练") { showFinishConfirm = true }
                    .buttonStyle(.bordered)
                    .tint(Theme.danger)
                    .accessibilityLabel("结束训练并保存记录")
            }

            HStack(spacing: Theme.s1) {
                StatCard(title: "已完成", value: "\(session.completedSets)", unit: "组")
                StatCard(title: "容量", value: Fmt.number(session.volume), unit: "kg")
                StatCard(title: "消耗", value: Fmt.number(session.kcal), unit: "kcal", highlighted: true)
            }

            if restTimer.isRunning {
                restBar
            }

            Button {
                showPicker = true
            } label: {
                Label("添加动作", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity, minHeight: Theme.minTap)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("添加动作到本次训练")

            entryList(session, editable: false)

            Text("每组打勾后自动开始组间休息，到点会震动 5 秒并弹窗提醒。")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var restBar: some View {
        VStack(alignment: .leading, spacing: Theme.s1) {
            HStack {
                Label("组间休息", systemImage: "timer")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(Fmt.rest(restTimer.remaining))
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundStyle(Theme.accent)
            }
            ProgressView(value: restTimer.progress)
                .tint(Theme.accent)
            HStack {
                Button("跳过") { restTimer.acknowledge() }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("跳过剩余组歇")
                Spacer()
                Button("再休息 30 秒") { restTimer.snooze() }
                    .buttonStyle(.borderless)
                    .accessibilityLabel("再休息 30 秒")
            }
        }
        .padding(Theme.s2)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    // MARK: 动作与组列表

    @ViewBuilder
    private func entryList(_ session: WorkoutSession, editable: Bool) -> some View {
        if session.entries.isEmpty {
            Text(editable ? "还没有动作，点上面的「添加动作」开始挑选" : "还没有动作")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Theme.s2)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))
        } else {
            ForEach(session.entries) { entry in
                VStack(alignment: .leading, spacing: Theme.s2) {
                    HStack(spacing: Theme.s1) {
                        GroupBadge(group: entry.exercise?.group ?? "其他")
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.displayName).font(.subheadline.weight(.semibold))
                            Text("\(entry.exercise?.equipmentLabel ?? "") · 组歇 \(entry.restSeconds) 秒")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer(minLength: 0)
                        if editable {
                            Button(role: .destructive) {
                                store.removeEntry(entry.id)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(Theme.danger)
                            }
                            .buttonStyle(.borderless)
                            .accessibilityLabel("从本次训练移除 \(entry.displayName)")
                        }
                    }

                    ForEach(Array(entry.sets.enumerated()), id: \.element.id) { index, set in
                        setRow(entry: entry, set: set, index: index, editable: editable)
                    }

                    if !editable {
                        Button {
                            store.addSet(to: entry.id)
                        } label: {
                            Label("加一组", systemImage: "plus")
                                .font(.caption)
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("给 \(entry.displayName) 再加一组")
                    }
                }
                .padding(Theme.s2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))
            }
        }
    }

    @ViewBuilder
    private func setRow(entry: WorkoutEntry, set: SetRecord, index: Int, editable: Bool) -> some View {
        HStack(spacing: Theme.s1) {
            Text("\(index + 1)")
                .font(.caption.weight(.bold).monospacedDigit())
                .foregroundStyle(.secondary)
                .frame(width: 20)

            TextField("重量", value: Binding(
                get: { set.weight },
                set: { store.updateSet(entryID: entry.id, setID: set.id, weight: $0) }
            ), format: .number)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .frame(minWidth: 56, maxWidth: 80)
                .multilineTextAlignment(.center)
                .accessibilityLabel("第 \(index + 1) 组重量，公斤")

            Text(entry.exercise?.isCardio == true ? "分钟" : "kg ×")
                .font(.caption)
                .foregroundStyle(.secondary)

            TextField("次数", value: Binding(
                get: { set.reps },
                set: { store.updateSet(entryID: entry.id, setID: set.id, reps: $0) }
            ), format: .number)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .frame(minWidth: 48, maxWidth: 68)
                .multilineTextAlignment(.center)
                .accessibilityLabel("第 \(index + 1) 组次数")

            Spacer(minLength: 0)

            if editable {
                Text(set.isDone ? "已完成" : "待完成")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            } else {
                Button {
                    completeSet(entryID: entry.id, setID: set.id)
                } label: {
                    Image(systemName: set.isDone ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundStyle(set.isDone ? Theme.success : .secondary)
                        .frame(width: Theme.minTap, height: Theme.minTap)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel(set.isDone
                    ? "第 \(index + 1) 组已完成，点按取消完成"
                    : "完成第 \(index + 1) 组")
            }
        }
    }

    // MARK: 操作

    private func beginTraining() {
        store.beginActive()
        HapticsManager.shared.unlockAudio()
        HapticsManager.shared.prepare()
        // 权限在「开始训练」这个用户操作上下文里申请，不在 App 启动时。
        // 回调来自非隔离线程，显式切回 MainActor 再改 @MainActor 状态。
        NotificationManager.shared.requestAuthorization { granted in
            Task { @MainActor in
                var d = store.data
                d.settings.notify = granted
                store.data = d
            }
        }
    }

    private func completeSet(entryID: UUID, setID: UUID) {
        guard let rest = store.toggleSetDone(entryID: entryID, setID: setID) else { return }
        restTimer.start(
            seconds: rest,
            sound: store.data.settings.sound,
            vibrate: store.data.settings.vibrate,
            notify: store.data.settings.notify
        )
    }

    private func finishTraining() {
        restTimer.stop()
        _ = store.finishActive()
        selection = .history
    }
}
