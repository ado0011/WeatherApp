//
//  ContentView.swift
//  WeatherApp
//
//  Created by ado0011 on 12/2/23.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isCelsius = true

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)

                VStack {
                    if let weatherData = viewModel.weatherData,
                       let emoji = weatherEmoji(for: weatherData.weather[0].description) {
                        Text(emoji)
                            .font(.system(size: 100))
                            .frame(width: 120, height: 120)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 60)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding()
                    }

                    TextField("Enter city name", text: $viewModel.cityName)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {
                        viewModel.fetchWeatherData()
                    }) {
                        HStack {
                            Image(systemName: "thermometer")
                                .foregroundColor(.white)
                                .imageScale(.large)
                            Text("Get Weather")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }

                    Toggle(isOn: $isCelsius) {
                        Text("Fahrenheit")
                            .foregroundColor(.white)
                            .font(.headline)
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                    .padding()

                    if let weatherData = viewModel.weatherData {
                        let temperature = isCelsius ? Int(weatherData.main.temp) : Int((weatherData.main.temp * 9/5) + 32)
                        Text("Temperature: \(temperature) \(isCelsius ? "°C" : "°F")")
                            .padding()
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                        Text("Description: \(weatherData.weather[0].description)")
                            .padding()
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .shadow(color: .black, radius: 2, x: 0, y: 0)
                    }
                }
                .padding()
                .navigationBarTitle("Weather App", displayMode: .inline)
            }
        }
    }

    private func weatherEmoji(for description: String) -> String? {
        switch description.lowercased() {
        case let str where str.contains("cloud"):
            return "☁️"
        case let str where str.contains("rain"):
            return "🌧️"
        case let str where str.contains("sun") || str.contains("clear"):
            return "☀️"
        case let str where str.contains("snow"):
            return "❄️"
        case let str where str.contains("haze"):
            return "💨"
        case let str where str.contains("haze"):
            return "🌫️"
        default:
            return nil
        }
    }
}




