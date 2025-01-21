//
//  AsyncThrowsFunctions.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 21/01/25.
//

import SwiftUI


// Creating a Data manager:
class AsyncThrowsFunctionsDataManager {
    func fetchFavourites() async throws -> [Int] {
        let url = URL(string: "https://hws.dev/user-favorites.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode([Int].self, from: data)
        return decodedData
    }
}


// Creating a ViewModel:
class AsyncThrowsFunctionsViewModel: ObservableObject {
    @Published var favourites: [Int] = []
    @Published var errorMessage: String? = nil
    let manager = AsyncThrowsFunctionsDataManager()
    
    func loadFavourites() {
        Task {
            do {
                let fetchedFavourites = try await manager.fetchFavourites()
                await MainActor.run {
                    self.favourites = fetchedFavourites
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to fetch favourites: \(error.localizedDescription)"
                }
            }
        }
    }
    
}

struct AsyncThrowsFunctions: View {
    @StateObject private var viewModel = AsyncThrowsFunctionsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.headline)
                        .foregroundStyle(.red)
                        .padding()
                } else if viewModel.favourites.isEmpty {
                    Text("Loading favourites...")
                        .font(.headline)
                        .padding()
                } else {
                    VStack {
                        List(viewModel.favourites, id: \.self) { favourite in
                            Text("Favourite ID: \(favourite)")
                                .font(.headline)
                                .fontWeight(.bold)
                        }
                        .listStyle(.plain)
                        
                        Text("Total Favourites: \(viewModel.favourites.count)")
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                    
                }
                
            }
            .navigationTitle("AsyncThrowsFunc")
            .onAppear{
                viewModel.loadFavourites()
            }
        }
    }
}

#Preview {
    AsyncThrowsFunctions()
}
