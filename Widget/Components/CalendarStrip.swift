import SwiftUI

/// SEP / 28 29 [30] 01 02 03 04 with today as a square orange block
struct CalendarStrip: View {
    let date: Date
    let c: PanelContext

    private var cal: Calendar { Calendar(identifier: .gregorian) }

    var body: some View {
        let today = cal.startOfDay(for: date)
        let days = (-2...4).compactMap { cal.date(byAdding: .day, value: $0, to: today) }
        VStack(alignment: .leading, spacing: 0) {
            Text(date.formatted(.dateTime.month(.abbreviated)).uppercased())
                .font(c.t.sans(c.m.calMonth, .semibold))
                .tracking(c.t.labelTracking(c.m.calMonth))
                .foregroundColor(c.p.text)
            Spacer(minLength: 0)
            HStack(spacing: 0) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    let isToday = index == 2
                    Text(String(format: "%02d", cal.component(.day, from: day)))
                        .font(c.t.value(c.m.calDay, .regular))
                        .foregroundColor(isToday ? c.p.onSignal : c.p.text)
                        .frame(width: c.f(c.m.calCell.width), height: c.f(c.m.calCell.height))
                        .background(Rectangle().fill(isToday ? c.p.signal : Color.clear))
                    if index < days.count - 1 { Spacer(minLength: 0) }
                }
            }
        }
    }
}
