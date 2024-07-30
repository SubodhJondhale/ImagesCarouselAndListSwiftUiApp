
import SwiftUI

struct StatisticsView: View {
    let items: [ListItem]

    var body: some View {
        VStack {
            Text("Statistics")
                .font(.headline)
                .padding()

            Text("Number of Items: \(items.count)")
                .padding()

            // Count the non-whitespace characters
            let characterCounts = items
                .flatMap { ($0.title + $0.subtitle).filter { !$0.isWhitespace } } // Filter out whitespaces
                .reduce(into: [:]) { counts, character in
                    counts[character, default: 0] += 1
                }

            // Get the top 3 characters
            let topCharacters = characterCounts.sorted { $0.value > $1.value }.prefix(3)

            // Display the top characters
            ForEach(topCharacters, id: \.key) { character, count in
                Text("\(character) = \(count)")
            }

            Spacer()
        }
        .padding()
    }
}
