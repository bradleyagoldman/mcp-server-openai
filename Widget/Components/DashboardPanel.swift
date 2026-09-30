import SwiftUI

/// The whole instrument panel: four straight rows split by thin rules.
/// Shared by the widget and the in-app preview.
struct DashboardPanel: View {
    let snapshot: DashboardSnapshot
    let c: PanelContext
    let size: CGSize

    var body: some View {
        let m = c.m
        let pad = c.s(m.outerPad)
        let w = size.width - pad * 2
        let h = size.height - pad * 2
        let rw = max(0.5, c.s(m.rule))
        let rows = m.rows.map { $0 * (h - rw * 3) }
        let leftW = (w - rw) * m.columnSplit
        let calendarW = (w - rw) * m.calendarSplit
        let plusW = c.s(m.plus + m.cellPadH * 2)
        let mark = c.s(m.isLarge ? 12 : 9)

        VStack(spacing: 0) {
            HStack(spacing: 0) {
                CalendarStrip(date: snapshot.date, c: c)
                    .cell(c)
                    .frame(width: calendarW, height: rows[0], alignment: .leading)
                VRule(color: c.p.rule, weight: rw)
                WeatherPanel(s: snapshot, c: c)
                    .cell(c)
                    .frame(maxWidth: .infinity)
                    .frame(height: rows[0])
            }
            .frame(height: rows[0])
            HRule(color: c.p.rule, weight: rw)
            HStack(spacing: 0) {
                NextEventPanel(s: snapshot, c: c)
                    .cell(c)
                    .frame(width: leftW, height: rows[1], alignment: .leading)
                VRule(color: c.p.rule, weight: rw)
                BodyMetricsPanel(s: snapshot, c: c)
                    .padding(.leading, c.s(m.cellPadH * 1.3))
                    .cell(c)
                    .frame(maxWidth: .infinity)
                    .frame(height: rows[1])
            }
            .frame(height: rows[1])
            HRule(color: c.p.rule, weight: rw)
            HStack(spacing: 0) {
                DontForgetPanel(s: snapshot, c: c)
                    .cell(c)
                    .frame(width: leftW, height: rows[2], alignment: .leading)
                VRule(color: c.p.rule, weight: rw)
                FamilyPanel(s: snapshot, c: c)
                    .cell(c)
                    .frame(maxWidth: .infinity)
                    .frame(height: rows[2])
            }
            .frame(height: rows[2])
            HRule(color: c.p.rule, weight: rw)
            HStack(spacing: 0) {
                QuoteStrip(c: c, hero: m.isLarge)
                    .cell(c)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: rows[3])
                VRule(color: c.p.rule, weight: rw)
                CaptureButton(c: c)
                    .padding(.bottom, m.isLarge ? c.s(m.cellPadH) : 0)
                    .frame(width: plusW, height: rows[3], alignment: m.isLarge ? .bottom : .center)
            }
            .frame(height: rows[3])
        }
        .frame(width: w, height: h)
        .overlay {
            RoundedRectangle(cornerRadius: c.s(m.frameRadius))
                .stroke(c.p.rule, lineWidth: rw)
        }
        // Crosshair where the middle rules meet
        .overlay(alignment: .topLeading) {
            Crosshair()
                .stroke(c.p.text.opacity(0.85), lineWidth: rw)
                .frame(width: mark, height: mark)
                .offset(x: leftW + rw / 2 - mark / 2, y: rows[0] + rw + rows[1] + rw / 2 - mark / 2)
        }
        // Registration mark in the corner of the body module
        .overlay(alignment: .topTrailing) {
            RegistrationMark()
                .stroke(c.p.muted.opacity(0.7), lineWidth: max(0.5, rw * 0.8))
                .frame(width: mark * 0.8, height: mark * 0.8)
                .offset(x: -c.s(5), y: rows[0] + rw + c.s(5))
        }
        .padding(pad)
    }
}
