import SwiftUI

/// DON'T FORGET / ● Call Mom re: Kia key
struct DontForgetPanel: View {
    let s: DashboardSnapshot
    let c: PanelContext

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            PanelLabel(text: "DON'T FORGET", c: c)
            Spacer(minLength: 0)
            HStack(spacing: c.s(6)) {
                if s.dontForget != nil {
                    Circle()
                        .fill(c.p.signal)
                        .frame(width: c.f(c.m.note * 0.8), height: c.f(c.m.note * 0.8))
                }
                Text(s.dontForget ?? "Nothing to remember")
                    .font(c.t.sans(c.m.note, .regular))
                    .foregroundColor(s.dontForget == nil ? c.p.muted : c.p.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }
}
