//
//  SendableTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 23/01/25.
//

import SwiftUI

// Creating an actor:
actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyClassUserInfo ) {
        
    }
    
}

// Struct are Thread Safe
struct MyUserInfo: Sendable {
    let name: String
}

// We need to make the class final:
final class MyClassUserInfo: Sendable {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}


// Creating a View Model:
class SendableTutViewModel: ObservableObject {
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info = MyClassUserInfo(name: "info")
        
        await manager.updateDatabase(userInfo: info)
    }
    
}


struct SendableTut: View {
    @StateObject private var viewModel = SendableTutViewModel()
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    SendableTut()
}
