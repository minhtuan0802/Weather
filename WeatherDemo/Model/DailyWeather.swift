//
//  DailyWeather.swift
//  WeatherDemo
//
//  Created by Ngô Minh Tuấn on 27/08/2021.
//

import Foundation
import UIKit

class DailyWeather {
    var time: Date!
    var minTemp: CGFloat!
    var maxTemp: CGFloat!
    var changeRain: CGFloat!
    var sunrise: Sunrise!
    var sunset: Sunset!

    var day: Int {
        return time.day
    }
    
    var weekDay: Int {
        return time.weekday
    }
    
    var weekDayString: String {
        switch weekDay {
        case 1:
            return "Sunday"
        case 2:
            return "Monday"
        case 3:
            return "Tuesday"
        case 4:
            return "Wednesday"
        case 5:
            return "Thursday"
        case 6:
            return "Friday"
        case 7:
            return "Saturday"
        default:
            return "Unknown"
        }
    }
    
}
