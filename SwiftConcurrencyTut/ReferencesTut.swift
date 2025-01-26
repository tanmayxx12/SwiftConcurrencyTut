//
//  ReferencesTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 26/01/25.
//

import SwiftUI

// Creating a data manager / service:
final class ReferencesTutDataService {
    
    func getData() async -> String {
        return "Updated data..."
    }
}


// Creating a view model:
final class ReferencesTutViewModel: ObservableObject {
    @Published var data: String = "Some title"
    let dataService = ReferencesTutDataService()
    
    private var someTask: Task<Void, Never>? = nil
    
    
    // This implies a strong reference:
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }
    
    // This is a strong reference:
    func updateData2() {
        Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // This is also a strong reference:
    func updateData3() {
        Task { [self] in
            self.data = await self.dataService.getData()
        }
    }
    
    // This is a weak reference:
    func updateData4() {
        Task { [weak self] in
            guard let self =  self else { return }
            self.data = await self.dataService.getData()
        }
    }
    
    // We dont really need to manager the weak/strong self, we could manage the Task{} instead:
    func updateData5() {
       someTask = Task {
            self.data = await self.dataService.getData()
        }
    }
    
    // Function to cancel task:
    func cancelTasks() {
        someTask?.cancel()
        someTask = nil
    }
    
}


struct ReferencesTut: View {
    @StateObject private var viewModel = ReferencesTutViewModel()
    
    
    
    var body: some View {
        Text(viewModel.data)
            .onAppear {
                viewModel.updateData()
            }
            .onDisappear {
                viewModel.cancelTasks()
            }
    }
    
}

#Preview {
    ReferencesTut()
}
