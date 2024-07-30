
import SwiftUI
import Combine

struct MainView: View {
    @ObservedObject var dataProvider = DataProvider()
    @State private var searchQuery = ""
    @State private var showingStatisticsSheet = false
    @State private var searchBarPinned = false

    var filteredItems: [ListItem] {
        if searchQuery.isEmpty {
            return dataProvider.listItems
        } else {
            return dataProvider.listItems.filter {
                $0.title.contains(searchQuery) || $0.subtitle.contains(searchQuery)
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 0) {
                    // Carousel
                    GeometryReader { geo in
                        TabView(selection: $dataProvider.selectedCarouselIndex) {
                            ForEach(dataProvider.carouselImages.indices, id: \.self) { index in
                                Image(dataProvider.carouselImages[index].imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .tag(index)
                            }
                        }
                        .frame(height: 200)
                        .tabViewStyle(PageTabViewStyle())
                        .onChange(of: dataProvider.selectedCarouselIndex) { _ in
                            dataProvider.updateListItems()
                        }
                        .onChange(of: geo.frame(in: .global).minY) { value in
                            if value <= -200 {
                                searchBarPinned = true
                            } else {
                                searchBarPinned = false
                            }
                        }
                    }
                    .frame(height: 200)

                    // Search Bar
                    GeometryReader { geo in
                        TextField("Search", text: $searchQuery)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .background(Color.white)
                            .shadow(radius: searchBarPinned ? 2 : 0)
                            .onAppear {
                                searchBarPinned = geo.frame(in: .global).minY <= 0
                            }
                    }
                    .frame(height: 44)
                    .padding(.horizontal)
                    .background(Color.white)
                    .zIndex(1)

                    // Adding space between Search Bar and List
                    Spacer().frame(height: 10)

                    // List
                    LazyVStack(alignment: .leading) {
                        ForEach(filteredItems) { item in
                            HStack {
                                Image(item.imageName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10)
                                VStack(alignment: .leading) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(item.subtitle)
                                        .font(.subheadline)
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color.green.opacity(0.2))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .background(Color.clear)

            // Sticky Search Bar
            if searchBarPinned {
                TextField("Search", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                    .frame(height: 44)
                    .transition(.move(edge: .top))
                    .animation(.easeInOut, value: searchBarPinned)
                    .zIndex(2)
            }

            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingStatisticsSheet.toggle()
                    }) {
                        Image(systemName: "chart.bar.fill") // Using a bar chart icon
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding()
                    .sheet(isPresented: $showingStatisticsSheet) {
                        StatisticsView(items: filteredItems)
                    }
                }
            }
        }
    }
}

