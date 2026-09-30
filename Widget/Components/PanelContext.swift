import SwiftUI

/// Everything a panel needs to draw itself at the current widget size
struct PanelContext {
    let m: DashboardMetrics
    let t: DashboardType
    let p: DashboardPalette
    /// Geometry scale for the current widget size
    let u: CGFloat

    func s(_ value: CGFloat) -> CGFloat { value * u }
    /// Font-size-linked scale (widget size × chosen text size)
    func f(_ value: CGFloat) -> CGFloat { value * t.scale }
}

extension View {
    /// Standard inner padding for one module of the panel
    func cell(_ c: PanelContext) -> some View {
        padding(.horizontal, c.s(c.m.cellPadH))
            .padding(.vertical, c.s(c.m.cellPadV))
    }
}

/// Small uppercase module label: NEXT, DON'T FORGET, KK / FAMILY
struct PanelLabel: View {
    let text: String
    let c: PanelContext

    var body: some View {
        Text(text)
            .font(c.t.sans(c.m.label, .medium))
            .tracking(c.t.labelTracking(c.m.label))
            .foregroundColor(c.p.text)
            .lineLimit(1)
    }
}

enum TimeParts {
    /// "9:30" and "AM"
    static func split(_ date: Date) -> (clock: String, meridiem: String) {
        let parts = Calendar.current.dateComponents([.hour, .minute], from: date)
        let h24 = parts.hour ?? 0
        let hour = (h24 + 11) % 12 + 1
        return ("\(hour):" + String(format: "%02d", parts.minute ?? 0), h24 < 12 ? "AM" : "PM")
    }

    static func short(_ date: Date) -> String {
        let p = split(date)
        return "\(p.clock) \(p.meridiem)"
    }
}
