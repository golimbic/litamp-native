import SwiftData
import SwiftUI

struct ContactListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var contacts: [Contact]
    @State private var showCreateContactView = false
    @State private var showImportContactsView = false
    @State private var expandedSection = true

    var body: some View {
        NavigationView {
            List {
                    if contacts.isEmpty {
                        ContactListEmptyView(
                            showCreateContactView: $showCreateContactView,
                            showImportContactsView: $showImportContactsView
                        )
                    }
                    ForEach(contacts) { contact in
                        NavigationLink(
                            destination: ContactDetailView(contact: contact)
                        ) {
                            Text(contact.name)
                        }
                    }
                    .onDelete(perform: deleteContacts)
            }
            .navigationTitle("Friends")
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
            let itemToDelete = contacts[index]
            modelContext.delete(itemToDelete)  // Delete from modelContext
        }
        // Changes are saved automatically if autoSave is enabled
    }
}

#Preview("Empty") {
    ContactListView()
}

#Preview("Has contacts") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Contact.self, configurations: config)
    container.mainContext.insert(Contact(name: "Steve Jobs"))
    return ContactListView()
        .modelContainer(container)
}
