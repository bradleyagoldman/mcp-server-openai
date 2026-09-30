import SwiftUI

/// Circle with a cross through it, like a print registration mark
struct RegistrationMark: Shape {
    var ringRatio: CGFloat = 0.32

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let c = CGPoint(x: rect.midX, y: rect.midY)
        let r = min(rect.width, rect.height) * ringRatio
        path.addEllipse(in: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
        path.move(to: CGPoint(x: rect.minX, y: c.y)); path.addLine(to: CGPoint(x: rect.maxX, y: c.y))
        path.move(to: CGPoint(x: c.x, y: rect.minY)); path.addLine(to: CGPoint(x: c.x, y: rect.maxY))
        return path
    }
}

/// Plain plus-shaped crosshair for grid intersections
struct Crosshair: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY)); path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.move(to: CGPoint(x: rect.midX, y: rect.minY)); path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        return path
    }
}
