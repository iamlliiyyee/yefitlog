import SwiftUI

struct LibraryView: View {
    @State private var query = ""
    @State private var group: String? = nil
    @State private var detail: Exercise?

    private var results: [Exercise] { ExerciseDatabase.search(query, group: group) }

    var body: some View {
        NavigationStack {
            VStack(spacing: Theme.s1) {
                SectionHeader(
                    title: "动作库",
                    subtitle: "共 \(ExerciseDatabase.all.count) 个动作 · 点开看部位要点与易错提醒"
                )
                .padding(.horizontal, Theme.s2)
                .padding(.top, Theme.s1)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.s1) {
                        chip(title: "全部", value: nil)
                        ForEach(ExerciseDatabase.groups, id: \.self) { g in
                            chip(title: g, value: g)
                        }
                    }
                    .padding(.horizontal, Theme.s2)
                    .padding(.vertical, 4)
                }
            }

            List {
                Section {
                    ForEach(results) { exercise in
                        Button {
                            detail = exercise
                        } label: {
                            HStack(spacing: Theme.s2) {
                                GroupBadge(group: exercise.group)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(exercise.name)
                                        .font(.body.weight(.semibold))
                                        .foregroundStyle(.primary)
                                    Text(exercise.equipmentLabel + " · " + (exercise.hasNotes ? "含动作要点" : "按分钟记录"))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .buttonStyle(.plain)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("\(exercise.name)，\(exercise.group)，\(exercise.equipmentLabel)，查看动作要点")
                        .accessibilityHint("双击打开动作详情")
                    }
                } footer: {
                    Text("力量动作均配有 3 条部位要点、4 步动作重点与易错提醒；有氧动作按时间记录。")
                        .font(.caption)
                }
            }
            .listStyle(.insetGrouped)
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
                }
            }
            .searchable(text: $query, prompt: "搜索动作名称")
            .navigationTitle("动作库")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $detail) { exercise in
                ExerciseDetailView(exercise: exercise)
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
