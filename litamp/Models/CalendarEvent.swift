import Foundation
import SwiftData

@Model
final class CalendarEvent {
    @Attribute(.unique) var id: UUID
    var title: String
    var date: Date
    var contact: Contact?

    init(title: String, date: Date, contact: Contact? = nil) {
        self.id = UUID()
        self.title = title
        self.date = date
        self.contact = contact
    }
}
