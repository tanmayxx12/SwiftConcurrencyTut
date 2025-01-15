import UIKit


// Simulating a network fetch function:
func fetchWeatherData(city: String) async throws -> String {
    print("Fetching weather for \(city)...")
    try await Task.sleep(nanoseconds: 2_000_000_000)
    let cityWeather = "It is currently windy in \(city)."
    return cityWeather
}

// Simulating a function to process the data:
func processWeatherData(data: String) async -> String {
    print("Processing data...")
    try? await Task.sleep(nanoseconds: 1_000_000_000)
    return "Processed data: \(data)"
}

// Main function to demonstrate task usage:
func fetchAndProcessWeatherData(city: String)  {
    Task {
        do {
            // fetch weather data:
            let weatherData = try await fetchWeatherData(city: city)
            
            // Process weather data:
            let processedData = await processWeatherData(data: weatherData)
            
            // Update the UI simulated by print():
            print("Final output: \(processedData)")
        } catch {
            print("There was an error: \(error.localizedDescription)")
        }
    }
}

fetchAndProcessWeatherData(city: "London")
