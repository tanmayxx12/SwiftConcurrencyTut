//
//  MVVMTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 26/01/25.
//

import SwiftUI


// Creating a data service/manager:
final class MyManagerClass {
    
    func getData() async throws -> String {
        "Some data"
    }
    
}

actor MyManagerActor {
    
    func getData() async throws -> String {
        "Some data"
    }
    
}

// Creating a view model:
@MainActor
final class MVVMTutViewModel: ObservableObject {
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData: String = "Starting text"
    private var tasks: [Task<Void, Never>] = []
    
    func onCallToActionButtonPressed() {
        let task = Task {
            do {
                myData = try await managerClass.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }
    
    // Function to cancel tasks:
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
}


struct MVVMTut: View {
    @StateObject private var viewModel = MVVMTutViewModel()
    
    var body: some View {
        VStack {
            Button("Click Me") {
                viewModel.onCallToActionButtonPressed()
            }
        }
        .font(.headline)
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }
}

#Preview {
    MVVMTut()
}
