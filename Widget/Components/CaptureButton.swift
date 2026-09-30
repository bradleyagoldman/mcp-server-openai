import SwiftUI

/// Thin outlined circle with a plus. Opens the app's Don't Forget capture.
struct CaptureButton: View {
    let c: PanelContext

    static let url = URL(string: "creatordash://capture")!

    var body: some View {
        Link(destination: Self.url) {
            ZStack {
                Circle().stroke(c.p.text, lineWidth: max(0.75, c.s(0.9)))
                Image(systemName: "plus")
                    .font(.system(size: c.s(c.m.plus * 0.5), weight: .light))
                    .foregroundColor(c.p.text)
            }
            .frame(width: c.s(c.m.plus), height: c.s(c.m.plus))
        }
    }
}
