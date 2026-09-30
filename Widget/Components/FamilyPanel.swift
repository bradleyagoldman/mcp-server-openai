import SwiftUI

/// KK / FAMILY / Cheer 4:30 PM →
struct FamilyPanel: View {
    let s: DashboardSnapshot
    let c: PanelContext

    private var icon: some View {
        Image(systemName: SymbolName.family)
            .font(.system(size: c.f(c.m.label * 1.05), weight: .light))
            .foregroundColor(c.p.text)
            .frame(width: c.f(c.m.label * 1.7))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: c.s(5)) {
                icon
                PanelLabel(text: "KK / FAMILY", c: c)
            }
            Spacer(minLength: 0)
            HStack(spacing: c.s(5)) {
                icon
                Text(s.family ?? "Nothing planned")
                    .font(c.t.sans(c.m.note, .regular))
                    .foregroundColor(s.family == nil ? c.p.muted : c.p.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer(minLength: 0)
                if s.family != nil {
                    ArrowMark(color: c.p.text, size: c.f(c.m.note * 0.9))
                }
            }
        }
    }
}
