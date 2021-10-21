//
//  DailyCell.swift
//  WeatherDemo
//
//  Created by Ngô Minh Tuấn on 29/08/2021.
//

import UIKit

class DailyCell: UICollectionViewCell {
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var changeRainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(data: DailyWeather) {
        weekDayLabel.text = data.weekDayString
        minTempLabel.text = "\(Int(data.minTemp))"
        maxTempLabel.text = "\(Int(data.maxTemp))"
        changeRainLabel.text = "\(Int(data.changeRain!))%"
    }
    
    

}
