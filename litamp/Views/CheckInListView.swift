import SwiftUI

struct CheckInListView: View {
    @Binding var contact: Contact
    @State private var checkIns: [CheckIn] = []
    @State private var showingCreateCheckIn = false

    var body: some View {
        NavigationView {
            List {
                ForEach(checkIns, id: \.id) { checkIn in
                    HStack {
                        Text("Checked in on \(checkIn.date, formatter: dateFormatter)")
                        Spacer()
                    }
                }
                .onDelete(perform: deleteCheckIns)
            }
            .navigationTitle("Check-Ins")
            .navigationBarItems(trailing: Button(action: {
                showingCreateCheckIn.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingCreateCheckIn) {
                CreateCheckInView()
            }
        }
        .onAppear {
            loadCheckIns()
        }
    }

    private func loadCheckIns() {
        // Load check-ins for the contact from the data source
        // This is a placeholder for actual data loading logic
        checkIns = contact.checkIns
    }

    private func deleteCheckIns(at offsets: IndexSet) {
        checkIns.remove(atOffsets: offsets)
        // Update the data source accordingly
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
