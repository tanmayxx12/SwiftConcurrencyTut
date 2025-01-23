//
//  GlobalActorTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 23/01/25.
//

import SwiftUI

// Creating a shared instance for making a function oustide the actor to be isolated to some actor:
// If we were to use class instead of a struct we need to make it final, like:
// @globalActor final class MyFirstGlobalActor{ }
@globalActor struct MyFirstGlobalActor  {
    static var shared = MyNewDataManager()
}



// Create a a data manager:
actor MyNewDataManager {

    func getDataFromDatabase() -> [String]  {
        return ["One", "Two", "Three", "Four", "Five"]
    }
    
}


// Creating a viewModel:
class GlobalActorTutViewModel: ObservableObject {
    @Published var dataArray: [String] = []
        // Before creating the shared instance for the GlobalActor:
//    let manager = MyNewDataManager()
    let manager = MyFirstGlobalActor.shared
    
    @MyFirstGlobalActor func getData() async {
        let data = await manager.getDataFromDatabase()
        self.dataArray = data
     }

}

struct GlobalActorTut: View {
    @StateObject private var viewModel = GlobalActorTutViewModel()
    
    
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
            await viewModel.getData()
        }
    }
}

#Preview {
    GlobalActorTut()
}
