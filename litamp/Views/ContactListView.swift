import SwiftData
import SwiftUI

struct ContactListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var contacts: [Contact]
    @State private var showCreateContactView = false
    @State private var showImportContactsView = false

    var body: some View {
        NavigationView {

            List {
                if contacts.isEmpty {
                    ContentUnavailableView {
                        Label("No friends", systemImage: "person.3.fill")
                            .symbolRenderingMode(.hierarchical)
                    } description: {
                        Text("Your contacts will appear here.")
                    } actions: {
                        HStack(alignment: .center, spacing: 10) {
                            Button("Add New", action: {
                                showCreateContactView = true
                            })
                            .buttonStyle(.bordered)
                            Button("Import Contacts", action: {
                                showImportContactsView = true
                            })
                            .buttonStyle(.borderedProminent)
                        }
                        .controlSize(.regular)
                    }
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
            .navigationTitle("Personas")
            //            .navigationBarItems(
            //                trailing: HStack {
            //                    Button(action: {
            //                        showCreateContactView = true
            //                    }) {
            //                        Image(systemName: "plus")
            //                    }
            //                    Button(action: {
            //                        showImportContactsView = true
            //                    }) {
            //                        Image(systemName: "square.and.arrow.down")
            //                    }
            //                }
            //            )
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

#Preview {
    ContactListView()
}
