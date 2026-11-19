import SwiftUI

// MARK: - 动作要点块（选择器内联展开与详情页共用）

struct NotesBlock: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.s2) {
            if !exercise.positionNotes.isEmpty {
                VStack(alignment: .leading, spacing: Theme.s1) {
                    Text("动作要点 · 需要注意的位置")
                        .font(.subheadline.weight(.semibold))
                    ForEach(Array(exercise.positionNotes.enumerated()), id: \.offset) { _, note in
                        HStack(alignment: .top, spacing: Theme.s1) {
                            Text(note.part)
                                .font(.caption2.weight(.bold))
                                .foregroundStyle(Theme.accent)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Theme.accent.opacity(0.10), in: Capsule())
                            Text(note.text)
                                .font(.caption)
                                .foregroundStyle(.primary)
                            Spacer(minLength: 0)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(note.part)：\(note.text)")
                    }
                }
            }

            if !exercise.cues.isEmpty {
                VStack(alignment: .leading, spacing: Theme.s1) {
                    Text("动作重点 · 从起始到结束")
                        .font(.subheadline.weight(.semibold))
                    ForEach(Array(exercise.cues.enumerated()), id: \.offset) { index, cue in
                        HStack(alignment: .top, spacing: Theme.s1) {
                            Text("\(index + 1)")
                                .font(.caption2.weight(.bold).monospacedDigit())
                                .foregroundStyle(.secondary)
                                .frame(width: 18, height: 18)
                                .background(Theme.separator.opacity(0.35), in: Circle())
                            Text(cue).font(.caption)
                            Spacer(minLength: 0)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("第 \(index + 1) 步，\(cue)")
                    }
                }
            }

            if let mistake = exercise.mistake, !mistake.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Label("最容易做错", systemImage: "exclamationmark.triangle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Theme.danger)
                    Text(mistake)
                        .font(.caption)
                        .foregroundStyle(.primary)
                }
                .padding(Theme.s2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Theme.danger.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .accessibilityElement(children: .combine)
            }
        }
        .padding(Theme.s2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.page, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - 动作行

struct ExerciseRowView: View {
    let exercise: Exercise
    var expanded = false
    var added = false
    var onToggle: (() -> Void)? = nil
    var onAdd: (() -> Void)? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.s1) {
            HStack(spacing: Theme.s2) {
                GroupBadge(group: exercise.group)
                VStack(alignment: .leading, spacing: 2) {
                    Text(exercise.name)
                        .font(.body.weight(.semibold))
                        .lineLimit(1)
                    Text(exercise.equipmentLabel + " · " + (exercise.hasNotes ? "有动作要点" : "按分钟记录"))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)

                if let onToggle = onToggle {
                    Button {
                        onToggle()
                    } label: {
                        Text(expanded ? "收起" : "ⓘ 要点")
                            .font(.caption.weight(.bold))
                            .frame(minHeight: 32)
                            .padding(.horizontal, Theme.s1)
                            .foregroundStyle(Theme.accent)
                            .overlay(Capsule().stroke(Theme.accent, lineWidth: 1.5))
                    }
                    .buttonStyle(.borderless)
                    .accessibilityLabel(expanded ? "收起 \(exercise.name) 的动作要点" : "查看 \(exercise.name) 的动作要点")
                }

                if let onAdd = onAdd {
                    if added {
                        Text("已加")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, Theme.s1)
                            .padding(.vertical, 6)
                            .background(Theme.separator.opacity(0.25), in: Capsule())
                            .accessibilityLabel("\(exercise.name) 已加入本次训练")
                    } else {
                        Button {
                            onAdd()
                        } label: {
                            Image(systemName: "plus")
                                .font(.body.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 34, height: 34)
                                .background(Theme.accent, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel("把 \(exercise.name) 加入本次训练")
                    }
                }
            }
            if expanded {
                NotesBlock(exercise: exercise)
                    .padding(.leading, 40)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - 动作详情（模态，提供关闭按钮 + 系统下滑关闭）

struct ExerciseDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let exercise: Exercise

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.s3) {
                    HStack(spacing: Theme.s2) {
                        GroupBadge(group: exercise.group)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(exercise.name).font(.title3.weight(.bold))
                            Text("\(exercise.equipmentLabel) · \(exercise.isCardio ? "按分钟记录" : "按次数记录")")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }

                    Text(exercise.tip)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(Theme.s2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Theme.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))

                    if exercise.hasNotes {
                        NotesBlock(exercise: exercise)
                    } else {
                        Text("有氧动作不配部位要点，按时间记录即可。")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    let family = ExerciseDatabase.family(of: exercise.id)
                    if !family.isEmpty {
                        VStack(alignment: .leading, spacing: Theme.s1) {
                            Text("同族变式").font(.subheadline.weight(.semibold))
                            ForEach(family) { item in
                                HStack {
                                    Image(systemName: "arrow.turn.down.right")
                                        .foregroundStyle(.secondary)
                                    Text(item.name).font(.caption)
                                    Spacer()
                                }
                            }
                        }
                    }

                    if exercise.group == "背", exercise.id.contains("pullup") || exercise.id.contains("chinup") {
                        VStack(alignment: .leading, spacing: Theme.s1) {
                            Text("引体握法").font(.subheadline.weight(.semibold))
                            ForEach(ExerciseDatabase.gripTexts, id: \.name) { grip in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(grip.name).font(.caption.weight(.semibold))
                                    Text(grip.detail).font(.caption).foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(Theme.s2)
            }
            .background(Theme.page)
            .navigationTitle("动作详情")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("关闭") { dismiss() }
                        .accessibilityLabel("关闭动作详情")
                }
            }
        }
    }
}

// MARK: - 添加动作选择器

struct ExercisePickerView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: WorkoutStore
    @State private var query = ""
    @State private var group: String? = nil
    @State private var expanded: Set<String> = []
    @State private var message = ""

    private var results: [Exercise] { ExerciseDatabase.search(query, group: group) }
    private var addedIDs: Set<String> {
        Set(store.data.active?.entries.map(\.exerciseID) ?? [])
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.s1) {
                        chip(title: "全部", value: nil)
                        ForEach(ExerciseDatabase.groups, id: \.self) { g in
                            chip(title: g, value: g)
                        }
                    }
                    .padding(.horizontal, Theme.s2)
                    .padding(.vertical, Theme.s1)
                }

