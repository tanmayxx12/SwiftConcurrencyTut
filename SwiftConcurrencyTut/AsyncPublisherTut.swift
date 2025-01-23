//
//  AsyncPublisherTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 23/01/25.
//

import Combine
import SwiftUI


// Creating a data manager:
class AsyncPublisherTutDataManager {
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        myData.append("Watermelon ")
        
    }
    
}


// Creating a view model:
class AsyncPublisherTutViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherTutDataManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        // Using Combine to subscribe to the publisher:
        /*
         manager.$myData
             .receive(on: DispatchQueue.main)
             .sink { dataArray in
                 self.dataArray = dataArray
             }
             .store(in: &cancellables)
         */
        
        // Using AsyncPublisher:
        Task {
            for await value in manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
       
    }
    
    func start() async {
        await manager.addData()
    }
    
}

struct AsyncPublisherTut: View {
    @StateObject private var viewModel = AsyncPublisherTutViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.start()
        }
    }
}

#Preview {
    AsyncPublisherTut()
}
