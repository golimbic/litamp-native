import SwiftUI

struct CalendarView: View {
    private var events: [CalendarEvent] = []

    var body: some View {
        NavigationView {
            VStack {
                Text("Calendar Events")
                    .font(.largeTitle)
                    .padding()

                List(events) { event in
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.headline)
                        Text("Date: \(event.date, formatter: dateFormatter)")
                            .font(.subheadline)
                    }
                }

                Button(action: {
                    print("Add Event")
                }) {
                    Text("Add Event")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Calendar")
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}
