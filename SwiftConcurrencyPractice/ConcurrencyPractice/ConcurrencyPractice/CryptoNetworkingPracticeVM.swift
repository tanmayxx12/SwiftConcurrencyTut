//
//  CryptoNetworkingPracticeVM.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 25/01/25.
//

import SwiftUI

// API:
/*
 URL : "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
 
 */

// Creating the model for the API:
struct CoinModel2: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double
    let marketCapRank: Double
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
    }
}


// Creating a Data Manager:
class CryptoNetworkingPracticeDataManager {
    
    static let shared = CryptoNetworkingPracticeDataManager()
    
    func fetchCoins() async throws -> [CoinModel2] {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let decoder = JSONDecoder()
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode([CoinModel2].self, from: data)
    }
    
}



// Creating a view model:
class CryptoNetworkingPracticeViewModel: ObservableObject {
    @Published var coins: [CoinModel2] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    let dataManager = CryptoNetworkingPracticeDataManager.shared
    
    
    func loadCoins() async {
        isLoading = true
        do {
            let fetchedCoins = try await dataManager.fetchCoins()
            coins = fetchedCoins
        } catch {
            errorMessage = "Failed to fetch coin data: \(error.localizedDescription)"
        }
        
        isLoading = false
        
    }
}



struct CryptoNetworkingPracticeVM: View {
    @StateObject private var viewModel = CryptoNetworkingPracticeViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.headline)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                } else {
                    List{
                        ForEach(viewModel.coins) { coin in
                            Text(coin.name)
                                .font(.headline)
                                
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Crypto Networking Tut")
            .task {
                await viewModel.loadCoins()
            }
        }
    }
}

#Preview {
    CryptoNetworkingPracticeVM()
}
