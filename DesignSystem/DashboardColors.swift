import SwiftUI
import AppIntents

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: opacity)
    }
}

struct DashboardPalette {
    let background: Color   // the mat
    let text: Color         // paper
    let muted: Color        // secondary text
    let rule: Color         // divider lines
    let gridMinor: Color
    let gridMajor: Color
    let signal: Color       // orange: today, dots, "today?"
    let onSignal: Color     // text on an orange block
}

enum DashboardTheme: String, AppEnum {
    case studio, creatorMat, editorial

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Theme"
    static var caseDisplayRepresentations: [DashboardTheme: DisplayRepresentation] = [
        .studio: "Studio",
        .creatorMat: "Creator Mat",
        .editorial: "Editorial"
    ]

    var palette: DashboardPalette {
        switch self {
        case .studio:
            // Matches the "Who are you going to be today?" wallpaper
            return DashboardPalette(background: Color(hex: 0x10251C),
                                    text: Color(hex: 0xEFE8D6),
                                    muted: Color(hex: 0xA2A99C),
                                    rule: Color(hex: 0xEFE8D6, opacity: 0.30),
                                    gridMinor: Color(hex: 0xECE5D3, opacity: 0.045),
                                    gridMajor: Color(hex: 0xECE5D3, opacity: 0.095),
                                    signal: Color(hex: 0xFF4A1C),
                                    onSignal: Color(hex: 0xEFE8D6))
        case .creatorMat:
            // Tokens from spec/DESIGN_TOKENS.json
            return DashboardPalette(background: Color(hex: 0x0E2F24),
                                    text: Color(hex: 0xF4F1E9),
                                    muted: Color(hex: 0x9AA49D),
                                    rule: Color(hex: 0x9AA49D, opacity: 0.55),
                                    gridMinor: Color(hex: 0x2D4F42, opacity: 0.55),
                                    gridMajor: Color(hex: 0x2D4F42),
                                    signal: Color(hex: 0xFF3B0F),
                                    onSignal: Color(hex: 0xF4F1E9))
        case .editorial:
            return DashboardPalette(background: Color(hex: 0xF4F1E9),
                                    text: Color(hex: 0x0E2F24),
                                    muted: Color(hex: 0x5C6B63),
                                    rule: Color(hex: 0x0E2F24, opacity: 0.28),
                                    gridMinor: Color(hex: 0x0E2F24, opacity: 0.04),
                                    gridMajor: Color(hex: 0x0E2F24, opacity: 0.08),
                                    signal: Color(hex: 0xFF3B0F),
                                    onSignal: Color(hex: 0xF4F1E9))
        }
    }
}
