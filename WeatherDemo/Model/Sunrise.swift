//
//  Sunrise.swift
//  WeatherDemo
//
//  Created by Ngô Minh Tuấn on 28/08/2021.
//

import Foundation

class Sunrise: Timeline {
    var time: Date!

    init(time: Date) {
        self.time = time
    }
    
    var timeString: String {
        return Utils.stringFromDate(time, format: "hh:mm") ?? ""
    }
    func getTime() -> Date {
        return time
    }
}
