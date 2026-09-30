import SwiftUI

/// Evenly spaced vertical and horizontal lines
struct GridOverlay: Shape {
    var step: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard step > 1 else { return path }
        var x: CGFloat = 0
        while x <= rect.width {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: rect.height))
            x += step
        }
        var y: CGFloat = 0
        while y <= rect.height {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: rect.width, y: y))
            y += step
        }
        return path
    }
}

/// Ruler ticks along all four edges: short every step, long every `majorEvery`
struct EdgeTicks: Shape {
    var step: CGFloat
    var majorEvery: Int
    var minorLength: CGFloat = 2.5
    var majorLength: CGFloat = 5

    func path(in rect: CGRect) -> Path {
        var path = Path()
        guard step > 1 else { return path }
        var i = 0
        var x: CGFloat = 0
        while x <= rect.width {
            let l = i % majorEvery == 0 ? majorLength : minorLength
            path.move(to: CGPoint(x: x, y: 0)); path.addLine(to: CGPoint(x: x, y: l))
            path.move(to: CGPoint(x: x, y: rect.height)); path.addLine(to: CGPoint(x: x, y: rect.height - l))
            x += step; i += 1
        }
        i = 0
        var y: CGFloat = 0
        while y <= rect.height {
            let l = i % majorEvery == 0 ? majorLength : minorLength
            path.move(to: CGPoint(x: 0, y: y)); path.addLine(to: CGPoint(x: l, y: y))
            path.move(to: CGPoint(x: rect.width, y: y)); path.addLine(to: CGPoint(x: rect.width - l, y: y))
            y += step; i += 1
        }
        return path
    }
}
