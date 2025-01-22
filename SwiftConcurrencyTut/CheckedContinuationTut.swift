//
//  CheckedContinuationTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 21/01/25.
//

import SwiftUI

// MARK: Network Manager
class CheckedContinuationTutNetworkManager {
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data , response, error in
                if let data = data {
                    continuation.resume(returning: data) // resume should only be used exactly once
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase2() async -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
    
}


// MARK: ViewModel
class CheckedContinuationTutViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let manager = CheckedContinuationTutNetworkManager()
    
    // function to get image from the API: 
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/300") else { return }
        do {
            let data = try await manager.getData2(url: url) // Check for getData and getData2
            if let image =  UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print("There was an error: \(error.localizedDescription)")
        }
    }
    
    // Function using getHeartFromDatabase()
//    func getHeartImage()  {
//        manager.getHeartImageFromDatabase { [weak self] image in
//            guard let self = self else { return }
//            self.image = image
//        }
//    }
    // Function using getHeartImageFromDatabase2()
    func getHeartImage() async {
        let image = await manager.getHeartImageFromDatabase2()
        self.image = image
    }
    
    
}

struct CheckedContinuationTut: View {
    @StateObject private var viewModel = CheckedContinuationTutViewModel()
    
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
//            await viewModel.getImage()
            await viewModel.getHeartImage()
        }
    }
}

#Preview {
    CheckedContinuationTut()
}
