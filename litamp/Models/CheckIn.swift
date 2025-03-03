import Foundation
import SwiftData

@Model
class CheckIn {
    var date: Date
    var contact: Contact?

    init(date: Date, contact: Contact?) {
        self.date = date
        self.contact = contact
    }
}
