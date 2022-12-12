//
//  Forecast.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import Mapper

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
