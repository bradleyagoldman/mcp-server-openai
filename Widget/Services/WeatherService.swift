import Foundation
import CoreLocation

struct WeatherNow: Codable {
    var place: String
    var temp: Double
    var high: Double
    var low: Double
    var code: Int
    var isDay: Bool
    var fetched: Date
}

struct SavedLocation: Codable {
    var lat: Double
    var lon: Double
    var place: String
}

@MainActor
final class OneShotLocation: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<CLLocation?, Never>?

    func current() async -> CLLocation? {
        guard manager.isAuthorizedForWidgetUpdates else { return manager.location }
        return await withCheckedContinuation { cont in
            continuation = cont
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyKilometer
            manager.requestLocation()
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 8_000_000_000)
                self.finish(nil)
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        Task { @MainActor in self.finish(location) }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in self.finish(nil) }
    }

    private func finish(_ location: CLLocation?) {
        guard let continuation else { return }
        self.continuation = nil
        continuation.resume(returning: location ?? manager.location)
    }
}

private struct OpenMeteo: Decodable {
    struct Current: Decodable {
        let temperature_2m: Double
        let weather_code: Int
        let is_day: Int
    }
    struct Daily: Decodable {
        let temperature_2m_max: [Double]
        let temperature_2m_min: [Double]
    }
    let current: Current
    let daily: Daily
}

/// Weather from Open-Meteo: free, no account or key. °F.
enum WeatherService {
    static func load() async -> WeatherNow? {
        let cached = Store.load(WeatherNow.self, "weather")
        var saved = Store.load(SavedLocation.self, "location")

        let finder = await OneShotLocation()
        if let location = await finder.current() {
            var place = saved?.place ?? ""
            let moved = saved.map {
                CLLocation(latitude: $0.lat, longitude: $0.lon).distance(from: location) > 2000
            } ?? true
            if moved || place.isEmpty,
               let mark = try? await CLGeocoder().reverseGeocodeLocation(location).first {
                place = mark.locality ?? mark.subAdministrativeArea ?? mark.administrativeArea ?? ""
            }
            let spot = SavedLocation(lat: location.coordinate.latitude,
                                     lon: location.coordinate.longitude, place: place)
            Store.save(spot, "location")
            saved = spot
        }

        guard let spot = saved else { return cached }
        if let fresh = try? await fetch(spot) {
            Store.save(fresh, "weather")
            return fresh
        }
        return cached
    }

    private static func fetch(_ spot: SavedLocation) async throws -> WeatherNow {
        var comps = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        comps.queryItems = [
            URLQueryItem(name: "latitude", value: String(spot.lat)),
            URLQueryItem(name: "longitude", value: String(spot.lon)),
            URLQueryItem(name: "current", value: "temperature_2m,weather_code,is_day"),
            URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
            URLQueryItem(name: "temperature_unit", value: "fahrenheit"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "1")
        ]
        var request = URLRequest(url: comps.url!)
        request.timeoutInterval = 10
        let (data, _) = try await URLSession.shared.data(for: request)
        let r = try JSONDecoder().decode(OpenMeteo.self, from: data)
        return WeatherNow(place: spot.place,
                          temp: r.current.temperature_2m,
                          high: r.daily.temperature_2m_max.first ?? r.current.temperature_2m,
                          low: r.daily.temperature_2m_min.first ?? r.current.temperature_2m,
                          code: r.current.weather_code,
                          isDay: r.current.is_day == 1,
                          fetched: Date())
    }
}
