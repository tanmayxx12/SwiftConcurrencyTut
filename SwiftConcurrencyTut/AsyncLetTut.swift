//
//  AsyncLetTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 14/01/25.
//

import SwiftUI

struct AsyncLetTut: View {
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible())]
    let url = URL(string: "https://picsum.photos/200")!
    
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
            .navigationTitle("Aync Let Tut")
            .onAppear {
                Task {
                    do {
                        // Using try-await to fetch the images:
                        /*
                         let image1 = try await fetchImage()
                         self.images.append(image1)
                         
                         let image2 = try await fetchImage()
                         self.images.append(image2)
                         
                         let image3 = try await fetchImage()
                         self.images.append(image3)
                         
                         let image4 = try await fetchImage()
                         self.images.append(image4)
                         */
                        
                        // Using async let to fetch all images at once:
                        /*
                         async let fetchImage1 = fetchImage()
                         async let fetchImage2 = fetchImage()
                         async let fetchImage3 = fetchImage()
                         async let fetchImage4 = fetchImage()
                         let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                         self.images.append(contentsOf: [image1, image2, image3, image4])
                         */
                        
                        
                       // We can use Any return value from the Function:
                        async let fetchImage1 = fetchImage()
                        async let fetchTitle1 = fetchTitle()
                        
                        let (image1, title1) = await (try fetchImage1, fetchTitle1)
                        
                        
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let (data, _) = try await  URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
    
    // Function to fetch title:
    func fetchTitle() async  -> String {
        return "New Title"
    }
    
    
}

#Preview {
    AsyncLetTut()
}
