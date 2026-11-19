import SwiftUI

/// 语义化配色与 8pt 网格。全部使用系统语义色 / 动态色，自动适配深色模式与增强对比度。
enum Theme {
    // MARK: 8pt 网格
    static let s1: CGFloat = 8
    static let s2: CGFloat = 16
    static let s3: CGFloat = 24
    static let s4: CGFloat = 32
    static let corner: CGFloat = 16
    static let minTap: CGFloat = 44

    // MARK: 语义色（不依赖颜色单独传达信息，始终配合图标或文字）
    static let accent = Color("AccentColor")
    static let page = Color(uiColor: .systemGroupedBackground)
    static let card = Color(uiColor: .secondarySystemGroupedBackground)
    static let secondary = Color(uiColor: .secondaryLabel)
    static let separator = Color(uiColor: .separator)
    static let danger = Color(uiColor: .systemRed)
    static let success = Color(uiColor: .systemGreen)

    /// 部位色块。文字始终为白色，在浅色/深色模式下都保持可读。
    static func groupColor(_ group: String) -> Color {
        switch group {
        case "胸":   return Color(red: 0.90, green: 0.12, blue: 0.16)
        case "背":   return Color(red: 0.10, green: 0.42, blue: 0.78)
        case "腿":   return Color(red: 0.20, green: 0.55, blue: 0.30)
        case "肩":   return Color(red: 0.85, green: 0.45, blue: 0.10)
        case "手臂": return Color(red: 0.55, green: 0.28, blue: 0.72)
        case "核心": return Color(red: 0.05, green: 0.58, blue: 0.60)
        case "有氧": return Color(red: 0.42, green: 0.46, blue: 0.52)
        default:     return Color(red: 0.42, green: 0.46, blue: 0.52)
        }
    }

    static func groupSymbol(_ group: String) -> String {
        switch group {
        case "胸":   return "figure.strengthtraining.traditional"
        case "背":   return "figure.rower"
        case "腿":   return "figure.walk"
        case "肩":   return "figure.arms.open"
        case "手臂": return "dumbbell.fill"
        case "核心": return "figure.core.training"
        case "有氧": return "figure.run"
        default:     return "figure.mind.and.body"
        }
    }
}

// MARK: 格式化

enum Fmt {
    static func clock(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval))
        return String(format: "%02d:%02d", total / 60, total % 60)
    }

    static func rest(_ seconds: Int) -> String {
        seconds >= 60 ? "\(seconds / 60) 分 \(seconds % 60) 秒" : "\(seconds) 秒"
    }

    static func number(_ value: Double) -> String {
        value >= 1000 ? String(format: "%.0f", value) : String(format: "%.1f", value)
    }

    /// 一组记录的可读文本：自重动作显示「自重 / +负重」，有氧显示分钟。
    static func setLabel(_ set: SetRecord, exercise: Exercise?) -> String {
        guard let exercise else { return "\(set.reps) 次" }
        if exercise.unit == .minutes { return "\(set.reps) 分钟" }
        let weightPart: String
        if exercise.isSelfweight {
            weightPart = set.weight > 0 ? "+\(trim(set.weight))kg" : "自重"
        } else {
            weightPart = set.weight > 0 ? "\(trim(set.weight))kg" : "—"
        }
        return "\(weightPart)×\(set.reps)"
    }

    private static func trim(_ v: Double) -> String {
        v.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", v) : String(format: "%.1f", v)
    }

    static func date(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: d)
    }

    static func time(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: d)
    }
}

// MARK: 通用小组件

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    var highlighted = false

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.s1 / 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title3.weight(.semibold).monospacedDigit())
                    .foregroundStyle(highlighted ? Theme.accent : .primary)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(unit)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.s2)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: Theme.corner, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title) \(value) \(unit)")
    }
}

struct GroupBadge: View {
    let group: String

    var body: some View {
        Text(group)
            .font(.caption2.weight(.bold))
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background(Theme.groupColor(group), in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            .accessibilityLabel("部位：\(group)")
    }
}

struct SectionHeader: View {
    let title: String
    var subtitle: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.title3.weight(.semibold))
            if let subtitle {
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}
