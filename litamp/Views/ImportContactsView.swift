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

        // Log for debugging
        print("Contact: \(combined), Hash: \(hash), Seed: \(seed)")

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

        // Select 2 base colors from appleColors
        let colorCount = appleColors.count
        let index1 = Int(seed % UInt64(colorCount))
        let index2 = Int((seed / UInt64(colorCount)) % UInt64(colorCount))

        let baseColors = [
            appleColors[index1],
            appleColors[index2],
        ]

        // Log base colors for verification
        print("Base Colors: \(baseColors[0]), \(baseColors[1])")

        // Generate 9 colors by tweaking the 2 base colors
        let colors: [Color] = [
            baseColors[0],  // Top row
            tweakColor(baseColors[1], shift: random.next(in: -0.1...0.1)),
            baseColors[1],

            tweakColor(baseColors[1], shift: random.next(in: -0.1...0.1)),  // Middle row
            baseColors[0],
            tweakColor(baseColors[0], shift: random.next(in: -0.1...0.1)),

            baseColors[1],  // Bottom row
            tweakColor(baseColors[0], shift: random.next(in: -0.1...0.1)),
            tweakColor(baseColors[1], shift: random.next(in: -0.1...0.1)),
        ]

        return MeshGradientParameters(points: points, colors: colors)
    }

    // Helper to tweak a color’s hue slightly
    private static func tweakColor(_ color: Color, shift: Double) -> Color {
        let uiColor = UIColor(color)
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getHue(
            &hue, saturation: &saturation, brightness: &brightness,
            alpha: &alpha)

        let newHue = (hue + CGFloat(shift)).truncatingRemainder(dividingBy: 1.0)
        return Color(
            hue: Double(newHue), saturation: Double(saturation),
            brightness: Double(brightness))
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
                        Text(contact.organizationName)
                            .font(.footnote)
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
