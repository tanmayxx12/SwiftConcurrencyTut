//
//  AsyncAwaitTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 14/01/25.
//

import SwiftUI

// Creating a view model:
//class AsyncAwaitTutViewModel: ObservableObject {
//    @Published var dataArray: [String] = []
//    
//    
//    func addTitle1() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            self.dataArray.append("Title1: \(Thread.current)")
//        }
//    }
//    
//    
//    func addTitle2() {
//        DispatchQueue.global() .asyncAfter(deadline: .now() + 2.0) {
//            let title = "Title2: \(Thread.current)"
//            DispatchQueue.main.async {
//                self.dataArray.append(title)
//                
//                let title3 = "Title3: \(Thread.current)"
//                self.dataArray.append(title3)
//            }
//        }
//    }
//    
//    func addAuthor1() async {
//        let author1 = "Author1: \(Thread.current)"
//        self.dataArray.append(author1)
//        
//        // Putting the task to sleep, basically delaying the execution of the code.
//        try? await Task.sleep(nanoseconds: 2_000_000_000)
//        
//        let author2 = "Author2: \(Thread.current)"
//        // In async await, to get back on the main thread we use MainActor:
//        await MainActor.run {
//            self.dataArray.append(author2)
//            
//            let author3 = "Author3: \(Thread.current)"
//            self.dataArray.append(author3)
//        }
//        
//        await addSomething()
//    }
//    
//    func addSomething() async {
//        try? await Task.sleep(nanoseconds: 2_000_000_000)
//        let something1 = "Something1: \(Thread.current)"
//        await MainActor.run {
//            self.dataArray.append(something1)
//            
//            let something2 = "Something2: \(Thread.current)"
//            self.dataArray.append(something2)
//        }
//    }
//    
//}
//
//
//struct AsyncAwaitTut: View {
//    @StateObject var viewModel = AsyncAwaitTutViewModel()
//    
//    var body: some View {
//        List{
//            ForEach(viewModel.dataArray, id: \.self) { data in
//                Text(data)
//                
//            }
//        }
//        .listStyle(.plain)
//        .onAppear{
////            viewModel.addTitle1()
////            viewModel.addTitle2()
//            Task {
//                await viewModel.addAuthor1()
//                
//                let finalText = "Final Text: \(Thread.current)"
//                viewModel.dataArray.append(finalText)
//            }
//        }
//    }
//}
//
//#Preview {
//    AsyncAwaitTut()
//}
