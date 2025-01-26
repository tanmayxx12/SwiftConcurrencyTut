//
//  CryptoNetworkingPractice.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 23/01/25.
//

import SwiftUI

// API:
/*
 URL: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
 
 Things we need for practice:
 id, symbol, name, image, current_price, market_cap_rank
 
 */

// Creating the model for the API:
struct CoinModel: Codable, Identifiable {
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

struct CryptoNetworkingPractice: View {
    @State private var coins: [CoinModel] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                List{
                    ForEach(coins) { coin in
                        NavigationLink {
                            VStack {
                                Text("You tapped on \(coin.name)")
                            }
                        } label: {
                            HStack(spacing: 10) {
                                AsyncImage(url: URL(string: coin.image)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                Text(coin.name)
                                    .font(.headline)
                            }
                         
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Crypto Info")
            .onAppear{
                Task {
                    await fetchData()
                }
            }
        }
    }
    
    // Function to fetch coin data:
    func fetchData() async {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            coins = try decoder.decode([CoinModel].self, from: data)
        } catch {
            print("There was an error fetching coin data: \(error.localizedDescription)")
        }
    }
    
    func fetchImage(url: String) async {
        
    }
    
}

#Preview {
    CryptoNetworkingPractice()
}
