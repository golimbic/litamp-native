import Foundation
import SwiftData

class CalendarService {
    private var modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func createEvent(for contact: Contact, title: String, date: Date) {
        let event = CalendarEvent(title: title, date: date, contact: contact)
        do {
            // try modelContainer.save(event)
        } catch {
            print("Failed to create event: \(error)")
        }
    }

    func updateEvent(_ event: CalendarEvent) {
        do {
            // try modelContainer.save(event)
        } catch {
            print("Failed to update event: \(error)")
        }
    }

    func deleteEvent(_ event: CalendarEvent) {
        do {
            // try modelContainer.delete(event)
        } catch {
            print("Failed to delete event: \(error)")
        }
    }

    func fetchEvents(for contact: Contact) -> [CalendarEvent] {
        return []
    }
}
