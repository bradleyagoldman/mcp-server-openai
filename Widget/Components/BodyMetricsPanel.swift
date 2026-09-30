import SwiftUI

/// 6H 42M SLEEP and 4,821 STEPS. The numbers lead; icons stay small.
struct BodyMetricsPanel: View {
    let s: DashboardSnapshot
    let c: PanelContext

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            row(icon: SymbolName.bed, value: sleepText, label: "SLEEP")
            Spacer(minLength: 0)
            row(icon: SymbolName.shoe, value: stepsText, label: "STEPS")
        }
    }

    private var sleepText: Text {
        guard let minutes = s.sleepMinutes else { return Text("—").font(c.t.value(c.m.metric)) }
        let big = c.t.value(c.m.metric)
        let small = c.t.value(c.m.metricUnit)
        return Text("\(minutes / 60)").font(big) + Text("H ").font(small)
            + Text("\(minutes % 60)").font(big) + Text("M").font(small)
    }

    private var stepsText: Text {
        Text(s.steps.map { $0.formatted() } ?? "—").font(c.t.value(c.m.metric))
    }

    private func row(icon: String, value: Text, label: String) -> some View {
        HStack(alignment: .center, spacing: c.s(c.m.isLarge ? 16 : 10)) {
            Image(systemName: icon)
                .font(.system(size: c.f(c.m.bodyIcon), weight: .light))
                .foregroundColor(c.p.text)
                .frame(width: c.f(c.m.bodyIcon * 1.7))
            VStack(alignment: .leading, spacing: 0) {
                value
                    .foregroundColor(c.p.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(label)
                    .font(c.t.sans(c.m.metricLabel, .medium))
                    .tracking(c.t.labelTracking(c.m.metricLabel))
                    .foregroundColor(c.p.text)
            }
            Spacer(minLength: 0)
        }
    }
}
