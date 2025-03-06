import Contacts
import SwiftUI

// Define standard Apple colors
private let appleColors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple, .pink, .cyan, .indigo,
    .mint, .teal,
]

// Function to generate MeshGradient parameters
struct MeshGradientParameters {
    let points: [SIMD2<Float>]
    let colors: [Color]

    static func fromContact(
        givenName: String, familyName: String, organizationName: String
    ) -> MeshGradientParameters {
        // Combine inputs into a single string
        let combined =
            "\(givenName.lowercased())\(familyName.lowercased())\(organizationName.lowercased())"

        // Hash the combined string
        var hash: UInt64 = 5381
        for byte in combined.utf8 {
            hash = hash &* 33 &+ UInt64(byte)
        }
        let seed = hash
        var random = SeededRandomGenerator(seed: seed)

        // Define 3x3 base points (9 points)
        let basePoints: [SIMD2<Float>] = [
            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],  // Top row
            [0.0, 0.5], [0.5, 0.5], [1.0, 0.5],  // Middle row
            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0],  // Bottom row
        ]

        // Perturb only the center point, lock perimeter
        let points = basePoints.enumerated().map { (index, point) in
            let isPerimeter =
                point.x == 0.0 || point.x == 1.0 || point.y == 0.0
                || point.y == 1.0
            if isPerimeter {
                return point  // Fixed perimeter
            }
            // Perturb only the center point (index 4: [0.5, 0.5])
            let offsetX = Float(random.next(in: -0.1...0.1))
            let offsetY = Float(random.next(in: -0.1...0.1))
            return SIMD2<Float>(
                max(0.0, min(1.0, point.x + offsetX)),
                max(0.0, min(1.0, point.y + offsetY))
            )
        }

        // Select 3 colors from appleColors
        let colorCount = appleColors.count
        let index1 = Int(seed % UInt64(colorCount))
        let index2 = Int((seed / UInt64(colorCount)) % UInt64(colorCount))
        let index3 = Int(
            (seed / (UInt64(colorCount) * UInt64(colorCount)))
                % UInt64(colorCount))

        let selectedColors = [
            appleColors[index1],
            appleColors[index2],
            appleColors[index3],
        ]

        // Create an initial array with 3 colors repeated to fill 9 slots
        var colorArray: [Color] = [
            selectedColors[0], selectedColors[1], selectedColors[2],
            selectedColors[0], selectedColors[1], selectedColors[2],
            selectedColors[0], selectedColors[1], selectedColors[2],
        ]

        // Deterministically shuffle the array using Fisher-Yates
        for i in (1..<colorArray.count).reversed() {
            let j = Int(random.next(in: 0...Double(i)))  // Random index from 0 to i
            colorArray.swapAt(i, j)
        }

        // Use the shuffled array for the 9 slots
        let colors: [Color] = colorArray

        return MeshGradientParameters(points: points, colors: colors)
    }
}

// Seeded random number generator (unchanged)
struct SeededRandomGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next(in range: ClosedRange<Double>) -> Double {
        state = state &* 6_364_136_223_846_793_005 &+ 1_442_695_040_888_963_407
        let random = Double(state) / Double(UInt64.max)
        return range.lowerBound + random * (range.upperBound - range.lowerBound)
    }
}

struct ImportContactsView: View {
    @State private var contacts: [CNContact] = []
    @State private var isImporting: Bool = false

    var body: some View {
        NavigationView {
            List(contacts, id: \.identifier) { contact in
                HStack(alignment: .center) {
                    if let thumbnailData = contact.thumbnailImageData,
                        let uiImage = UIImage(data: thumbnailData)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    } else {
                        let params = MeshGradientParameters.fromContact(
                            givenName: contact.givenName,
                            familyName: contact.familyName,
                            organizationName: contact.organizationName
                        )
                        MeshGradient(
                            width: 3,
                            height: 3,
                            points: params.points,
                            colors: params.colors
                        )
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        Text(contact.givenName + " " + contact.familyName).font(
                            .headline)
                        if !contact.organizationName.isEmpty {
                            Text(contact.organizationName)
                                .font(.footnote)
                        }
                    }
                }
            }
            .navigationTitle("Import Contacts")
            .navigationBarItems(
                trailing: Button("Import") {
                    isImporting = true
                    importContacts()
                }
            )
            .alert(isPresented: $isImporting) {
                Alert(
                    title: Text("Importing Contacts"),
                    message: Text("Contacts imported successfully!"),
                    dismissButton: .default(Text("OK")))
            }
        }
    }

    private func importContacts() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            if granted {
                let keys =
                    [
                        CNContactGivenNameKey,
                        CNContactFamilyNameKey,
                        CNContactThumbnailImageDataKey,
                        CNContactOrganizationNameKey,
                    ] as [CNKeyDescriptor]
                let request = CNContactFetchRequest(keysToFetch: keys)

                DispatchQueue.global(qos: .userInitiated).async {
                    var localContacts: [CNContact] = []
                    do {
                        try store.enumerateContacts(with: request) {
                            contact, stop in
                            localContacts.append(contact)
                        }
                        DispatchQueue.main.async {
                            contacts = localContacts
                            print(
                                "Fetched \(contacts.count) contacts successfully."
                            )
                            // Update UI here, e.g., tableView.reloadData()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("Failed to fetch contacts: \(error)")
                            // Show error to user if needed
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    print("Access to contacts was denied.")
                    // Update UI to reflect denial if needed
                }
            }
        }
    }
}
