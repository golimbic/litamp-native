import SwiftData
import SwiftUI

struct CreateContactView: View {
    let saveContact: (Contact) -> Void
    @Environment(\.modelContext) private var context
    @Query private var rings: [Ring]
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var selectedRing: Ring? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    TextField("Name", text: $name)
                }

                Section(header: Text("Ring Selector")) {
                    Picker("Select Ring", selection: $selectedRing) {
                        Text("None").tag(Ring?.none)
                        ForEach(rings, id: \.self) { ring in
                            Text(ring.name).tag(ring)
                        }
                    }
                }

                Button(action: _saveContact) {
                    Text("Save Contact")
                }
            }
            .navigationTitle("Create Contact")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                })
        }
    }

    private func _saveContact() {
        let contact = Contact(name: name)
        contact.ring = selectedRing
        saveContact(contact)
        // Logic to save the contact goes here
        // This could involve calling a method in the ViewModel or Service layer
        dismiss()
    }
}
