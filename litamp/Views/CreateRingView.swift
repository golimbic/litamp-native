//
//  CreateRingView.swift
//  litamp
//
//  Created by Kirill Kayer on 3/24/25.
//

import SwiftData
import SwiftUI

struct CreateRingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var rings: [Ring]
    private var takenLevels: Set<Int> {
        Set(rings.map(\.level))
    }
    @State private var name = ""
    @State private var level = 1
    private var ringWithSameName: Ring? {
        rings.first { $0.name == name }
    }
    private var ringWithSameLevel: Ring? {
        rings.first { $0.level == level }
    }
    private var canCreate: Bool {
        ringWithSameLevel == nil && ringWithSameName == nil
    }
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    if ringWithSameName != nil {
                        Text(
                            "Ring with the same name already exists: \(ringWithSameName!.name)"
                        )
                        .foregroundColor(.red)
                    }
                }
                Section {
                    Stepper(
                        "Level: \(level)",
                        value: $level,
                        in: 1...7
                    )
                    if ringWithSameLevel != nil {
                        Text(
                            "Ring with the same level already exists: \(ringWithSameLevel!.name)"
                        )
                        .foregroundColor(.red)
                    }
                }
                Section {
                    Button(
                        "Create",
                        action: createRing
                    )
                    .buttonStyle(.borderedProminent)
                    .disabled(!canCreate)
                }
            }
            .navigationTitle("Create Ring")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .presentationBackground(.bar)
        }
    }

    private func createRing() {
        let ring = Ring(name: name, level: level)
        modelContext.insert(ring)
        dismiss()
    }
}

#Preview {
    CreateRingView()
}
