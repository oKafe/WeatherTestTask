//
//  Temperature.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import Foundation
import Mapper

struct Temp: Mappable, Codable {
    let min: Double?
    let max: Double?

    init(map: Mapper) throws {
        min = map.optionalFrom("min")
        max = map.optionalFrom("max")
    }
}
