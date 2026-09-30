import SwiftUI
import WidgetKit

struct DashboardWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: DashboardEntry

    var body: some View {
        let palette = entry.theme.palette
        GeometryReader { geo in
            let metrics: DashboardMetrics = family == .systemLarge ? .large : .medium
            let u = metrics.unit(for: geo.size)
            let context = PanelContext(m: metrics,
                                       t: DashboardType(font: entry.font, scale: u * entry.textScale),
                                       p: palette, u: u)
            DashboardPanel(snapshot: entry.snapshot, c: context, size: geo.size)
        }
        .containerBackground(for: .widget) {
            CuttingMatBackground(palette: palette)
        }
    }
}
