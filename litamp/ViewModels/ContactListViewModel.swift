import Foundation
import SwiftData
import SwiftUI

@Observable
class ContactListViewModel {
    var rings: [Ring] = []
    var contactsWithoutRing: [Contact] = []
    var showCreateContactView = false
    var showImportContactsView = false

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchRings()
        fetchContactsWithoutRing()
    }

    func fetchContactsWithoutRing() {
        let fetchRequest = FetchDescriptor<Contact>(
            predicate: #Predicate<Contact> { contact in contact.ring == nil })
        do {
            contactsWithoutRing = try modelContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch contacts without ring: \(error)")
        }
    }

    func fetchRings() {
        let fetchRequest = FetchDescriptor<Ring>()
        do {
            rings = try modelContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch rings: \(error)")
        }
    }

    func addContact(_ contact: Contact) {
        modelContext.insert(contact)
        saveContext()
    }

    func deleteContacts(at offsets: IndexSet) {
        let contact = contactsWithoutRing[offsets.first!]
        modelContext.delete(contact)
        saveContext()
    }

    func deleteContacts(at offsets: IndexSet, in ring: Ring) {
        for index in offsets {
            let contact = ring.contacts[index]
            modelContext.delete(contact)
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try modelContext.save()
            fetchRings()
            fetchContactsWithoutRing()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
