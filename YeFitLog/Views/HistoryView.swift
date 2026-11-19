import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: WorkoutStore
    @State private var selected: WorkoutSession?

    private var sessions: [WorkoutSession] { store.data.sessions }

    var body: some View {
        NavigationStack {
            Group {
                if sessions.isEmpty {
                    VStack(spacing: Theme.s2) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 40))
                            .foregroundStyle(.secondary)
                        Text("还没有训练记录")
                            .font(.headline)
                        Text("完成一次训练后，这里能点开看到每个动作、每一组练了什么。")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, Theme.s4)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.page)
                    .accessibilityElement(children: .combine)
                } else {
                    List {
                        Section {
                            ForEach(sessions) { session in
                                Button {
                                    selected = session
                                } label: {
                                    HStack(spacing: Theme.s2) {
                                        Image(systemName: "figure.strengthtraining.traditional")
                                            .font(.title3)
                                            .foregroundStyle(Theme.accent)
                                            .frame(width: 36)
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(session.name)
                                                .font(.body.weight(.semibold))
                                                .foregroundStyle(.primary)
                                            Text("\(Fmt.date(session.createdAt)) · \(session.durationMinutes) 分钟 · \(session.totalSets) 组")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer(minLength: 0)
                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    .padding(.vertical, 4)
                                }
                                .buttonStyle(.plain)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("\(session.name)，\(Fmt.date(session.createdAt))，\(session.totalSets) 组，查看详情")
                            }
                        } header: {
                            Text("共 \(sessions.count) 次训练")
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("训练记录")
            .sheet(item: $selected) { session in
                SessionDetailView(session: session)
            }
        }
    }
}

// MARK: - 记录详情：按动作分行、每组一个标签

struct SessionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let session: WorkoutSession

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.s3) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(session.name).font(.title2.weight(.bold))
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: Theme.s1) {
                        StatCard(title: "组数", value: "\(session.totalSets)", unit: "组")
                        StatCard(title: "容量", value: Fmt.number(session.volume), unit: "kg")
                        StatCard(title: "消耗", value: Fmt.number(session.kcal), unit: "kcal", highlighted: true)
                    }

                    VStack(alignment: .leading, spacing: Theme.s2) {
                        Text("练了什么")
                            .font(.headline)
                        if session.entries.isEmpty {
                            Text("这次没有动作明细 · 从网页版导入的早期记录可能只保留了总体数据")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .padding(Theme.s2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        } else {
                            ForEach(session.entries) { entry in
                                VStack(alignment: .leading, spacing: Theme.s1) {
                                    HStack(spacing: Theme.s1) {
                                        GroupBadge(group: entry.exercise?.group ?? "其他")
                                        Text(entry.displayName)
                                            .font(.subheadline.weight(.semibold))
                                        Spacer(minLength: 0)
                                        Text("\(entry.completedSets.count) 组")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    if entry.completedSets.isEmpty {
                                        Text("没有完成任何一组")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    } else {
                                        FlowTags(tags: entry.completedSets.enumerated().map { index, set in
                                            "\(index + 1) · " + Fmt.setLabel(set, exercise: entry.exercise)
                                        })
                                    }
                                }
                                .padding(Theme.s2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .accessibilityElement(children: .combine)
                            }
                        }
                    }
                }
                .padding(Theme.s2)
            }
            .background(Theme.page)
            .navigationTitle("训练详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("关闭") { dismiss() }
                        .accessibilityLabel("关闭训练详情")
                }
            }
        }
    }

    private var subtitle: String {
        var parts = [Fmt.date(session.createdAt), "\(session.durationMinutes) 分钟"]
        if let start = session.startedAt { parts.append("\(Fmt.time(start)) 开始") }
        parts.append("\(session.entries.count) 个动作 \(session.totalSets) 组")
        return parts.joined(separator: " · ")
    }
}

/// 轻量自适应标签行，兼容 iPhone SE 到 Pro Max 的宽度。
struct FlowTags: View {
    let tags: [String]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 96), spacing: Theme.s1)], alignment: .leading, spacing: Theme.s1) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption.monospacedDigit())
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, Theme.s1)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.separator.opacity(0.18), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .accessibilityLabel(tag)
            }
        }
    }
}
