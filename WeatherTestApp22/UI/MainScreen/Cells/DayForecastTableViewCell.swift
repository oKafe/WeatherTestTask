//
//  DayForecastTableViewCell.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit

class DayForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureWith(dayWeather: Daily, selected: Bool) {
        switchSelected(selected: selected)
        addShadowIfSelected(selected)
        setDayWeek(from: dayWeather.dt)
        setWeatherIcon(from: dayWeather.weather?.first)
        setTemperature(from: dayWeather)
    }
    
}

private extension DayForecastTableViewCell {
    func switchSelected(selected: Bool) {
        let color = selected ? UIColor(named: "MainBlue") : .black
        dayLabel.textColor = color
        temperatureLabel.textColor = color
    }
    
    func setDayWeek(from timestamp: Double?) {
        guard let timestamp = timestamp else { return }
        
        dayLabel.text = timestamp.dateStringFromTimeStamp(format: "EE").capitalized
    }
    
    func setWeatherIcon(from weather: Weather?) {
        weatherIconImageView.image = nil
        guard let urlString = weather?.icon?.iconLinkFromName else { return }
        
        weatherIconImageView.downloaded(from: urlString)
    }
    
    func setTemperature(from dayWeather: Daily?) {
        guard let dayWeather = dayWeather else { return }
        
        let integerMinTemp = Int(dayWeather.temp?.min ?? 0)
        let integerMaxTemp = Int(dayWeather.temp?.max ?? 0)
        
        temperatureLabel.text = "\(integerMaxTemp)°/\(integerMinTemp)°"
    }
    
    func addShadowIfSelected(_ selected: Bool) {
        contentView.layer.masksToBounds = false
        contentView.layer.shadowOffset = CGSize.zero
        contentView.layer.shadowRadius = 15
        contentView.layer.shadowColor = UIColor(named: "SecondBlue")?.cgColor
        contentView.layer.shadowOpacity = selected ? 0.25 : 0
        contentView.layer.shouldRasterize = true
        contentView.layer.rasterizationScale = UIScreen.main.scale
    }
}
