import Foundation
import Contacts

class ContactImportService {
    func importContacts(completion: @escaping ([Contact]) -> Void) {
        let store = CNContactStore()
        var contacts: [Contact] = []

        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                print("Access to contacts was denied.")
                completion([])
                return
            }

            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey]
            let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])

            do {
                try store.enumerateContacts(with: request) { (cnContact, stop) in
                    let contact = Contact(name: "\(cnContact.givenName) \(cnContact.familyName)")
                    contacts.append(contact)
                }
                completion(contacts)
            } catch {
                print("Failed to fetch contacts: \(error)")
                completion([])
            }
        }
    }
}
