//
//  CallingAsyncFunc.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 21/01/25.
//

import SwiftUI

// We call asynchronous functions using Task, .task(), .refreshable() or MainActor.run {}

struct CallingAsyncFunc: View {
    @State private var site: String = "https://"
    @State private var sourceCode = ""
    
    
    var body: some View {
        VStack {
            HStack {
                TextField("Website address...", text: $site)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(.black.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal, 3)
                
                Button("Go") {
                    Task {
                        await fetchSource()
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.gray)
                .padding(.trailing, 3)
            }
            ScrollView{
                Text(sourceCode)
            }
            
        }
    }
    
    func fetchSource() async {
        do {
            let url = URL(string: site)!
            let (data, _) = try await URLSession.shared.data(from: url)
            sourceCode = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
        } catch {
            sourceCode = "Failed to fetch: \(site)"
        }
    }
    
}

#Preview {
    CallingAsyncFunc()
}
