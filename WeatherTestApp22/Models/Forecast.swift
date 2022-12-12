//
//  Forecast.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import Mapper

// MARK: - Forecast
struct Forecast: Mappable, Codable {
    let lat: Double?
    let lon: Double?
    let timezone: String?
    let timezoneOffset: Int?
    let hourly: [Hourly]?
    let daily: [Daily]?

    init(map: Mapper) throws {
        lat = map.optionalFrom("lat")
        lon = map.optionalFrom("lon")
        timezone = map.optionalFrom("timezone")
        timezoneOffset = map.optionalFrom("timezone_offset")
        hourly = map.optionalFrom("hourly")
        daily = map.optionalFrom("daily")
    }
}

// MARK: - Daily
struct Daily: Mappable, Codable {
    let dt: Double?
    let temp: Temp?
    let humidity: Int?
    let windSpeed: Double?
    let windDeg: Double?
    let weather: [Weather]?

    init(map: Mapper) throws {
        dt = map.optionalFrom("dt")
        temp = map.optionalFrom("temp")
        humidity = map.optionalFrom("humidity")
        windSpeed = map.optionalFrom("wind_speed")
        windDeg = map.optionalFrom("wind_deg")
        weather = map.optionalFrom("weather")
    }
}

// MARK: - Temp
struct Temp: Mappable, Codable {
    let min: Double?
    let max: Double?

    init(map: Mapper) throws {
        min = map.optionalFrom("min")
        max = map.optionalFrom("max")
    }
}

// MARK: - Weather
struct Weather: Mappable, Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?

    
    init(map: Mapper) throws {
        id = map.optionalFrom("id")
        main = map.optionalFrom("main")
        weatherDescription = map.optionalFrom("description")
        icon = map.optionalFrom("icon")
    }
}

// MARK: - Hourly
struct Hourly: Mappable, Codable {
    let dt: Double?
    let temp: Double?
    let humidity: Int?
    let windSpeed: Double?
    let windDeg: Int?
    let weather: [Weather]?

    init(map: Mapper) throws {
         dt = map.optionalFrom("dt")
         temp = map.optionalFrom("temp")
         humidity = map.optionalFrom("humidity")
         windSpeed = map.optionalFrom("wind_speed")
         windDeg = map.optionalFrom("wind_deg")
         weather = map.optionalFrom("weather")
    }
}
