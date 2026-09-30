import SwiftUI

/// Layout proportions and type sizes for each widget size.
/// Sizes are in points for a 364×170 medium (iPhone Pro Max) and are
/// scaled to the real widget size at runtime, so nothing is hard-coded to one screen.
struct DashboardMetrics {
    let isLarge: Bool
    let designHeight: CGFloat
    let designWidth: CGFloat

    let outerPad: CGFloat
    let cellPadH: CGFloat
    let cellPadV: CGFloat
    let frameRadius: CGFloat

    /// Row heights as fractions of the inner height:
    /// calendar+weather, next+body, don't forget+family, quote
    let rows: [CGFloat]
    /// Where the calendar ends and weather starts (fraction of inner width)
    let calendarSplit: CGFloat
    /// Left/right column split for the middle rows
    let columnSplit: CGFloat

    let label: CGFloat
    let calMonth: CGFloat
    let calDay: CGFloat
    let calCell: CGSize
    let city: CGFloat
    let temp: CGFloat
    let weatherIcon: CGFloat
    let hiLo: CGFloat
    let nextTime: CGFloat
    let nextMeridiem: CGFloat
    let nextTitle: CGFloat
    let metric: CGFloat
    let metricUnit: CGFloat
    let metricLabel: CGFloat
    let bodyIcon: CGFloat
    let note: CGFloat
    let quote: CGFloat
    let plus: CGFloat
    let rule: CGFloat

    static let medium = DashboardMetrics(
        isLarge: false, designHeight: 170, designWidth: 364,
        outerPad: 5, cellPadH: 10, cellPadV: 3.5, frameRadius: 17,
        rows: [0.26, 0.33, 0.205, 0.205],
        calendarSplit: 0.675, columnSplit: 0.535,
        label: 7.5, calMonth: 8.5, calDay: 10.5, calCell: CGSize(width: 17, height: 14),
        city: 6.8, temp: 19, weatherIcon: 13, hiLo: 6.6,
        nextTime: 20, nextMeridiem: 12.5, nextTitle: 8.5,
        metric: 12.5, metricUnit: 8, metricLabel: 6.5, bodyIcon: 12,
        note: 9, quote: 12.5, plus: 20, rule: 0.75)

    static let large = DashboardMetrics(
        isLarge: true, designHeight: 382, designWidth: 364,
        outerPad: 7, cellPadH: 13, cellPadV: 8, frameRadius: 17,
        rows: [0.17, 0.30, 0.17, 0.36],
        calendarSplit: 0.66, columnSplit: 0.535,
        label: 10, calMonth: 11.5, calDay: 15, calCell: CGSize(width: 24, height: 20),
        city: 9.5, temp: 32, weatherIcon: 20, hiLo: 8.5,
        nextTime: 32, nextMeridiem: 19, nextTitle: 12,
        metric: 19, metricUnit: 11.5, metricLabel: 9, bodyIcon: 18,
        note: 12.5, quote: 31, plus: 30, rule: 0.9)

    /// How much to scale the design sizes to fit the real widget
    func unit(for size: CGSize) -> CGFloat {
        isLarge ? min(size.width / designWidth, size.height / designHeight) : size.height / designHeight
    }
}
