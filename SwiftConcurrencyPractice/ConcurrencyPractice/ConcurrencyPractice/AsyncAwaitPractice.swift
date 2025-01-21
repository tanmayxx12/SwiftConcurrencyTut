//
//  AsyncAwaitTut.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 14/01/25.
//

import SwiftUI

// Creating a Data manager:
class AsyncAwaitPracticeDataManager {
    func fetchWeatherData() async -> [Double] {
        (1...100_000).map({ _ in Double.random(in: -10...30)})
    }
    
    func calculateAverageTemperature(for records: [Double]) async -> Double {
        let total = records.reduce(0, +)
        let average = total / Double(records.count)
        return average
    }
    
    func upload(result: Double) async -> String {
        return "Okay"
    }

    func processWeather() async -> String {
        let records = await fetchWeatherData()
        let average = await calculateAverageTemperature(for: records)
        let response = await upload(result: average)
        return "Server response: \(response)"
    }
}



// Creating a view Model:
class AsyncAwaitPracticeViewModel: ObservableObject {
    @Published var fetchedTemperature: Double = 0.0
    @Published var serverResponse: String = ""
    let dataManager = AsyncAwaitPracticeDataManager()
    
    func startProcessingWeather() {
        Task {
            let response = await dataManager.processWeather()
            await MainActor.run {
                self.serverResponse = response
            }
        }
    }
    
}


struct AsyncAwaitPractice: View {
    @StateObject private var viewModel = AsyncAwaitPracticeViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.serverResponse.isEmpty ? "Processing data..." : viewModel.serverResponse)
                
                Button("Process Weather Data") {
                    viewModel.startProcessingWeather()
                }
                .font(.headline)
                .fontWeight(.bold)
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .padding(.top)
                
            }
            .navigationTitle("Async/Await Practice")
        }
    }
}

#Preview {
    AsyncAwaitPractice()
}
