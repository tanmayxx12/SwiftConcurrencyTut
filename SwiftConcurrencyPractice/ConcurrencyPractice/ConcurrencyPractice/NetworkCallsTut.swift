//
//  NetworkCallsTut.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 23/01/25.
//

import SwiftUI
// API:
/*
 URL: "https://api.github.com/users/tanmayxx12/following"
 
 
 */

// Creating the model:
struct GitHubUser: Codable {
    let login: String
    let avatarURL: String
    let bio: String
    
    enum Codingkeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case bio
    }
}

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}


struct NetworkCallsTut: View {
    @State private var user: GitHubUser?
    
    var body: some View {
        VStack {
            
            AsyncImage(url: URL(string: user?.avatarURL ?? "") ) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Circle()
                    .foregroundStyle(.gray)
                    .overlay {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
            }
            .frame(width: 80, height: 80)

            
            Text(user?.login ?? "Login Placeholder")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            Text(user?.bio ?? "Bio Placeholder")
                .multilineTextAlignment(.leading)
                .font(.subheadline)
            
            
            Spacer()
            
        }
        .padding(8)
        .task {
            do {
                user = try await getUser()
            } catch GHError.invalidURL {
                print("Invalid URL")
            } catch GHError.invalidResponse {
                print("Invalid Response")
            } catch GHError.invalidData {
                print("Invalid Data")
            } catch {
                print("Unexpected Error")
            }
            
        }
    }
    
    func getUser() async throws -> GitHubUser {
        guard let url = URL(string: "https://api.github.com/users/tanmayxx12") else {
            throw GHError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
        
    }
    
}

#Preview {
    NetworkCallsTut()
}
