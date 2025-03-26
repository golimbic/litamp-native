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
    // Focus on the name field when the view appears
    @FocusState private var isNameFocused: Bool
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Stepper(
                        "Level: \(level)",
                        value: $level,
                        in: 1...7
                    )
                    if ringWithSameLevel != nil {
                        Text(
                            "\(ringWithSameLevel!.name) ring has the same level"
                        )
                        .foregroundColor(.red)
                    }
                }
                Section {
                    TextField("Name", text: $name)
                        .focused($isNameFocused)
                        .submitLabel(.done)
                        .onSubmit {
                            if canCreate {
                                createRing()
                            }
                        }
                    if ringWithSameName != nil {
                        Text(
                            "\(ringWithSameName!.name) already exists"
                        )
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Create Ring")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDragIndicator(.visible)
            .presentationBackground(.bar)
        }
        .onAppear {
            isNameFocused = true
        }
    }

    private func createRing() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let ring = Ring(name: trimmedName, level: level)
        modelContext.insert(ring)
        dismiss()
    }
}

#Preview {
    CreateRingView()
}
