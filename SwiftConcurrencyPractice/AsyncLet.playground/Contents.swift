import UIKit

// async let in Swift Concurrency:
/*
 async let is used to define and start an asynchronous task concurrently within a function. It is particularly useful when you have multiple tasks that can run in parallel, and you want to await their results later.
 */


// Basic usage of async let:
func fetchUserData() async -> String {
    print("Fetching user data...")
    try? await Task.sleep(nanoseconds: 2_000_000_000) // simulate 2 seconds delay
    return "User Data"
}

await fetchUserData()
