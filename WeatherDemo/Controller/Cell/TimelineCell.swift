//
//  TimelineCell.swift
//  WeatherDemo
//
//  Created by Ngô Minh Tuấn on 29/08/2021.
//

import UIKit

class TimelineCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var changeRainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(data: Timeline) {
        if let currentWeather = data as? CurrentWeather {
            titleLabel.text = "Now"
            iconView.image = UIImage(named: currentWeather.isDayTime ? "ic_sun" : "ic_night")
            changeRainLabel.isHidden = true
            tempLabel.text = "\(Int(currentWeather.temp))°"
        } else if let hourlyWeather = data as? HourlyWeather {
            titleLabel.text = String(format: "%02ld", hourlyWeather.hour)
            iconView.image = UIImage(named: "ic_cloud")
            changeRainLabel.isHidden = false
            changeRainLabel.text = "\(Int(hourlyWeather.changeRain!))%"
            tempLabel.text = "\(Int(hourlyWeather.temp!))"
        } else if let sunrise = data as? Sunrise {
            titleLabel.text = sunrise.timeString
            iconView.image = UIImage(named: "ic_sunrise")
            tempLabel.text = "Sunrise"
            changeRainLabel.isHidden = true
        } else if let sunset = data as? Sunset {
            titleLabel.text = sunset.timeString
            iconView.image = UIImage(named: "ic_sunset")
            tempLabel.text = "Sunset"
            changeRainLabel.isHidden = true
        }
    }
}
