//
//  StructClassActorTut.swift
//  SwiftConcurrencyTut
//
//  Created by Tanmay . on 22/01/25.
//

import SwiftUI

struct StructClassActorTut: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear{
                runTest()
            }
    }
}

#Preview {
    StructClassActorTut()
}


struct MyStruct {
    var title: String
}

extension StructClassActorTut {
    private func runTest() {
        print("Test Started")
        structTest1()
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting title")
        print("ObjectA: \(objectA.title)")
        var objectB = objectA
        print("ObjectB: \(objectB.title)")
        
        objectB.title = "Second title"
        print("ObjecB title changed")
        
        print("ObjectA: \(objectA.title)")
        print("ObjectB: \(objectB.title)")
        
    }
    
}
