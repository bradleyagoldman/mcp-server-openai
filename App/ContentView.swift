import SwiftUI
import WidgetKit

struct ContentView: View {
    @Binding var capturing: Bool
    @StateObject private var perms = Permissions()
    @Environment(\.scenePhase) private var phase
    private let p = DashboardTheme.studio.palette

    var body: some View {
        ZStack {
            CuttingMatBackground(palette: p).ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Rectangle().fill(p.signal).frame(width: 64, height: 7)
                        .padding(.top, 20)
                    VStack(alignment: .leading, spacing: -6) {
                        Text("Creator")
                        Text("Dashboard").foregroundColor(p.signal)
                    }
                    .font(.custom("InterTight-SemiBold", size: 46))
                    .tracking(-1.2)
                    .foregroundColor(p.text)

                    sectionLabel("PREVIEW · SAMPLE DATA")
                    WidgetPreview(metrics: .medium, palette: p)
                    WidgetPreview(metrics: .large, palette: p)

                    sectionLabel("TURN ON")
                    PermissionRow(title: "Location", detail: "Weather where you are", status: perms.location, p: p) {
                        perms.askLocation()
                    }
                    PermissionRow(title: "Calendar", detail: "Next event and KK / Family", status: perms.calendar, p: p) {
                        Task { await perms.askCalendar() }
                    }
                    PermissionRow(title: "Reminders", detail: "Don't Forget", status: perms.reminders, p: p) {
                        Task { await perms.askReminders() }
                    }
                    PermissionRow(title: "Health", detail: "Sleep and steps", status: perms.health, p: p) {
                        Task { await perms.askHealth() }
                    }

                    sectionLabel("HOW IT FILLS IN")
                    VStack(alignment: .leading, spacing: 10) {
                        note("Don't Forget shows your most urgent open reminder. Tap + on the widget to add one.")
                        note("KK / Family shows the next event from any calendar with Family or KK in its name.")
                        note("You can also type fallback text for both in Edit Widget.")
                    }

                    sectionLabel("ADD THE WIDGET")
                    VStack(alignment: .leading, spacing: 10) {
                        note("1  Touch and hold the Home Screen, tap Edit, then Add Widget.")
                        note("2  Search Creator Dashboard, pick Medium or Large, tap Add Widget.")
                        note("3  Touch and hold it, tap Edit Widget for theme, font, text size and notes.")
                    }

                    Button {
                        capturing = true
                    } label: {
                        Text("Add a Don't Forget")
                            .font(.custom("InterTight-SemiBold", size: 16))
                            .foregroundColor(p.onSignal)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Rectangle().fill(p.signal))
                    }
                    Button {
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Text("Refresh widget")
                            .font(.custom("InterTight-Medium", size: 15))
                            .foregroundColor(p.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .overlay(Rectangle().stroke(p.rule, lineWidth: 1))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $capturing) { CaptureView() }
        .onChange(of: phase) { _, newPhase in
            if newPhase == .active { perms.refresh() }
        }
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.custom("InterTight-Medium", size: 11))
            .tracking(1.2)
            .foregroundColor(p.muted)
            .padding(.top, 6)
    }

    private func note(_ text: String) -> some View {
        Text(text)
            .font(.custom("InterTight-Regular", size: 15))
            .foregroundColor(p.text)
            .fixedSize(horizontal: false, vertical: true)
    }
}

/// The real widget panel drawn at widget proportions, with sample data
struct WidgetPreview: View {
    let metrics: DashboardMetrics
    let palette: DashboardPalette

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.width * metrics.designHeight / metrics.designWidth
            let size = CGSize(width: geo.size.width, height: height)
            let u = metrics.unit(for: size)
            let c = PanelContext(m: metrics, t: DashboardType(font: .grotesk, scale: u), p: palette, u: u)
            DashboardPanel(snapshot: .placeholder(), c: c, size: size)
                .background(CuttingMatBackground(palette: palette))
                .clipShape(RoundedRectangle(cornerRadius: 22 * u, style: .continuous))
        }
        .aspectRatio(metrics.designWidth / metrics.designHeight, contentMode: .fit)
    }
}

struct PermissionRow: View {
    let title: String
    let detail: String
    let status: String
    let p: DashboardPalette
    let action: () -> Void

    private var isOn: Bool { status == "On" || status == "Asked" }

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.custom("InterTight-SemiBold", size: 18))
                    .foregroundColor(p.text)
                Text(detail)
                    .font(.custom("InterTight-Regular", size: 13))
                    .foregroundColor(p.muted)
                Text(status.uppercased())
                    .font(.custom("InterTight-Medium", size: 10))
                    .tracking(1)
                    .foregroundColor(isOn ? p.signal : p.muted)
                    .padding(.top, 2)
            }
            Spacer()
            Button(action: action) {
                Text(isOn ? "Done" : "Allow")
                    .font(.custom("InterTight-SemiBold", size: 14))
                    .foregroundColor(isOn ? p.muted : p.onSignal)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(Rectangle().fill(isOn ? p.rule : p.signal))
            }
            .disabled(isOn)
        }
        .padding(16)
        .overlay(Rectangle().stroke(p.rule, lineWidth: 1))
    }
}
