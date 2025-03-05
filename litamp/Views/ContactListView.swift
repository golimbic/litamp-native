import SwiftData
import SwiftUI

struct ContactListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<Contact> { contact in contact.ring == nil })
    private
        var contactsWithoutRing: [Contact]
    @Query private var rings: [Ring]
    @State private var showCreateContactView = false
    @State private var showImportContactsView = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("No ring")) {
                    ForEach(contactsWithoutRing) { contact in
                        NavigationLink(
                            destination: ContactDetailView(contact: contact)
                        ) {
                            Text(contact.name)
                        }
                    }
                    .onDelete(perform: deleteContacts)
                }
                ForEach(rings) { ring in
                    Section(header: Text(ring.name)) {
                        ForEach(ring.contacts) { contact in
                            NavigationLink(
                                destination: ContactDetailView(contact: contact)
                            ) {
                                Text(contact.name)
                            }
                        }
                        .onDelete { indexSet in
                            deleteContacts(at: indexSet, in: ring)
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
            .navigationBarItems(
                trailing: HStack {
                    Button(action: {
                        showCreateContactView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        showImportContactsView = true
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            )
            .sheet(isPresented: $showCreateContactView) {
                CreateContactView(saveContact: modelContext.insert)
            }
            .sheet(isPresented: $showImportContactsView) {
                ImportContactsView()
            }
        }
    }

    // Function to delete items
    private func deleteContacts(at offsets: IndexSet) {
        offsets.forEach { index in
            let itemToDelete = contactsWithoutRing[index]
            modelContext.delete(itemToDelete)  // Delete from modelContext
        }
        // Changes are saved automatically if autoSave is enabled
    }

    private func deleteContacts(at offsets: IndexSet, in ring: Ring) {
        for index in offsets {
            let contact = ring.contacts[index]
            modelContext.delete(contact)
        }
    }
}
