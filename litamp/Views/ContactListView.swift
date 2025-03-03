import SwiftData
import SwiftUI

struct ContactListView: View {
    @State private var viewModel: ContactListViewModel

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("No ring")) {
                    ForEach(viewModel.contactsWithoutRing) { contact in
                        NavigationLink(
                            destination: ContactDetailView(contact: contact)
                        ) {
                            Text(contact.name)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.deleteContacts(at: indexSet)
                    }
                }
                ForEach(viewModel.rings) { ring in
                    Section(header: Text(ring.name)) {
                        ForEach(ring.contacts) { contact in
                            NavigationLink(
                                destination: ContactDetailView(contact: contact)
                            ) {
                                Text(contact.name)
                            }
                        }
                        .onDelete { indexSet in
                            viewModel.deleteContacts(at: indexSet, in: ring)
                        }
                    }
                }
            }
            .navigationTitle("Contacts")
            .navigationBarItems(
                trailing: HStack {
                    Button(action: {
                        viewModel.showCreateContactView = true
                    }) {
                        Image(systemName: "plus")
                    }
                    Button(action: {
                        viewModel.showImportContactsView = true
                    }) {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            )
            .sheet(isPresented: $viewModel.showCreateContactView) {
                CreateContactView(saveContact: viewModel.addContact)
            }
            .sheet(isPresented: $viewModel.showImportContactsView) {
                ImportContactsView()
            }
        }
    }

    init(modelContext: ModelContext) {
        let viewModel = ContactListViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
}
