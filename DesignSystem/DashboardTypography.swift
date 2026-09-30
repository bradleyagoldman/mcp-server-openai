import SwiftUI
import AppIntents

enum DashboardFont: String, AppEnum {
    case grotesk, dotMatrix, mono

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Font"
    static var caseDisplayRepresentations: [DashboardFont: DisplayRepresentation] = [
        .grotesk: "Grotesk",
        .dotMatrix: "Dot Matrix",
        .mono: "Mono"
    ]
}

enum DashboardTextSize: String, AppEnum {
    case small, standard, large

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Text Size"
    static var caseDisplayRepresentations: [DashboardTextSize: DisplayRepresentation] = [
        .small: "Small",
        .standard: "Standard",
        .large: "Large"
    ]

    var scale: CGFloat {
        switch self {
        case .small: return 0.93
        case .standard: return 1
        case .large: return 1.07
        }
    }
}

/// Swiss/editorial type system. Labels and sentences are always Inter Tight;
/// the big values (times, temperature, counts) follow the chosen font.
struct DashboardType {
    enum Weight { case regular, medium, semibold, bold }

    let font: DashboardFont
    let scale: CGFloat

    func sans(_ size: CGFloat, _ weight: Weight = .medium) -> Font {
        let name: String
        switch weight {
        case .regular: name = "InterTight-Regular"
        case .medium: name = "InterTight-Medium"
        case .semibold: name = "InterTight-SemiBold"
        case .bold: name = "InterTight-Bold"
        }
        return .custom(name, fixedSize: size * scale)
    }

    func value(_ size: CGFloat, _ weight: Weight = .medium) -> Font {
        switch font {
        case .grotesk: return sans(size, weight)
        case .dotMatrix: return .custom("Doto-Bold", fixedSize: size * scale)
        case .mono: return .custom("IBMPlexMono-Medium", fixedSize: size * scale * 0.9)
        }
    }

    /// Tracking for small uppercase labels
    func labelTracking(_ size: CGFloat) -> CGFloat { size * scale * 0.06 }
}
