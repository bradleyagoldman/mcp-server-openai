import WidgetKit
import SwiftUI

@main
struct CreatorDashboardBundle: WidgetBundle {
    var body: some Widget {
        CreatorDashboardWidget()
    }
}

struct CreatorDashboardWidget: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "CreatorDashboard", intent: DashboardConfigIntent.self,
                               provider: DashboardTimelineProvider()) { entry in
            DashboardWidgetView(entry: entry)
        }
        .configurationDisplayName("Creator Dashboard")
        .description("Calendar, weather, next event, sleep, steps and your notes.")
        .supportedFamilies([.systemMedium, .systemLarge])
        .contentMarginsDisabled()
    }
}

#Preview("Medium", as: .systemMedium) {
    CreatorDashboardWidget()
} timeline: {
    DashboardEntry.preview()
}

#Preview("Large", as: .systemLarge) {
    CreatorDashboardWidget()
} timeline: {
    DashboardEntry.preview()
}