                if !message.isEmpty {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(Theme.success)
                        .padding(.vertical, 4)
                        .accessibilityLabel(message)
                }

                List {
                    ForEach(results) { exercise in
                        ExerciseRowView(
                            exercise: exercise,
                            expanded: expanded.contains(exercise.id),
                            added: addedIDs.contains(exercise.id),
                            onToggle: {
                                if expanded.contains(exercise.id) { expanded.remove(exercise.id) }
                                else { expanded.insert(exercise.id) }
                            },
                            onAdd: {
                                if store.addExercise(exercise.id) {
                                    message = "已添加 \(exercise.name)"
                                }
                            }
                        )
                    }
                }
                .listStyle(.plain)
                .overlay {
                    if results.isEmpty {
                        VStack(spacing: Theme.s1) {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                            Text("没有匹配的动作")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityElement(children: .combine)
                    }
                }
            }
            .searchable(text: $query, prompt: "搜索动作名称")
            .navigationTitle("添加动作")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom) {
                Button {
                    dismiss()
                } label: {
                    Text("完成")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: Theme.minTap)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
                .padding(Theme.s2)
                .background(.bar)
                .accessibilityLabel("完成添加动作并关闭")
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                        .accessibilityLabel("取消添加动作")
                }
            }
        }
    }

    @ViewBuilder
    private func chip(title: String, value: String?) -> some View {
        let selected = group == value
        Button {
            group = value
        } label: {
            Text(title)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, Theme.s2)
                .padding(.vertical, Theme.s1)
                .foregroundStyle(selected ? .white : .primary)
                .background(selected ? Theme.accent : Theme.card, in: Capsule())
        }
        .buttonStyle(.borderless)
        .accessibilityLabel("筛选部位：\(title)")
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }
}
