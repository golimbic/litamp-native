import Foundation
import SwiftData

@Model
class Ring: Identifiable {
    var id = UUID()
    @Attribute(.unique) var name: String
    var level: Int
    @Relationship(deleteRule: .nullify, inverse: \Contact.ring)
    var contacts: [Contact] = []

    init(name: String, level: Int) {
        self.name = name
        self.level = level
    }
}
