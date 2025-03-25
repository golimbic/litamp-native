import SwiftUI

struct ContactListEmptyView: View {
	@Binding var showCreateContactView: Bool
	@Binding var showImportContactsView: Bool

	var body: some View {
		ContentUnavailableView {
			Label("No contacts", systemImage: "person.fill")
				.symbolRenderingMode(.hierarchical)
		} description: {
			Text("Your contacts will appear here.")
		} actions: {
			HStack(alignment: .center, spacing: 10) {
				Button(
					"Add New",
					action: {
						showCreateContactView = true
					}
				)
				.buttonStyle(.bordered)
				Button(
					"Import Contacts",
					action: {
						showImportContactsView = true
					}
				)
				.buttonStyle(.borderedProminent)
			}
			.controlSize(.regular)
		}
	}
}

#Preview {
	ContactListEmptyView(
		showCreateContactView: .constant(false),
		showImportContactsView: .constant(false)
	)
}
