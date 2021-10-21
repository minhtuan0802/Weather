//
//  HomeViewController.swift
//  WeatherDemo
//
//  Created by Ngô Minh Tuấn on 27/08/2021.
//

import UIKit

class HomeViewController: UIViewController {
    //MARK: - IBoutlet
    @IBOutlet weak var timelineCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionView: UICollectionView!
    @IBOutlet weak var detailTodayCollectionView: UICollectionView!
    
    //MARK: - Varibbles
    var weather: Weather!
    var dailyWeathers = [DailyWeather]()
    var timelineWeather = [Timeline]()
    var todayWeather = TodayWeather()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        fetchData()
    }

    func fetchData() {
        APIService().getWeather { weather in
            if let weather = weather {
                self.weather = weather
                self.processWeather()
                self.updateUI()
            }
        }
    }
    
    func config() {
        configCollectionView()
    }
    
    func configCollectionView() {
        timelineCollectionView.dataSource = self
        timelineCollectionView.delegate = self
//        timelineCollectionView.register(UINib.ini(nibName: "timeline", Bundle: nil), forCellWithReuseIdentifier: "TimelineCell")
        timelineCollectionView.registerCell(type: TimelineCell.self)
        
        dailyCollectionView.dataSource = self
        dailyCollectionView.delegate = self
        dailyCollectionView.registerCell(type: DailyCell.self)
        
        detailTodayCollectionView.dataSource = self
        detailTodayCollectionView.delegate = self
        detailTodayCollectionView.registerCell(type: DetailTodayCell.self)
        
    }
    
    //MARK: - Helper
    func processWeather() {
        self.dailyWeathers = self.weather.dailyWeathers
        self.todayWeather = self.weather.todayWeather
        processTimelineWeather()

    }
    
    func processTimelineWeather() {
        timelineWeather.append(self.weather.currentWeather!)
        timelineWeather.append(contentsOf: self.weather.hourlyWeathers)
        
        if weather.todayWeather.sunrise!.time > weather.currentWeather.time && weather.todayWeather.sunrise.time < weather.hourlyWeathers.last!.time {
            timelineWeather.append(weather.todayWeather.sunrise)
        }
        
        if weather.todayWeather.sunset!.time > weather.currentWeather.time && weather.todayWeather.sunset.time < weather.hourlyWeathers.last!.time {
            timelineWeather.append(weather.todayWeather.sunset)
        }
        
        let tomorowWeather = self.weather.dailyWeathers.first!
        
        if tomorowWeather.sunrise!.time > weather.currentWeather.time && tomorowWeather.sunrise.time < weather.hourlyWeathers.last!.time {
            timelineWeather.append(tomorowWeather.sunrise)
        }
        
        if tomorowWeather.sunset!.time > weather.currentWeather.time && tomorowWeather.sunset.time < weather.hourlyWeathers.last!.time {
            timelineWeather.append(tomorowWeather.sunset)
        }

        timelineWeather.sort { timeLine1, timeLine2 in
            return timeLine1.getTime() < timeLine2.getTime()
        }
        
    }
    
    func updateUI() {
        self.timelineCollectionView.reloadData()
        self.dailyCollectionView.reloadData()
        self.detailTodayCollectionView.reloadData()
        print("today: \(todayWeather.humidity)")

    }
    


}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == timelineCollectionView {
            return timelineWeather.count
        } else if collectionView == dailyCollectionView {
            return dailyWeathers.count
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == timelineCollectionView {
            let timelineCell = collectionView.dequeueCell(type: TimelineCell.self, indexPath: indexPath)
            timelineCell?.bind(data: timelineWeather[indexPath.item])
            return timelineCell ?? UICollectionViewCell()
        } else if collectionView == dailyCollectionView {
            let dailyCell = collectionView.dequeueCell(type: DailyCell.self, indexPath: indexPath)
            dailyCell?.bind(data: dailyWeathers[indexPath.item])
            return dailyCell ?? UICollectionViewCell()
        } else {
            let todayCell = collectionView.dequeueCell(type: DetailTodayCell.self, indexPath: indexPath)
            switch indexPath.row {
            case 0:
                todayCell?.dataTitle.text = "\(todayWeather.sunrise?.timeString ?? "")"
                todayCell?.nameTitle.text = "MT Mọc"
            case 1:
                todayCell?.dataTitle.text = "\(todayWeather.sunset?.timeString ?? "")"
                todayCell?.nameTitle.text = "MT Lặn"
            case 2:
                if let clouds = todayWeather.clouds {
                    todayCell?.dataTitle.text = "\(Int(clouds))%"
                }
                todayCell?.nameTitle.text = "Khả Năng Mưa"

            case 3:
                if let humidity = todayWeather.humidity {
                    todayCell?.dataTitle.text = "\(humidity)%"
                }
                todayCell?.nameTitle.text = "Độ Ẩm"
            case 4:
                if let windSpeed = todayWeather.windSpeed {
                    todayCell?.dataTitle.text = "TN \(Int(windSpeed)) km/h"
                }
                todayCell?.nameTitle.text = "Gió"
            case 5:
                if let feelsLikeNight = todayWeather.feelsLikeNight, let feelsLikeDay = todayWeather.feelsLikeDay {
                    if weather.todayWeather.sunrise.time < weather.todayWeather.time && weather.todayWeather.time < weather.todayWeather.sunset.time  {
                        todayCell?.dataTitle.text = "\(Int(feelsLikeDay))°"
                    } else {
                        todayCell?.dataTitle.text = "\(Int(feelsLikeNight))°"
                    }
                }
                todayCell?.nameTitle.text = "Nhiệt Độ Cảm Nhận"
            default:
                return UICollectionViewCell()
            }
            return todayCell ?? UICollectionViewCell()
        }
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == timelineCollectionView {
            return CGSize(width: 65, height: 120)
        } else if collectionView == dailyCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: 35)
        } else {
            return CGSize(width: UIScreen.main.bounds.width/2, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
