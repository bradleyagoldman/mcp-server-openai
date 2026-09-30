import SwiftUI

/// Los Angeles / 72° + condition / H: 78°  L: 58°
struct WeatherPanel: View {
    let s: DashboardSnapshot
    let c: PanelContext

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(s.city.isEmpty ? "Your location" : s.city)
                .font(c.t.sans(c.m.city, .regular))
                .foregroundColor(c.p.text)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            HStack(alignment: .center, spacing: c.s(4)) {
                Text(s.temperature.map { "\($0)°" } ?? "--°")
                    .font(c.t.value(c.m.temp, .regular))
                    .foregroundColor(c.p.text)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 0)
                Image(systemName: s.weatherSymbol)
                    .font(.system(size: c.f(c.m.weatherIcon), weight: .thin))
                    .foregroundColor(s.weatherSymbol.contains("sun") ? c.p.signal : c.p.text)
            }
            Spacer(minLength: 0)
            HStack(spacing: 2) {
                Text("H: " + (s.high.map { "\($0)°" } ?? "--"))
                Spacer(minLength: 2)
                Text("L: " + (s.low.map { "\($0)°" } ?? "--"))
            }
            .font(c.t.sans(c.m.hiLo, .regular))
            .foregroundColor(c.p.muted)
            .lineLimit(1)
        }
    }
}
