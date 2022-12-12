//
//  Weather.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import Foundation
import Mapper

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
