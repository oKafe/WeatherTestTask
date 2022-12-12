//
//  HourForecastCollectionViewCell.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit

class HourForecastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureWith(hourWeather: Hourly) {
        setTime(from: hourWeather.dt)
        setWeatherIcon(from: hourWeather.weather?.first)
        setTemperature(from: hourWeather.temp)
    }
}

private extension HourForecastCollectionViewCell {
    func setTime(from timestamp: Double?) {
        guard let timestamp = timestamp else { return }
        
        timeLabel.text = timestamp.dateStringFromTimeStamp(format: "HH:mm")
    }
    
    func setWeatherIcon(from weather: Weather?) {
        weatherIconImageView.image = nil
        guard let urlString = weather?.icon?.iconLinkFromName else { return }
        
        weatherIconImageView.downloaded(from: urlString)
    }
    
    func setTemperature(from temp: Double?) {
        let integerTemp = Int(temp ?? 0)
        
        temperatureLabel.text = "\(integerTemp)°"
    }
}
