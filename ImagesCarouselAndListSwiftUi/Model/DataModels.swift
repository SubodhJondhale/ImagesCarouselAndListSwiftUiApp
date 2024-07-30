
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
    @Published var selectedCarouselIndex: Int = 0 // Added this property

    private var allListItems: [[ListItem]] = []

    init() {
        loadCarouselImages()
        loadListItems()
    }

    func loadCarouselImages() {
        let imageNames = [
            "photo1", "photo2", "photo3", "photo4", "photo5"
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
            let itemsArray = try JSONDecoder().decode([[ListItem]].self, from: data)
            self.allListItems = itemsArray
            self.listItems = itemsArray.first ?? []
        } catch {
            print("Failed to load JSON file: \(error.localizedDescription)")
        }
    }

    func updateListItems() {
        if selectedCarouselIndex < allListItems.count {
            self.listItems = allListItems[selectedCarouselIndex]
        }
    }
}
