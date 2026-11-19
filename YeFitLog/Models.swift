import Foundation

// MARK: - 动作库

enum SetUnit: String, Codable, Hashable {
    case reps
    case minutes
}

struct PositionNote: Codable, Hashable {
    let part: String
    let text: String
}

struct GripText: Codable, Hashable {
    let name: String
    let detail: String
}

struct Exercise: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let group: String
    let equipment: String
    let met: Double
    let unit: SetUnit
    let tip: String
    let positionNotes: [PositionNote]
    let cues: [String]
    let mistake: String?

    var isCardio: Bool { unit == .minutes }
    var isSelfweight: Bool { equipment == "bodyweight" || equipment == "band" }
    var equipmentLabel: String { ExerciseDatabase.equipmentLabel(equipment) }
    var hasNotes: Bool { !positionNotes.isEmpty || !cues.isEmpty || mistake != nil }
}

// MARK: - 训练数据

struct SetRecord: Codable, Identifiable, Hashable {
    var id = UUID()
    var weight: Double = 0
    var reps: Int = 10
    var isDone = false
    var completedAt: Date?
}

struct WorkoutEntry: Codable, Identifiable, Hashable {
    var id = UUID()
    var exerciseID: String
    var note = ""
    var restSeconds = 90
    var sets: [SetRecord] = []

    var exercise: Exercise? { ExerciseDatabase.byID[exerciseID] }
    var completedSets: [SetRecord] { sets.filter(\.isDone) }
    var displayName: String { exercise?.name ?? "已删除的动作" }
}

struct WorkoutSession: Codable, Identifiable, Hashable {
    var id = UUID()
    var name: String
    /// 从网页版备份导入时保留原 id，用于重复导入去重
    var legacyID: String?
    var createdAt = Date()
    /// nil 表示「准备态」：还没点开始，计时未启动。对应网页版的 started=false。
    var startedAt: Date?
    var finishedAt: Date?
    var entries: [WorkoutEntry] = []
    /// 结束后固化的汇总，历史记录不再依赖实时计算
    var durationMinutes = 0
    var totalSets = 0
    var volume = 0.0
    var kcal = 0.0

    var isRunning: Bool { startedAt != nil && finishedAt == nil }
    var isFinished: Bool { finishedAt != nil }
    var completedSets: Int { entries.reduce(0) { $0 + $1.completedSets.count } }

    var elapsed: TimeInterval {
        guard let startedAt else { return 0 }
        return (finishedAt ?? Date()).timeIntervalSince(startedAt)
    }

    mutating func recalculate(bodyWeight: Double = 70) {
        var vol = 0.0
        var done = 0
        var minutes = 0.0
        for entry in entries {
            for set in entry.completedSets {
                done += 1
                let ex = entry.exercise
                if ex?.unit == .minutes {
                    minutes += Double(set.reps)
                } else {
                    vol += (set.weight + (ex?.isSelfweight == true ? bodyWeight : 0)) * Double(set.reps)
                }
            }
        }
        totalSets = done
        volume = vol
        durationMinutes = max(1, Int((elapsed / 60).rounded()))
        let activeMinutes = minutes > 0 ? minutes : max(1.0, elapsed / 60)
        kcal = (exerciseMET * 3.5 * bodyWeight * activeMinutes) / 200
    }

    private var exerciseMET: Double {
        let mets = entries.compactMap { $0.exercise?.met }
        guard !mets.isEmpty else { return 5.0 }
        return mets.reduce(0, +) / Double(mets.count)
    }
}

// MARK: - 应用状态

struct AppSettings: Codable, Equatable {
    var sound = true
    var vibrate = true
    var notify = true
    var defaultRest = 90
    var bodyWeight = 70.0
}

struct AppData: Codable {
    var settings = AppSettings()
    var active: WorkoutSession?
    var sessions: [WorkoutSession] = []
}
