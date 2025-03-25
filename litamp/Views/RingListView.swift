import SwiftData
import SwiftUI

struct RingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var rings: [Ring]
    @State private var showCreateRingView = false
    @State private var showCreateSuggestedRingsView = false

    var body: some View {
        NavigationView {
            List {
                if rings.isEmpty {
                    RingListEmptyView(
                        showCreateRingView: $showCreateRingView,
                        showCreateSuggestedRingsView:
                            $showCreateSuggestedRingsView
                    )
                }
                ForEach(rings) { ring in
                    NavigationLink(
                        destination: RingDetailView(ring: ring)
                    ) {
                        Text(ring.name)
                    }
                }
                .onDelete(perform: deleteRings)
            }
            .navigationTitle("Rings")
            .sheet(isPresented: $showCreateRingView) {
                CreateRingView()
            }
            .sheet(isPresented: $showCreateSuggestedRingsView) {
                CreateSuggestedRingsView()
            }
        }
    }

    // Function to delete items
    private func deleteRings(at offsets: IndexSet) {
        offsets.forEach { index in
            let itemToDelete = rings[index]
            modelContext.delete(itemToDelete)  // Delete from modelContext
        }
        // Changes are saved automatically if autoSave is enabled
    }
}

#Preview("Empty") {
    RingListView()
}

#Preview("Has rings") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Ring.self, configurations: config)
    container.mainContext.insert(Ring(name: "Family", level: 1))
    container.mainContext.insert(Ring(name: "Friends", level: 2))
    container.mainContext.insert(Ring(name: "Work", level: 5))
    return RingListView().modelContainer(container)
}
