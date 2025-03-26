//
//  CreateSuggestedRingsView.swift
//  litamp
//
//  Created by Kirill Kayer on 3/24/25.
//

import SwiftUI

struct CreateSuggestedRingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    private var suggestedRings: [Ring] {
        [
            Ring(name: "Family", level: 1),
            Ring(name: "Friends", level: 2),
            Ring(name: "Network", level: 3),
        ]
    }
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("The following rings will be created:")
                    .font(.headline)
                    .padding(.all)
                List(suggestedRings) { ring in
                    VStack(alignment: .leading) {
                        Text(ring.name)
                            .font(.headline)
                        Text("Level: \(ring.level)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button("Create") {
                    suggestedRings.forEach { ring in
                        modelContext.insert(ring)
                    }
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Create Suggested Rings")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .presentationBackground(.bar)
        }
    }
}

#Preview {
    CreateSuggestedRingsView()
}
