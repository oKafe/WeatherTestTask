//
//  Hourly.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import Foundation
import Mapper

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
