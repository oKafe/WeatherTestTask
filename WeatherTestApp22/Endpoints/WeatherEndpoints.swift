//
//  WeatherEndpoints.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import Moya

struct Coordinates: Mappable {
    let lon: Double
    let lat: Double
}

enum Exclude: String {
    typealias RawValue = String
    
    case Current = "current"
    case Minutely = "minutely"
    case Hourly = "hourly"
    case Daily = "daily"
    case Alerts = "alerts"
}

enum WeatherEndpoints {
    case weatherForecast(coordinates: Coordinates)
}

extension WeatherEndpoints: TargetType {
    
    var baseURL: URL {
        return URL(string: "http://api.openweathermap.org/data/3.0")!
    }
    
    var path: String {
        switch self {
        case .weatherForecast(_):
            return "/onecall"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    
    var task: Task {
        switch self {
        case .weatherForecast(let coordinates):
            return .requestParameters(
                parameters: [
                    "lat": coordinates.lat,
                    "lon": coordinates.lon,
                    "exclude": "hourly, daily",
                    "appid": "fa7164787f5997600c2b11d5265905a1"],
                encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
