//
//  TaskTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 14/01/25.
//

import SwiftUI

// Creating a view model:
class TaskTutViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    
    // Function to fetch image from the url:
    func fetchImage() async {
        // To make the Task sleep:
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            
            let image = UIImage(data: data)
            await MainActor.run(body: {
                self.image = image
                print("Image returned successfully.")
            })
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // Another function to fetch image from the URL:
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            let image2 = UIImage(data: data)
            self.image2 = image2
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

// Creating a Home View:
struct TaskTutHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click Me") {
                    TaskTut()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 70, height: 15)
                .padding()
                .background(.blue)
                .cornerRadius(10)
                .shadow(radius: 10, x: 0, y: 10)
                
                
            }
        }
    }
}
#Preview {
    TaskTutHomeView()
}



struct TaskTut: View {
    @StateObject private var viewModel = TaskTutViewModel()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            VStack(spacing: 30) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                
                if let image2 = viewModel.image2 {
                    Image(uiImage: image2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                
            }
        }
        // Using onAppear on the view:
        /*
         .onAppear{
             // Task for fetching the images from url:
             /*
              
              */
             Task {
 //                print(Thread.current)
                 print(Task.currentPriority)
                 await viewModel.fetchImage()
             }
 //            Task {
 //                print(Task.currentPriority)
 //                await viewModel.fetchImage2()
 //            }
             
             // Task priorities:
             /*
              Task(priority: .low) {
                  print("low: \(Task.currentPriority)")
              }
              Task(priority: .medium) {
                  print("medium: \(Task.currentPriority)")
              }
              Task(priority: .high) {
                  print("high: \(Task.currentPriority)")
              }
              Task(priority: .background) {
                  print("background: \(Task.currentPriority)")
              }
              Task(priority: .utility) {
                  print("utility: \(Task.currentPriority)")
              }
              Task(priority: .userInitiated) {
                  print("userInitiated: \(Task.currentPriority)")
              }
              */
             
             // Nested Tasks: (Child Task)
             /*
              Task(priority: .userInitiated) {
                  print("userInitiated: \(Task.currentPriority)")
                  
                  Task(priority: .userInitiated) {
                      print("userInitiated2: \(Task.currentPriority)")
                  }
                  
                  // If we dont need to attach the child view to the parent view, we can use detached:
                  Task.detached {
                      print("detached: \(Task.currentPriority)")
                  }
              }
              */
           
             
         }
         */
        
        // Using .task to create the environment for async/await:
        .task { // .task{} automatically cancels the task if the view disappears before the action completes
            await viewModel.fetchImage()
        }
        
    }
}

#Preview {
    TaskTut()
}
