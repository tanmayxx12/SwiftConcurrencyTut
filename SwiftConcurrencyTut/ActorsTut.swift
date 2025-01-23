//
//  ActorsTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 22/01/25.
//

import SwiftUI

// What is the problem that Actors solve
// How was this problem solved prior to Actors
// Actors can solve the problem


// Shared class between HomeView and BrowseView:
class MyDataManager {
    static let instance = MyDataManager()
    private init() { }
    
    var data: [String] = []
    // In order to make the class thread safe we need to define a new queue:
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager")
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> ()) {
        // Using the custom queue:
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

// Creating an Actor DataManager:
actor MyActorDataManager {
    static let instance = MyActorDataManager()
    private init() {}
    
    var data: [String] = []
    
   // let myRandomText: String = "fjakdhfjhadsjf" // we can also call nonisolated constants or variables which can be called without being used inside a Task (being synchronous)
    
    
    func getRandomData() async -> String? {
        self.data.append(UUID().uuidString)
//        print(Thread.current)
        return self.data.randomElement()
    }
    
    
    nonisolated func getSavedData() -> String {
        return "New Data"
    }
    
}





struct HomeView: View {
    @State private var text: String = ""
    let manager = MyActorDataManager.instance
    let timer = Timer.publish(every: 0.1, on: .main, in: .common) //.autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
                
        }
        .onAppear {
            // calling getSavedData() function when it nonisolated:
            let newString = manager.getSavedData()
            
            // calling getSavedData() function when it is isolated:
            /*
             Task {
                 let newString = await manager.getSavedData()
             }
             */
           
        }
        .onReceive(timer) { _ in
            // DispatchQueue is used when using the class MyDataManager:
            /*
             DispatchQueue.global(qos: .background).async {
                 manager.getRandomData { title in
                     if let data = title {
                         DispatchQueue.main.async {
                             self.text = data
                         }
                     }
                 }
             }
             */
            
            // Using actor:
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
        }
    }
}

struct BrowseView: View {
    @State private var text: String = ""
    let manager = MyActorDataManager.instance
    let timer = Timer.publish(every: 0.01, on: .main, in: .common) // .autoconnect
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8)
                .ignoresSafeArea()
            
            Text(text)
                .font(.headline)
            
        }
        .onReceive(timer) { _ in
            // DispatchQueue is used when using the class MyDataManager:
            /*
             DispatchQueue.global(qos: .default).async {
                 manager.getRandomData { title in
                     if let data = title {
                         DispatchQueue.main.async {
                             self.text = data
                         }
                     }
                 }
             }
             */
            // Using actor:
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
            
        }
    }
}



struct ActorsTut: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "house.fill") {
                HomeView()
            }
            Tab("Browse", systemImage: "magnifyingglass") {
                BrowseView()
            }
            
            
            
        }
        
    }
}

#Preview {
    ActorsTut()
}
