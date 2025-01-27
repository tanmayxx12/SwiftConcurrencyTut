import UIKit

struct Message: Codable, Identifiable {
    let id: Int
    let from: String
    let message: String
}

func fetchMessages(completion: @Sendable @escaping ([Message]) -> ()) {
    guard let url = URL(string: "https://hws.dev/user-messages.json") else { return }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            if let messages = try? JSONDecoder().decode([Message].self, from: data) {
                completion(messages)
                return
            }
        }
        completion([])
    }
    .resume()
}

func fetchMessages() async -> [Message] {
    await withCheckedContinuation { continuation in
        fetchMessages { messages in
            continuation.resume(returning: messages)
        }
    }
}

let messages = await fetchMessages()
print("Downloaded \(messages.count) messages.")

