//
//  WeatherResponse.swift
//  WeatherDemo
//
//  Created by Ngô Minh Tuấn on 27/08/2021.
//

import Foundation
import UIKit

struct WeatherResponse: Codable {
    let lat: CGFloat
    let lon: CGFloat
    let current: CurrentWeatherResponse
    let hourly: [HourlyWeatherResponse]
    let daily: [DailyWeatherResponse]
    
}

struct HourlyWeatherResponse: Codable {
    let dt: Int
    let temp: CGFloat
    let clouds: CGFloat
}

struct CurrentWeatherResponse: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: CGFloat

}

struct DailyWeatherResponse: Codable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let humidity: Int
    let temp: Temperature
    let clouds: CGFloat
    let wind_speed: CGFloat
    let feels_like: TempFeelsLike
}

struct Temperature: Codable {
    let day: CGFloat
    let min: CGFloat
    let max: CGFloat
}

struct TempFeelsLike: Codable {
    let day: CGFloat
    let night: CGFloat
}
