//
//  ContinuationTut.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 27/01/25.
//

import SwiftUI

struct MessageModel: Codable, Identifiable {
    let id: Int
    let from: String
    let message: String
}

// Creating a view model:
class ContinuationTutViewModel: ObservableObject {
    @Published var messages: [MessageModel] = []
    
    func fetchMessages(completion: @Sendable @escaping ([MessageModel]) -> ()) {
        guard let url = URL(string: "https://hws.dev/user-messages.json") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let messages = try? JSONDecoder().decode([MessageModel].self, from: data) {
                    completion(messages)
                    return
                }
            }
            completion([])
        }
        .resume()
        
    }
    
    func fetchMessages() async -> [MessageModel] {
        await withCheckedContinuation { continuation in
            fetchMessages { messages in
                continuation.resume(returning: messages)
            }
        }
    }
    
}


struct ContinuationTut: View {
    @StateObject private var viewModel = ContinuationTutViewModel()
    
    var body: some View {
        Text("Hello World!")
    }
}

#Preview {
    ContinuationTut()
}
