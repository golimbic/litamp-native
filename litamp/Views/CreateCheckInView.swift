import SwiftUI

struct CreateCheckInView: View {
    @Environment(\.dismiss) var dismiss
    @State private var checkInDate: Date = Date()
    @State private var notes: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Check-In Details")) {
                    DatePicker("Check-In Date", selection: $checkInDate, displayedComponents: .date)
                    TextField("Notes", text: $notes)
                }
                
                Section {
                    Button("Save Check-In") {
                        // Logic to save the check-in
                        dismiss()
                    }
                }
            }
            .navigationTitle("Create Check-In")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}