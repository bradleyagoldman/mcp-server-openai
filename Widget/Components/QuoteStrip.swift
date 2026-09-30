import SwiftUI

/// "Who are you going to be today?" (one line), or the three-line hero
/// with "today?" in signal orange for the large widget.
struct QuoteStrip: View {
    let c: PanelContext
    let hero: Bool

    var body: some View {
        if hero {
            VStack(alignment: .leading, spacing: -c.f(c.m.quote * 0.14)) {
                Text("Who are you")
                Text("going to be")
                Text("today?").foregroundColor(c.p.signal)
            }
            .font(c.t.sans(c.m.quote, .semibold))
            .tracking(-c.f(c.m.quote) * 0.035)
            .foregroundColor(c.p.text)
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        } else {
            Text("Who are you going to be today?")
                .font(c.t.sans(c.m.quote, .medium))
                .tracking(-c.f(c.m.quote) * 0.01)
                .foregroundColor(c.p.text)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }
}
