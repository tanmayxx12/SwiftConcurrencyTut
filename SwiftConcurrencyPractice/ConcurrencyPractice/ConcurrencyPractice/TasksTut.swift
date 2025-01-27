//
//  TasksTut.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 27/01/25.
//

import SwiftUI

// Creating a model:
struct AnotherMessageModel: Codable, Identifiable {
    let id: Int
    let from: String
    let text: String
}


struct TasksTut: View {
    @State private var messages = [AnotherMessageModel]()
    
    var body: some View {
        NavigationStack {
            Group {
                if messages.isEmpty {
                    Button("Load Messages") {
                        Task {
                            await loadMesssages()
                        }
                    }
                    .font(.headline)
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)
                } else {
                    List {
                        ForEach(messages) { message in
                            VStack(alignment: .leading) {
                                Text(message.from)
                                    .font(.headline)
                                
                                Text(message.text)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Inbox")
        }
    }

    func loadMesssages() async {
        do {
            guard let url = URL(string: "https://hws.dev/messages.json") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            messages = try JSONDecoder().decode([AnotherMessageModel].self, from: data)
        } catch {
            messages = [
                AnotherMessageModel(id: 1, from: "Failed to load inbox", text: "Please try again later.")
            ]
        }
    }
    
}

#Preview {
    TasksTut()
}
