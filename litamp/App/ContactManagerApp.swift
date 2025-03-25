import SwiftData
import SwiftUI

@main
struct ContactManagerApp: App {
    let container: ModelContainer

    var body: some Scene {
        WindowGroup {
            RingListView()
        }
        .modelContainer(container)
    }

    init() {
        let schema = Schema([
            Contact.self,
            CheckIn.self,
            CalendarEvent.self,
            Ring.self,  // Ensure Ring is part of the schema
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema, isStoredInMemoryOnly: false, allowsSave: true)

        do {
            container = try ModelContainer(
                for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
