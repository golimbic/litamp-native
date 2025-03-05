import SwiftData
import SwiftUI

struct ContactEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var name: String
    @State private var selectedRing: Ring?
    var contact: Contact
    @Query private var rings: [Ring]

    init(contact: Contact) {
        self.contact = contact
        _name = State(initialValue: contact.name)
        _selectedRing = State(initialValue: contact.ring)
    }

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

                Button(action: saveContact) {
                    Text("Save Changes")
                }
            }
            .navigationTitle("Edit Contact")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                })
        }
    }

    private func saveContact() {
        contact.name = name
        contact.ring = selectedRing
        do {
            try modelContext.save()
        } catch {
            print("Error updating task: \(error)")
        }
        dismiss()
    }
}
