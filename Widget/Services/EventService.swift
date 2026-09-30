import Foundation
import EventKit

struct NextEvent {
    let title: String
    let start: Date
    let allDay: Bool
}

/// Calendar (next event, KK / Family) and Reminders (Don't Forget)
enum EventService {
    /// A calendar counts as family if its name has the word "family" or "KK"
    static func isFamily(_ calendarName: String) -> Bool {
        let words = calendarName.lowercased().split { !$0.isLetter }
        return words.contains("kk") || calendarName.lowercased().contains("family")
    }

    static func upcoming(now: Date) -> (next: NextEvent?, family: String?) {
        guard EKEventStore.authorizationStatus(for: .event) == .fullAccess else { return (nil, nil) }
        let store = EKEventStore()
        let cal = Calendar.current
        let today = cal.startOfDay(for: now)
        let horizon = cal.date(byAdding: .day, value: 7, to: today) ?? now.addingTimeInterval(7 * 86_400)
        let predicate = store.predicateForEvents(withStart: today, end: horizon, calendars: nil)
        let events = store.events(matching: predicate)
            .filter { $0.endDate > now }
            .sorted { $0.startDate < $1.startDate }

        let familyIDs = Set(store.calendars(for: .event)
            .filter { isFamily($0.title) }
            .map { $0.calendarIdentifier })
        func inFamily(_ e: EKEvent) -> Bool { familyIDs.contains(e.calendar.calendarIdentifier) }

        // Keep showing an event for 15 minutes after it starts
        let grace = now.addingTimeInterval(-15 * 60)
        let timed = events.filter { !$0.isAllDay && $0.startDate >= grace }
        let nextEvent = timed.first { !inFamily($0) } ?? timed.first
        let next = nextEvent.map { NextEvent(title: $0.title ?? "Event", start: $0.startDate, allDay: false) }

        let familyEvent = events.first { inFamily($0) && ($0.isAllDay || $0.startDate >= grace) }
        let family = familyEvent.map { describe($0) }
        return (next, family)
    }

    /// "Cheer 4:30 PM", "Cheer · Tue 4:30 PM", "Game day · All day"
    private static func describe(_ event: EKEvent) -> String {
        let title = event.title ?? "Event"
        if event.isAllDay { return "\(title) · All day" }
        let time = TimeParts.short(event.startDate)
        if Calendar.current.isDateInToday(event.startDate) { return "\(title) \(time)" }
        return "\(title) · " + event.startDate.formatted(.dateTime.weekday(.abbreviated)) + " \(time)"
    }

    /// The most pressing open reminder: soonest due date first, then the newest
    static func nextReminder() async -> String? {
        guard EKEventStore.authorizationStatus(for: .reminder) == .fullAccess else { return nil }
        let store = EKEventStore()
        let predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)
        let reminders: [EKReminder] = await withCheckedContinuation { cont in
            store.fetchReminders(matching: predicate) { cont.resume(returning: $0 ?? []) }
        }
        withExtendedLifetime(store) {}

        let cal = Calendar.current
        func due(_ r: EKReminder) -> Date? { r.dueDateComponents.flatMap { cal.date(from: $0) } }
        let sorted = reminders.sorted { a, b in
            switch (due(a), due(b)) {
            case let (x?, y?): return x < y
            case (.some, .none): return true
            case (.none, .some): return false
            default: return (a.creationDate ?? .distantPast) > (b.creationDate ?? .distantPast)
            }
        }
        let title = sorted.first?.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        return (title?.isEmpty ?? true) ? nil : title
    }
}
