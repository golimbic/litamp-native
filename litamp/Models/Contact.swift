import Foundation
import SwiftData

@Model class Contact: Identifiable {
    var id = UUID()
    var name: String
    @Relationship(deleteRule: .cascade, inverse: \CheckIn.contact)
    var checkIns: [CheckIn] = []
    var ring: Ring?

    init(name: String) {
        self.name = name
    }

    // Method to add a new check-in
    func addCheckIn(date: Date) {
        let newCheckIn = CheckIn(date: date, contact: self)
        checkIns.append(newCheckIn)
    }
}
