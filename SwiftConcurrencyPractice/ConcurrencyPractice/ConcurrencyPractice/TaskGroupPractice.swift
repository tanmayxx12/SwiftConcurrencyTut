//
//  TaskGroup.swift
//  ConcurrencyPractice
//
//  Created by Tanmay . on 27/01/25.
//

import SwiftUI

// Creating a model:
struct NewsStory: Codable, Identifiable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
}

// Creating a view model:
final class TaskGroupPracticeViewModel: ObservableObject {
    @Published var stories: [NewsStory] = []
    
    func loadStories() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        do {
            stories = try await withThrowingTaskGroup(of: [NewsStory].self) { group in
                for i in 1...5 {
                    group.addTask {
                        let url = URL(string: "https://hws.dev/news-\(i).json")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        return try JSONDecoder().decode([NewsStory].self, from: data)
                    }
                }
                
                var allStories: [NewsStory] = []
                for try await stories in group {
                    allStories.append(contentsOf: stories)
                }
                
                return allStories.sorted{ $0.id > $1.id }
                
            }
        } catch {
            print("Failed to load stories")
        }
    }
    
}

struct TaskGroupPractice: View {
    @StateObject private var viewModel = TaskGroupPracticeViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.stories) { story in
                    NavigationLink {
                        VStack {
                            Text(story.title)
                                .font(.title)
                                .fontWeight(.bold)
                        
                            Text(story.strap)
                                .font(.headline)
                                .padding(.top, 40)
                            Spacer()
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text(story.title)
                                .font(.headline)
                            
                            Text(story.strap)
                            
                        }
                    }

                   
                }
            }
            .refreshable {
                await viewModel.loadStories()
            }
            .listStyle(.plain)
            .navigationTitle("Latest News")
        }
        .task {
            await viewModel.loadStories()
        }
    }
}

#Preview {
    TaskGroupPractice()
}
