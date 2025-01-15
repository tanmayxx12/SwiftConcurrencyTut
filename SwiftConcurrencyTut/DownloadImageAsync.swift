//
//  DownloadImageAsync.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 13/01/25.
//

import Combine
import SwiftUI

//
class DownloadImageAsyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    
    // Creating a function to deal with the recurring completion:
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage?  {
        guard
            let data = data,
            let image = UIImage(data: data),
            let response = response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        return image
    }
    
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // (i) Without using the handleResponse function:
            /*
             guard
                 let data = data,
                 let image = UIImage(data: data),
                 let response = response as? HTTPURLResponse,
                 response.statusCode >= 200 && response.statusCode < 300 else {
                 completionHandler(nil, error) // nil = no image, error = error in fetching the image
                 return
             }
             */
            guard let self = self else { return }
            // (ii) Using the handleResponse function:
            let image = self.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
    
    // Downloading the image using Combine:
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, repsonse) = try await URLSession.shared.data(from: url, delegate: nil)
            let image = handleResponse(data: data, response: repsonse)
            return image
        } catch {
            throw error
        }
        
    }
    
}


// Creating a view model for the view:
class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage() async  {
        // Downloading image using different methods: (i) escaping closure; (ii) Combine:
        /*
         // (i) Downloading with escaping:
         /*
          loader.downloadWithEscaping { [weak self] image, error in
              // DispatchQueue.main makes the code run on the main thread
              DispatchQueue.main.async {
                  if let image = image {
                      guard let self = self else { return }
                      self.image = image
                  }
              }
          }
          */
         
         // (ii) Download with Combine:
         /*
          loader.downloadWithCombine()
              .receive(on: DispatchQueue.main)
              .sink { _ in
                  
              } receiveValue: { [weak self] returnedImage in
                  guard let self = self else { return }
                  self.image = returnedImage
              }
              .store(in: &cancellables)
          */
         */
        
        // (iii) Download with Async/Await: (error handling using try?)
        let image = try? await loader.downloadWithAsync()
        // To run the code on the main thread we have to use MainActor.run { code }
        await MainActor.run {
            self.image = image
        }

    }
    
}

struct DownloadImageAsync: View {
    @StateObject private var viewModel = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                
            }
        }
        .onAppear{
            Task {
               await viewModel.fetchImage()
            }
            
        }
    }
}

#Preview {
    DownloadImageAsync()
}
