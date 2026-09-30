import Foundation
import UIKit

/// Everything the widget shows, already worked out
struct DashboardSnapshot {
    var date: Date
    var city: String
    var temperature: Int?
    var high: Int?
    var low: Int?
    var weatherSymbol: String
    var nextStart: Date?
    var nextTitle: String?
    var nextAllDay: Bool
    var sleepMinutes: Int?
    var steps: Int?
    var dontForget: String?
    var family: String?

    /// The exact first-pass data from the handoff spec
    static func placeholder(date: Date = Date()) -> DashboardSnapshot {
        let nineThirty = Calendar.current.date(bySettingHour: 9, minute: 30, second: 0, of: date) ?? date
        return DashboardSnapshot(date: date, city: "Los Angeles", temperature: 72, high: 78, low: 58,
                                 weatherSymbol: "sun.max", nextStart: nineThirty, nextTitle: "NBS Team",
                                 nextAllDay: false, sleepMinutes: 6 * 60 + 42, steps: 4821,
                                 dontForget: "Call Mom re: Kia key", family: "Cheer 4:30 PM")
    }
}

enum SymbolName {
    /// Use the preferred SF Symbol when this iOS version has it
    static func pick(_ preferred: String, _ fallback: String) -> String {
        UIImage(systemName: preferred) != nil ? preferred : fallback
    }

    static var bed: String { pick("bed.double", "bed.double.fill") }
    static var shoe: String { pick("shoe", "figure.walk") }
    static var family: String { pick("figure.2.and.child.holdinghands", "person.2") }

    /// Open-Meteo (WMO) weather code to an outline SF Symbol
    static func weather(code: Int, isDay: Bool) -> String {
        switch code {
        case 0, 1: return isDay ? "sun.max" : "moon"
        case 2: return isDay ? "cloud.sun" : "cloud.moon"
        case 3: return "cloud"
        case 45, 48: return "cloud.fog"
        case 51...67, 80...82: return "cloud.rain"
        case 71...77, 85, 86: return "cloud.snow"
        case 95...99: return "cloud.bolt"
        default: return "cloud"
        }
    }
}
