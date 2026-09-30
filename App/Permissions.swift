import SwiftUI
import CoreLocation
import EventKit
import HealthKit
import WidgetKit

/// Asks for what the widget reads: location, calendar, reminders and health
@MainActor
final class Permissions: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location = ""
    @Published var calendar = ""
    @Published var reminders = ""
    @Published var health = ""

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        refresh()
    }

    func refresh() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse: location = "On"
        case .notDetermined: location = "Not set"
        default: location = "Off · turn on in Settings"
        }
        calendar = Self.describe(EKEventStore.authorizationStatus(for: .event))
        reminders = Self.describe(EKEventStore.authorizationStatus(for: .reminder))
        if !HKHealthStore.isHealthDataAvailable() {
            health = "Not available"
        } else {
            health = UserDefaults.standard.bool(forKey: "healthAsked") ? "Asked" : "Not set"
        }
    }

    private static func describe(_ status: EKAuthorizationStatus) -> String {
        switch status {
        case .fullAccess: return "On"
        case .notDetermined: return "Not set"
        default: return "Off · turn on in Settings"
        }
    }

    func askLocation() {
        manager.requestWhenInUseAuthorization()
    }

    func askCalendar() async {
        _ = try? await EKEventStore().requestFullAccessToEvents()
        refresh()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func askReminders() async {
        _ = try? await EKEventStore().requestFullAccessToReminders()
        refresh()
        WidgetCenter.shared.reloadAllTimelines()
    }

    func askHealth() async {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        let types: Set<HKObjectType> = [HKQuantityType(.stepCount), HKCategoryType(.sleepAnalysis)]
        try? await HKHealthStore().requestAuthorization(toShare: [], read: types)
        UserDefaults.standard.set(true, forKey: "healthAsked")
        refresh()
        WidgetCenter.shared.reloadAllTimelines()
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.refresh()
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
