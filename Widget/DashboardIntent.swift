import AppIntents
import WidgetKit

/// What you can change from Edit Widget
struct DashboardConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Creator Dashboard"
    static var description = IntentDescription("Theme, font, text size and your fallback notes.")

    @Parameter(title: "Theme", default: .studio)
    var theme: DashboardTheme

    @Parameter(title: "Font", default: .grotesk)
    var font: DashboardFont

    @Parameter(title: "Text Size", default: .standard)
    var textSize: DashboardTextSize

    @Parameter(title: "Don't Forget", description: "Shown when Reminders has nothing open.")
    var dontForget: String?

    @Parameter(title: "KK / Family", description: "Shown when no Family or KK calendar event is coming up.")
    var family: String?
}
