//
//  Coordinates.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import Foundation
import CoreLocation

struct Coordinates {
    let lon: Double
    let lat: Double
    var cityName: String?
    
    var clLocation: CLLocation {
        return CLLocation(latitude: lat, longitude: lon)
    }
}
