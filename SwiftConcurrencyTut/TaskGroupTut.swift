//
//  TaskGroupTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 20/01/25.
//

import SwiftUI

// MARK: Data Manager
// Creating a manager:
class TaskGroupTutDataManager {
    
    // Function that fetches images using async let:
    func fetchImagesWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/300")
        async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/300")
        
        do {
            let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
            return [image1, image2, image3, image4]
            
        } catch {
            throw error
        }
    }
    
    // Function that fetches images using Task Group :
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings = [
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300"
        ]
        
       return try await withThrowingTaskGroup(of: UIImage?.self) { group in
           var images: [UIImage] = []
           images.reserveCapacity(urlStrings.count) // Reserves just the space required to fill up the array
           
           for urlString in urlStrings {
               group.addTask {
                   try? await self.fetchImage(urlString: urlString)
               }
           }
           // Using group.addTask manually:
           /*
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
            group.addTask {
                try await self.fetchImage(urlString: "https://picsum.photos/300")
            }
            */
           
           for try await image in group {
               if let image = image {
                   images.append(image)
               }
           }
           return images
        }
    }
    

    // Function that fetches images using URLSession
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await  URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}


// MARK: View Model
// Creating a view model:
class TaskGroupTutViewModel: ObservableObject {
    @Published var images:  [UIImage] = []
    let manager = TaskGroupTutDataManager()
    
    func getImages() async {
        if let images = try? await manager.fetchImagesWithAsyncLet() {
            self.images.append(contentsOf: images)
        }
         
    }
    
}


// MARK: View 
struct TaskGroupTut: View {
    @StateObject private var viewModel = TaskGroupTutViewModel()
    let columns: [GridItem] = [
        GridItem(.flexible(minimum: 50, maximum: 200)),
        GridItem(.flexible(minimum: 50, maximum: 200))
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("TaskGroup Tut")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

#Preview {
    TaskGroupTut()
}
