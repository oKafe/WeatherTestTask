//
//  SelectedDayWeather.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation

struct SelectedDayWeather {
    let cityName: String?
    let daily: Daily?
    let hourlyForecast: [Hourly]
    
    init(cityName: String? = nil, daily: Daily? = nil, hourlyForecast: [Hourly] = []) {
        self.cityName = cityName
        self.daily = daily
        self.hourlyForecast = hourlyForecast
    }
}
