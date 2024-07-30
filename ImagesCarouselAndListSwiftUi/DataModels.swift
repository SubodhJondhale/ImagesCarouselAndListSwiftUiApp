import SwiftUI
import Combine

struct CarouselImage: Identifiable {
    let id = UUID()
    let imageName: String
}

struct ListItem: Identifiable, Codable {
    let id: Int
    let title: String
    let subtitle: String
    let imageName: String
}

class DataProvider: ObservableObject {
    @Published var carouselImages: [CarouselImage] = []
    @Published var listItems: [ListItem] = []

    init() {
        loadCarouselImages()
        loadListItems()
    }

    func loadCarouselImages() {
        let imageNames = [
            "photo1", "photo2", "photo3", "photo4", "photo5",
            "photo6", "photo7", "photo8", "photo9", "photo10"
        ]
        self.carouselImages = imageNames.map { CarouselImage(imageName: $0) }
    }

    func loadListItems() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("Failed to locate JSON file.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let items = try JSONDecoder().decode([ListItem].self, from: data)
            self.listItems = items
        } catch {
            print("Failed to load JSON file: \(error.localizedDescription)")
        }
    }
}

