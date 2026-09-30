import SwiftUI

/// Thin straight divider lines
struct HRule: View {
    let color: Color
    var weight: CGFloat = 0.75

    var body: some View {
        Rectangle().fill(color).frame(height: weight)
    }
}

struct VRule: View {
    let color: Color
    var weight: CGFloat = 0.75

    var body: some View {
        Rectangle().fill(color).frame(width: weight)
    }
}

/// Small thin chevron used as a directional arrow
struct ArrowMark: View {
    let color: Color
    let size: CGFloat

    var body: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: size, weight: .light))
            .foregroundColor(color)
    }
}
