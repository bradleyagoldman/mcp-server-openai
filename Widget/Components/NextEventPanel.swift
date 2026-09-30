import SwiftUI

/// NEXT / 9:30 AM / NBS TEAM →   (only the next event, never an agenda)
struct NextEventPanel: View {
    let s: DashboardSnapshot
    let c: PanelContext

    private var label: String {
        guard let start = s.nextStart, !Calendar.current.isDateInToday(start) else { return "NEXT" }
        return "NEXT · " + start.formatted(.dateTime.weekday(.abbreviated)).uppercased()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PanelLabel(text: label, c: c)
            Spacer(minLength: 0)
            time
            HStack(spacing: c.s(4)) {
                Text((s.nextTitle ?? "Nothing scheduled").uppercased())
                    .font(c.t.sans(c.m.nextTitle, .medium))
                    .tracking(c.t.labelTracking(c.m.nextTitle))
                    .foregroundColor(c.p.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Spacer(minLength: 0)
                if s.nextTitle != nil {
                    ArrowMark(color: c.p.text, size: c.f(c.m.nextTitle))
                }
            }
        }
    }

    @ViewBuilder private var time: some View {
        if let start = s.nextStart, !s.nextAllDay {
            let parts = TimeParts.split(start)
            (Text(parts.clock).font(c.t.value(c.m.nextTime, .medium))
             + Text(parts.meridiem).font(c.t.value(c.m.nextMeridiem, .medium)))
                .foregroundColor(c.p.text)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        } else {
            Text(s.nextTitle == nil ? "—" : "All day")
                .font(c.t.value(c.m.nextTime, .medium))
                .foregroundColor(c.p.text)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}
