//
//  WeatherData.swift
//  WeatherApp
//
//  Created by ado0011 on 12/2/23.
//

import Foundation

struct WeatherData: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}
