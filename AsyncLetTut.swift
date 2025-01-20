//
//  AsyncLetTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 20/01/25.
//

import SwiftUI

struct AsyncLetTut: View {
    @State private var images: [UIImage] = []
    let url = URL(string: "https://picsum.photos/300")!
    let columns = [
        GridItem(.flexible(minimum: 50, maximum: 300)),
        GridItem(.flexible(minimum: 50, maximum: 300)),
    ]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns) { 
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("AsyncLet Tut")
            .onAppear{
                Task {
                    
                    do {
                        // Without using async let:
                        /*
                         // Image1:
                         let image1 = try await fetchImage()
                         self.images.append(image1)
                         
                         // Image2:
                         let image2 = try await fetchImage()
                         self.images.append(image2)
                         
                         // Image3:
                         let image3 = try await fetchImage()
                         self.images.append(image3)
                         
                         // Image4:
                         let image4 = try await fetchImage()
                         self.images.append(image4)
                         
                         */
                        
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        
                        // Using await only once instead of using it 4 times as above:
                        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage1, try fetchImage3, try fetchImage4)
                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        
                        async let fetchImage5 = fetchImage()
                        async let fetchTitle1 = fetchTitle()
                        
                        let (image5, title1) = await (try fetchImage5, fetchTitle1)
                        
                    } catch {
                        
                    }
                    
                    
                }
            }
        }
    }
    
    func fetchTitle() async -> String {
        return "New Title"
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
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

#Preview {
    AsyncLetTut()
}
