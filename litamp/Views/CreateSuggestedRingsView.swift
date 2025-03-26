//
//  CreateSuggestedRingsView.swift
//  litamp
//
//  Created by Kirill Kayer on 3/24/25.
//

import SwiftUI

struct CreateSuggestedRingsView: View {
    var body: some View {
        Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
            .navigationTitle("Create Suggested Rings")
            .navigationBarTitleDisplayMode(.inline)
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .presentationBackground(.bar)
    }
}

#Preview {
    CreateSuggestedRingsView()
}
