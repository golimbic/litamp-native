import SwiftUI

struct RingListEmptyView: View {
	@Binding var showCreateRingView: Bool
	@Binding var showCreateSuggestedRingsView: Bool

	var body: some View {
		ContentUnavailableView {
			Label("No rings", systemImage: "circle.circle")
				.symbolRenderingMode(.hierarchical)
		} description: {
			Text("Your rings will appear here.")
		} actions: {
			HStack(alignment: .center, spacing: 10) {
				Button(
					"Add New",
					action: {
						showCreateRingView = true
					}
				)
				.buttonStyle(.bordered)
				Button(
					"Create Suggested",
					action: {
						showCreateSuggestedRingsView = true
					}
				)
				.buttonStyle(.borderedProminent)
			}
			.controlSize(.regular)
		}
	}
}

#Preview {
	RingListEmptyView(
		showCreateRingView: .constant(false),
		showCreateSuggestedRingsView: .constant(false)
	)
}
