//
//  AsyncLet.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 21/01/25.
//

import SwiftUI

struct User: Decodable, Identifiable {
    let id: UUID
    let name: String
    let age: Int 
}

struct Message: Decodable, Identifiable {
    let id: Int
    let from: String
    let message: String
}

// Creating a data manager:
class AsyncLetDataManager {
    func loadData() async -> String {
        async let (userData, _) = URLSession.shared.data(from: URL(string: "https://hws.dev/user-24601.json")!)
        async let (messageData, _) = URLSession.shared.data(from: URL(string: "https://hws.dev/user-messages.json")!)
        do {
            let decoder = JSONDecoder()
            let user = try await decoder.decode(User.self, from: userData)
            let messages = try await decoder.decode([Message].self, from: messageData)
            return "User \(user.name) has \(messages.count) message(s)."
        } catch {
            return "Sorry, there was a network error."
        }
    }
}

// Creating a View Model:
class AsyncLetViewModel: ObservableObject {
    @Published var returnedResponse: String = ""
    @Published var returnedMessage: [String] = []
    let manager = AsyncLetDataManager()
    
    func fetchData() {
        Task {
            let response = await manager.loadData()
            await MainActor.run {
                self.returnedResponse = response
            }
        }
    }
}

struct AsyncLet: View {
    @StateObject private var viewModel = AsyncLetViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.returnedResponse)
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundStyle(.blue)
                
                Button("Reload Data") {
                    viewModel.fetchData()
                }
                .font(.headline)
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
//                listRowView
//                    .padding(.top)
                
            }
        }
        .onAppear {
            viewModel.fetchData()
        }
        
    }
}

#Preview {
    AsyncLet()
}

//extension AsyncLet {
//    var listRowView: some View {
//        HStack {
//            Image(systemName: "person.circle.fill")
//                .resizable()
//                .frame(width: 45, height: 45)
//                .foregroundStyle(.black.opacity(0.4))
//            
//            VStack(alignment: .leading) {
//                Text("Name")
//                    .font(.headline)
//                    .fontWeight(.bold)
//                
//                Text("Message sent by the person above ..........")
//                    .font(.caption)
//                    .fontWeight(.semibold)
//                    
//            }
//            
//            
//        }
//    }
//}
