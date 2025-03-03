import SwiftUI
import Contacts

struct ImportContactsView: View {
    @State private var contacts: [CNContact] = []
    @State private var isImporting: Bool = false

    var body: some View {
        NavigationView {
            List(contacts, id: \.identifier) { contact in
                VStack(alignment: .leading) {
                    Text(contact.givenName + " " + contact.familyName)
                        .font(.headline)
                    if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                        Text(phoneNumber)
                            .font(.subheadline)
                    }
                    if let email = contact.emailAddresses.first?.value as String? {
                        Text(email)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Import Contacts")
            .navigationBarItems(trailing: Button("Import") {
                isImporting = true
                importContacts()
            })
            .alert(isPresented: $isImporting) {
                Alert(title: Text("Importing Contacts"), message: Text("Contacts imported successfully!"), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func importContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request) { contact, stop in
                        contacts.append(contact)
                    }
                } catch {
                    print("Failed to fetch contacts: \(error)")
                }
            } else {
                print("Access to contacts was denied.")
            }
        }
    }
}