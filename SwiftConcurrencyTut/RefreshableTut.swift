//
//  RefreshableTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 27/01/25.
//

import SwiftUI

// Creating a data manager/service:
final class RefreshableTutDataService {
    
    func getData() async throws -> [String] {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        return ["Apple", "Banana", "Orange"].shuffled()
    }
    
}

// Creating view model
@MainActor
final class RefreshableTutViewModel: ObservableObject {
    @Published private(set) var items: [String] = []
    let manager = RefreshableTutDataService()
    
    func loadData() async {
        do {
            items = try await manager.getData()
        } catch {
            print("There was an error: \(error)")
        }
    }
}


struct RefreshableTut: View {
    @StateObject private var viewModel = RefreshableTutViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Refreashable")
            .refreshable {
                await viewModel.loadData()
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}

#Preview {
    RefreshableTut()
}
