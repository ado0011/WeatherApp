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

    private var cancellables: Set<AnyCancellable> = []

    func fetchWeatherData() {
        let apiKey = "adde188b49fec2921e80708271eb4774"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=metric"

        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }, receiveValue: { decodedData in
                self.weatherData = decodedData
            })
            .store(in: &cancellables)
    }
}
