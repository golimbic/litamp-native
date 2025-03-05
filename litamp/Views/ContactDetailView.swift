import SwiftData
import SwiftUI

struct ContactDetailView: View {
    @State private var showEditContactView = false
    var checkIns: [CheckIn] = []
    var contact: Contact

    var body: some View {
        VStack(alignment: .leading) {
            Text(contact.name)
                .font(.largeTitle)
                .padding(.bottom)

            Text("Check-in History")
                .font(.headline)
                .padding(.top)

            List(checkIns) { checkIn in
                Text("Checked in on \(checkIn.date, formatter: dateFormatter)")
            }

            Button(action: {
                print("Add Check in")
            }) {
                Text("Add Check-In")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)

            Button(action: {
                print("Create Calendar Event")
            }) {
                Text("Create Calendar Event")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
        .navigationTitle("Contact Details")
        .toolbar {
            Button("Edit") {
                showEditContactView = true
            }
        }
        .sheet(isPresented: $showEditContactView) {
            ContactEditView(contact: contact)
        }
    }
}

private var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}
