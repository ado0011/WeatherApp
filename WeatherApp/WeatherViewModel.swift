//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by ado0011 on 12/2/23.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var cityName = ""
    @Published var weatherData: WeatherData?
    @Published var forecastData: ForecastData?

    private var cancellables: Set<AnyCancellable> = []

    func fetchWeatherData() {
        let apiKey = "adde188b49fec2921e80708271eb4774"
        let weatherUrlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"

        guard let weatherUrl = URL(string: weatherUrlString) else {
            print("Invalid weather URL")
            return
        }

        let forecastUrlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&appid=\(apiKey)&units=metric"

        guard let forecastUrl = URL(string: forecastUrlString) else {
            print("Invalid forecast URL")
            return
        }

        let weatherPublisher = URLSession.shared.dataTaskPublisher(for: weatherUrl)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching weather data: \(error.localizedDescription)")
                }
            }, receiveValue: { decodedData in
                self.weatherData = decodedData
            })

        let forecastPublisher = URLSession.shared.dataTaskPublisher(for: forecastUrl)
            .map(\.data)
            .decode(type: ForecastData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching forecast data: \(error.localizedDescription)")
                }
            }, receiveValue: { decodedData in
                self.forecastData = decodedData
            })
        
        cancellables.insert(weatherPublisher)
        cancellables.insert(forecastPublisher)
    }
}

