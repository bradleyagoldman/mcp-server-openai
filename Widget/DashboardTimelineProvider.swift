import WidgetKit
import SwiftUI

struct DashboardEntry: TimelineEntry {
    let date: Date
    let snapshot: DashboardSnapshot
    let theme: DashboardTheme
    let font: DashboardFont
    let textScale: CGFloat

    static func preview(_ config: DashboardConfigIntent = DashboardConfigIntent()) -> DashboardEntry {
        DashboardEntry(date: Date(), snapshot: .placeholder(), theme: config.theme,
                       font: config.font, textScale: config.textSize.scale)
    }
}

struct DashboardTimelineProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> DashboardEntry {
        .preview()
    }

    func snapshot(for configuration: DashboardConfigIntent, in context: Context) async -> DashboardEntry {
        if context.isPreview { return .preview(configuration) }
        return await entry(for: configuration, now: Date())
    }

    func timeline(for configuration: DashboardConfigIntent, in context: Context) async -> Timeline<DashboardEntry> {
        let now = Date()
        let entry = await entry(for: configuration, now: now)
        // Refresh every 20 minutes, just after the next event starts, and at midnight
        var refresh = now.addingTimeInterval(20 * 60)
        if let start = entry.snapshot.nextStart, !entry.snapshot.nextAllDay {
            refresh = min(refresh, max(now.addingTimeInterval(60), start.addingTimeInterval(15 * 60 + 5)))
        }
        if let midnight = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: now)) {
            refresh = min(refresh, midnight.addingTimeInterval(5))
        }
        return Timeline(entries: [entry], policy: .after(refresh))
    }

    private func entry(for config: DashboardConfigIntent, now: Date) async -> DashboardEntry {
        let snapshot = await SnapshotBuilder.build(config: config, now: now)
        return DashboardEntry(date: now, snapshot: snapshot, theme: config.theme,
                              font: config.font, textScale: config.textSize.scale)
    }
}

enum SnapshotBuilder {
    static func build(config: DashboardConfigIntent, now: Date) async -> DashboardSnapshot {
        async let weather = WeatherService.load()
        async let health = HealthService.load(now: now)
        async let reminder = EventService.nextReminder()
        let events = EventService.upcoming(now: now)

        let w = await weather
        let h = await health
        let r = await reminder

        return DashboardSnapshot(
            date: now,
            city: w?.place ?? "",
            temperature: w.map { Int($0.temp.rounded()) },
            high: w.map { Int($0.high.rounded()) },
            low: w.map { Int($0.low.rounded()) },
            weatherSymbol: w.map { SymbolName.weather(code: $0.code, isDay: $0.isDay) } ?? "cloud",
            nextStart: events.next?.start,
            nextTitle: events.next?.title,
            nextAllDay: events.next?.allDay ?? false,
            sleepMinutes: h.sleepMinutes,
            steps: h.steps,
            dontForget: r ?? config.dontForget.nonEmpty,
            family: events.family ?? config.family.nonEmpty)
    }
}

extension Optional where Wrapped == String {
    var nonEmpty: String? {
        guard let text = self?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return nil }
        return text
    }
}
