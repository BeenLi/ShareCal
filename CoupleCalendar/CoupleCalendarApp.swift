import SwiftUI
import SwiftData

@main
struct CoupleCalendarApp: App {
    @State private var settings = SettingsStore()
    @State private var services = AppServices()

    private let modelContainer: ModelContainer = {
        do {
            return try ShareCalModelContainer.make()
        } catch {
            fatalError("Unable to create SwiftData container: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(settings)
                .environment(services)
                .modelContainer(modelContainer)
        }
    }
}
