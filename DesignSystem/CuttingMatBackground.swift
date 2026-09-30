import SwiftUI

/// Dark matte cutting mat: minor + major grid, edge ruler ticks and one faint
/// construction line. Kept quiet so the content always reads first.
struct CuttingMatBackground: View {
    let palette: DashboardPalette
    var minor: CGFloat = 8
    var majorEvery: Int = 5

    var body: some View {
        GeometryReader { geo in
            ZStack {
                palette.background
                GridOverlay(step: minor)
                    .stroke(palette.gridMinor, lineWidth: 0.5)
                GridOverlay(step: minor * CGFloat(majorEvery))
                    .stroke(palette.gridMajor, lineWidth: 0.6)
                EdgeTicks(step: minor, majorEvery: majorEvery)
                    .stroke(palette.muted.opacity(0.45), lineWidth: 0.6)
                // Construction line
                Path { p in
                    let y = (geo.size.height * 0.62 / minor).rounded() * minor
                    p.move(to: CGPoint(x: 0, y: y))
                    p.addLine(to: CGPoint(x: geo.size.width, y: y))
                }
                .stroke(palette.gridMajor, style: StrokeStyle(lineWidth: 0.6, dash: [3, 3]))
            }
        }
    }
}
