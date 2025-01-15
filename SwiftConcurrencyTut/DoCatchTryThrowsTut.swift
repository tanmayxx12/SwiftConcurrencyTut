//
//  DoCatchTryThrowsTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 13/01/25.
//

import SwiftUI

// A class to manage data:
class DoCatchTryThrowsDataManager {
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error? ) {
        if isActive {
            return ("New Text!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error>{
        if isActive {
            return .success("New Title")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    // Using throws:
    func getTitle3() throws -> String {
        if isActive {
            return "New Title."
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final Title"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
}

// View Model:
class DoCatchTryThrowsTutViewModel: ObservableObject {
    
    @Published var text: String = "Starting Text"
    let manager = DoCatchTryThrowsDataManager()
    
    func fetchTitle() {
        /*
         let returnedValue = manager.getTitle()
         if let newTitle = returnedValue.title {
             self.text = newTitle
         } else if let error = returnedValue.error {
             self.text = error.localizedDescription
         }
         */
        /*
         let result = manager.getTitle2()
         switch result {
         case .success(let newTitle):
             self.text = newTitle
         case .failure(let error):
             self.text = error.localizedDescription
         }
         */
        do {
            let newTitle =  try manager.getTitle3()
            self.text = newTitle
            
            let finalText = try manager.getTitle4()
            self.text = finalText
            
        } catch let error {
            self.text = error.localizedDescription
        }
        
    }
}

struct DoCatchTryThrowsTut: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsTutViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsTut()
}
