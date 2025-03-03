import SwiftData
import SwiftUI

@main
struct ContactManagerApp: App {
    var container: ModelContainer

    var body: some Scene {
        WindowGroup {
            ContactListView(modelContext: container.mainContext)
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
            schema: schema, isStoredInMemoryOnly: false)

        do {
            container = try ModelContainer(
                for: schema, configurations: [modelConfiguration])

            // Check if there are any rings, if not create default rings
            let context = container.mainContext
            let fetchRequest = FetchDescriptor<Ring>()
            let rings = try context.fetch(fetchRequest)

            if rings.isEmpty {
                let defaultRings = [
                    Ring(name: "Family", level: 1),
                    Ring(name: "Friends", level: 2),
                    Ring(name: "Colleagues", level: 3),
                    Ring(name: "Acquaintances", level: 4),
                ]
                for ring in defaultRings {
                    context.insert(ring)
                }
                try context.save()
            }
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
