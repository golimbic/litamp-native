//
//  RingDetailView.swift
//  litamp
//
//  Created by Kirill Kayer on 3/24/25.
//

import SwiftUI

struct RingDetailView: View {
    var ring: Ring
    var body: some View {
        Text(ring.name)
            .navigationTitle(ring.name)
    }
}

#Preview {
    RingDetailView(ring: Ring(name: "Sample Ring", level: 1))
}
