//
//  NowWeather.swift
//  WeatherDemo
//
//  Created by Ngô Minh Tuấn on 27/08/2021.
//

import Foundation
import UIKit

class CurrentWeather: NSObject, Timeline {
    var time: Date!
    var temp: CGFloat!
    var isDayTime: Bool!

    
    func getTime() -> Date {
        return time
    }
}
