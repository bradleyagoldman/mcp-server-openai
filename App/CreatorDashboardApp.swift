import SwiftUI

@main
struct CreatorDashboardApp: App {
    @State private var capturing = false

    var body: some Scene {
        WindowGroup {
            ContentView(capturing: $capturing)
                .onOpenURL { url in
                    // The widget's + button opens creatordash://capture
                    if url.host == "capture" { capturing = true }
                }
        }
    }
}
