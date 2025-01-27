//
//  SearchableTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 27/01/25.
//

import Combine
import SwiftUI

// Creating a model:
struct Restaurant: Identifiable, Hashable {
    let id: String
    let title: String
    let cuisine: CuisineOptions
}

enum CuisineOptions: String {
    case american, italian, japanese, indian, french
}

// Creating a data manager:
final class RestaurantManager {
    
    
    func getAllRestaurants() async throws -> [Restaurant] {
        [
            Restaurant(id: "1", title: "Burger Shack", cuisine: .american),
            Restaurant(id: "2", title: "Pasta Palace", cuisine: .italian),
            Restaurant(id: "3", title: "Sushi Heaven", cuisine: .japanese),
            Restaurant(id: "4", title: "Local Market", cuisine: .american),
            Restaurant(id: "5", title: "Walk In The Woods", cuisine: .indian),
            Restaurant(id: "6", title: "Boho Bistro", cuisine: .french),
            Restaurant(id: "7", title: "Bikanerwala", cuisine: .indian),
            Restaurant(id: "8", title: "American Brew", cuisine: .american)
        ]
    }
    
}



// Creating a View model:
@MainActor
final class SearchableTutViewModel: ObservableObject {
    @Published private(set) var allRestaurants: [Restaurant] = []
    @Published private(set) var filteredRestaurants: [Restaurant] = []
    @Published var searchText: String = ""
    @Published var searchScope: SearchScopeOption = .all
    @Published private(set) var allSearchScopes: [SearchScopeOption] = []
    
    
    private var cancellables = Set<AnyCancellable>()
    let manager = RestaurantManager()
    
    var isSearching: Bool {
        !searchText.isEmpty
    }
    
    enum SearchScopeOption {
        case all
        case cuisine(option: CuisineOptions)
        
        var title: String {
            switch self {
            case .all:
                return "All"
            case .cuisine(option: let option):
                return option.rawValue.capitalized
            }
        }
        
    }
    
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        $searchText
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                guard let self = self else { return }
                self.filterRestaurants(searchText: searchText)
            }
            .store(in: &cancellables)
    }
    
    private func filterRestaurants(searchText: String) {
        guard !searchText.isEmpty else {
            filteredRestaurants = []
            return
        }
        
        let search = searchText.lowercased()
        filteredRestaurants = allRestaurants.filter({ restaurant in
            let titleContainsSearch = restaurant.title.lowercased().contains(search)
            let cuisineContainsSearch = restaurant.cuisine.rawValue.lowercased().contains(search)
            return titleContainsSearch || cuisineContainsSearch
        })
        
    }
    
    func loadRestaurants() async {
        do {
            allRestaurants = try await manager.getAllRestaurants()
            
            
            
        } catch {
            print("There was an error")
        }
    }
}



struct SearchableTut: View {
    @StateObject private var viewModel = SearchableTutViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.isSearching ? viewModel.filteredRestaurants : viewModel.allRestaurants) { restaurant in
                        restaurantRow(restaurant: restaurant)
                    }
                }
                .padding()
            }
            .navigationTitle("Restaurants")
            .searchable(text: $viewModel.searchText, prompt: "Search restaurants...")
//            .searchScopes($viewModel.searchScope, scopes: {
//                <#code#>
//            })
            .task {
                await viewModel.loadRestaurants()
            }
        }
    }
    
    private func restaurantRow(restaurant: Restaurant) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(restaurant.title)
                .font(.headline )
            Text(restaurant.cuisine.rawValue.capitalized)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.black.opacity(0.2))
        
    }
    
}

#Preview {
    SearchableTut()
}
