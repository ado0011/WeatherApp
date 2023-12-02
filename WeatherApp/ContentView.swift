//
//  ContentView.swift
//  WeatherApp
//
//  Created by ado0011 on 12/2/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isCelsius = true
    @State private var searchText = ""

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
                    TextField("Enter city", text: $searchText)
                        .padding(.horizontal)
                        .padding(.vertical, 15)
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .padding()

                    Button(action: {
                        viewModel.cityName = searchText
                        viewModel.fetchWeatherData()
                    }) {
                        Text("Search")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()

                    if let weatherData = viewModel.weatherData,
                        let description = weatherData.weather?.first?.description,
                        let emoji = weatherEmoji(for: description) {

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

                        Text("Temperature: \(Int((weatherData.main?.temp ?? 0) * 9/5) + 32) °F")
                            .padding()
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .shadow(color: .black, radius: 2, x: 0, y: 0)

                        Text("Description: \(description)")
                            .padding()
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                            .shadow(color: .black, radius: 2, x: 0, y: 0)

                        if let dailyForecast = viewModel.forecastData?.list {
                            VStack(alignment: .leading) {
                                Text("Multi-Day Forecast:")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.top)

                                ForEach(dailyForecast.prefix(5), id: \.dt) { day in
                                    if let date = day.dt {
                                        let dayOfWeek = Calendar.current.component(.weekday, from: Date(timeIntervalSince1970: date))
                                        let dayOfWeekString = DateFormatter().weekdaySymbols[dayOfWeek - 1]

                                        if let temperature = day.main?.temp {
                                            Text("\(dayOfWeekString): \(day.weather?.first?.description ?? "N/A"), \(Int((temperature * 9/5) + 32)) °F")
                                                .foregroundColor(.white)
                                                .padding(.bottom, 5)
                                        } else {
                                            Text("\(dayOfWeekString): N/A")
                                                .foregroundColor(.white)
                                                .padding(.bottom, 5)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .padding()
                .navigationBarTitle("Weather App", displayMode: .inline)
            }
            .onAppear {
                viewModel.fetchWeatherData()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}







