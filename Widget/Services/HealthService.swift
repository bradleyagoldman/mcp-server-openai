import Foundation
import HealthKit

struct HealthNumbers: Codable {
    var steps: Int?
    var sleepMinutes: Int?
    var day: Date
}

/// Steps today and sleep last night from the Health app
enum HealthService {
    static func load(now: Date) async -> HealthNumbers {
        let cal = Calendar.current
        let cached = Store.load(HealthNumbers.self, "health").flatMap {
            cal.isDate($0.day, inSameDayAs: now) ? $0 : nil
        }
        guard HKHealthStore.isHealthDataAvailable() else {
            return HealthNumbers(steps: nil, sleepMinutes: nil, day: now)
        }
        let store = HKHealthStore()
        let steps = await stepCount(store, from: cal.startOfDay(for: now), to: now)
        let sleep = await sleepMinutes(store, now: now)
        // Health data is locked while the phone is locked, so keep the last reading
        let result = HealthNumbers(steps: steps ?? cached?.steps,
                                   sleepMinutes: sleep ?? cached?.sleepMinutes,
                                   day: now)
        Store.save(result, "health")
        return result
    }

    private static func stepCount(_ store: HKHealthStore, from start: Date, to end: Date) async -> Int? {
        let type = HKQuantityType(.stepCount)
        let predicate = HKSamplePredicate.quantitySample(
            type: type, predicate: HKQuery.predicateForSamples(withStart: start, end: end))
        let query = HKStatisticsQueryDescriptor(predicate: predicate, options: .cumulativeSum)
        guard let stats = try? await query.result(for: store),
              let sum = stats.sumQuantity() else { return nil }
        return Int(sum.doubleValue(for: .count()))
    }

    /// Time asleep since 6 PM yesterday, with overlapping records
    /// (for example iPhone and Apple Watch) counted once
    private static func sleepMinutes(_ store: HKHealthStore, now: Date) async -> Int? {
        let cal = Calendar.current
        guard let from = cal.date(byAdding: .hour, value: -6, to: cal.startOfDay(for: now)) else { return nil }
        let type = HKCategoryType(.sleepAnalysis)
        let predicate = HKSamplePredicate.categorySample(
            type: type, predicate: HKQuery.predicateForSamples(withStart: from, end: now))
        let query = HKSampleQueryDescriptor(predicates: [predicate],
                                            sortDescriptors: [SortDescriptor(\.startDate)])
        guard let samples = try? await query.result(for: store) else { return nil }

        let asleep = Set(HKCategoryValueSleepAnalysis.allAsleepValues.map { $0.rawValue })
        let spans = samples
            .filter { asleep.contains($0.value) }
            .map { (start: $0.startDate, end: $0.endDate) }
            .sorted { $0.start < $1.start }

        var total: TimeInterval = 0
        var current: (start: Date, end: Date)?
        for span in spans {
            if let c = current, span.start <= c.end {
                current = (c.start, max(c.end, span.end))
            } else {
                if let c = current { total += c.end.timeIntervalSince(c.start) }
                current = span
            }
        }
        if let c = current { total += c.end.timeIntervalSince(c.start) }
        return total > 0 ? Int(total / 60) : nil
    }
}
