import Foundation
import UIKit

enum StoreError: LocalizedError {
    case badBackup
    case noSessions

    var errorDescription: String? {
        switch self {
        case .badBackup: return "这不是有效的健身记录备份文件"
        case .noSessions: return "备份里没有找到训练记录"
        }
    }
}

/// 单一数据源。JSON 落在 App 的 Documents 目录，不依赖网络、不依赖网页端。
@MainActor
final class WorkoutStore: ObservableObject {
    @Published var data: AppData = AppData() {
        didSet { save() }
    }

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return dir.appendingPathComponent("fitlog-native-v1.json", isDirectory: false)
    }()

    init() { load() }

    // MARK: 持久化

    private func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let raw = try Data(contentsOf: fileURL)
            data = try JSONDecoder().decode(AppData.self, from: raw)
        } catch {
            // 数据损坏时保住原文件，不静默覆盖用户记录
            let backup = fileURL.deletingLastPathComponent()
                .appendingPathComponent("fitlog-corrupt-\(Int(Date().timeIntervalSince1970)).json")
            try? FileManager.default.copyItem(at: fileURL, to: backup)
        }
    }

    func save() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let raw = try encoder.encode(data)
            try raw.write(to: fileURL, options: [.atomic])
        } catch { /* 存储失败不中断当前会话 */ }
    }

    // MARK: 会话生命周期

    /// 已有进行中的训练时不覆盖（网页版曾在这里静默清空记录）。
    @discardableResult
    func startFreeTraining() -> Bool {
        guard data.active == nil else { return false }
        data.active = WorkoutSession(name: "自由训练", startedAt: nil)
        return true
    }

    /// 从准备态按下「开始训练」：此刻才启动计时。
    func beginActive() {
        guard var session = data.active, session.startedAt == nil else { return }
        session.startedAt = Date()
        data.active = session
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func cancelActive() {
        data.active = nil
        NotificationManager.shared.cancelRest()
        UIApplication.shared.isIdleTimerDisabled = false
    }

    /// 结束训练并写入历史；没有完成任何一组时不产生记录。
    @discardableResult
    func finishActive() -> WorkoutSession? {
        guard var session = data.active else { return nil }
        session.finishedAt = Date()
        session.recalculate(bodyWeight: data.settings.bodyWeight)
        NotificationManager.shared.cancelRest()
        UIApplication.shared.isIdleTimerDisabled = false
        guard session.totalSets > 0 else {
            data.active = nil
            return nil
        }
        var d = data
        d.sessions.insert(session, at: 0)
        d.active = nil
        data = d
        return session
    }

    // MARK: 动作与组

    func addExercise(_ id: String) -> Bool {
        guard var session = data.active,
              let exercise = ExerciseDatabase.byID[id],
              !session.entries.contains(where: { $0.exerciseID == id }) else { return false }
        let reps = exercise.isCardio ? 20 : 10
        let weight = lastWeight(for: id)
        let sets = (0..<3).map { _ in SetRecord(weight: weight, reps: reps) }
        let entry = WorkoutEntry(
            exerciseID: id,
            restSeconds: Self.recommendedRest(for: exercise, reps: reps),
            sets: sets
        )
        session.entries.append(entry)
        data.active = session
        return true
    }

    func removeEntry(_ entryID: UUID) {
        guard var session = data.active else { return }
        session.entries.removeAll { $0.id == entryID }
        data.active = session
    }

    func addSet(to entryID: UUID) {
        guard var session = data.active,
              let ei = session.entries.firstIndex(where: { $0.id == entryID }) else { return }
        let last = session.entries[ei].sets.last
        let ex = session.entries[ei].exercise
        session.entries[ei].sets.append(
            SetRecord(weight: last?.weight ?? 0, reps: last?.reps ?? (ex?.isCardio == true ? 20 : 10))
        )
        data.active = session
    }

    func updateSet(entryID: UUID, setID: UUID, weight: Double? = nil, reps: Int? = nil) {
        guard var session = data.active,
              let ei = session.entries.firstIndex(where: { $0.id == entryID }),
              let si = session.entries[ei].sets.firstIndex(where: { $0.id == setID }) else { return }
        if let weight { session.entries[ei].sets[si].weight = max(0, weight) }
        if let reps { session.entries[ei].sets[si].reps = max(1, reps) }
        data.active = session
    }

    func setRest(entryID: UUID, seconds: Int) {
        guard var session = data.active,
              let ei = session.entries.firstIndex(where: { $0.id == entryID }) else { return }
        session.entries[ei].restSeconds = min(480, max(60, seconds))
        data.active = session
    }

    /// 打卡一组。返回该动作的组歇秒数，由视图决定是否启动倒计时。
    @discardableResult
    func toggleSetDone(entryID: UUID, setID: UUID) -> Int? {
        guard var session = data.active,
              let ei = session.entries.firstIndex(where: { $0.id == entryID }),
              let si = session.entries[ei].sets.firstIndex(where: { $0.id == setID }) else { return nil }
        let nowDone = !session.entries[ei].sets[si].isDone
        session.entries[ei].sets[si].isDone = nowDone
        session.entries[ei].sets[si].completedAt = nowDone ? Date() : nil
        session.recalculate(bodyWeight: data.settings.bodyWeight)
        data.active = session
        return nowDone ? session.entries[ei].restSeconds : nil
    }

    func lastWeight(for exerciseID: String) -> Double {
        for session in data.sessions {
            for entry in session.entries where entry.exerciseID == exerciseID {
                if let last = entry.completedSets.last { return last.weight }
            }
        }
        return 0
    }

    /// 组歇建议：与网页版一致，限定 60–480 秒。
    static func recommendedRest(for ex: Exercise, reps: Int) -> Int {
        if ex.isCardio { return 60 }
        if reps <= 5 { return 180 }
        if ex.met >= 6 { return 150 }
        return 90
    }

    // MARK: 网页版备份导入

    /// 解析网页版「导出数据」生成的 fitlog-YYYY-MM-DD.json。
    /// 只迁移历史 sessions；进行中的训练不迁移（避免把网页端未结束的会话带过来）。
    @discardableResult
    func importLegacyBackup(_ raw: Data) throws -> Int {
        guard let root = try? JSONSerialization.jsonObject(with: raw) as? [String: Any],
              let root else { throw StoreError.badBackup }
        let rawSessions = root["sessions"] as? [[String: Any]] ?? []
        guard !rawSessions.isEmpty else { throw StoreError.noSessions }

        let day = DateFormatter()
        day.dateFormat = "yyyy-MM-dd"

        var existing = Set(data.sessions.compactMap(\.legacyID))
        var imported: [WorkoutSession] = []
        for r in rawSessions {
            let legacyID = r["id"] as? String
            if let legacyID, existing.contains(legacyID) { continue }

            let startMs = Self.num(r["startTs"]) ?? Self.num(r["ts"]) ?? 0
            let endMs = Self.num(r["ts"]) ?? startMs
            let fallbackDate = (r["date"] as? String).flatMap { day.date(from: $0) } ?? Date()

            var session = WorkoutSession(name: r["name"] as? String ?? "训练记录")
            session.legacyID = legacyID
            session.createdAt = startMs > 0 ? Date(timeIntervalSince1970: startMs / 1000) : fallbackDate
            session.startedAt = session.createdAt
            session.finishedAt = endMs > 0 ? Date(timeIntervalSince1970: endMs / 1000) : fallbackDate
            session.durationMinutes = Int(Self.num(r["min"]) ?? 0)
            session.totalSets = Int(Self.num(r["sets"]) ?? 0)
            session.volume = Self.num(r["volume"]) ?? 0
            session.kcal = Self.num(r["kcal"]) ?? 0

            let rawEntries = r["entries"] as? [[String: Any]] ?? []
            for re in rawEntries {
                guard let exId = re["exId"] as? String,
                      ExerciseDatabase.byID[exId] != nil else { continue }
                let rawSets = re["sets"] as? [[String: Any]] ?? []
                let sets: [SetRecord] = rawSets.map { rs in
                    var record = SetRecord(
                        weight: Self.num(rs["weight"]) ?? 0,
                        reps: Int(Self.num(rs["reps"]) ?? 10)
                    )
                    record.isDone = (rs["done"] as? Bool) ?? true
                    return record
                }
                session.entries.append(WorkoutEntry(
                    exerciseID: exId,
                    note: re["note"] as? String ?? "",
                    restSeconds: Int(Self.num(re["rest"]) ?? 90),
                    sets: sets
                ))
            }
            imported.append(session)
            if let legacyID { existing.insert(legacyID) }
        }

        guard !imported.isEmpty else { return 0 }
        var d = data
        d.sessions.append(contentsOf: imported)
        d.sessions.sort { ($0.finishedAt ?? $0.createdAt) > ($1.finishedAt ?? $1.createdAt) }
        data = d
        return imported.count
    }

    private static func num(_ value: Any?) -> Double? {
        if let n = value as? NSNumber { return n.doubleValue }
        if let s = value as? String { return Double(s) }
        return nil
    }
}
