//
//  HeaderViewModel.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol HeaderViewModelProtocol {
    var locationString: Observable<String> { get }
    var dayString: Observable<String> { get }
    var weatherIconString: Observable<String> { get }
    var temperatureString: Observable<String> { get }
    var humidityString: Observable<String> { get }
    var windSpeedString: Observable<String> { get }
    var windDirectionIconString: Observable<String> { get }
    var hourlyForecast: Observable<[Hourly]> { get }
    
    func selectedDayWeatherChanged(_ selectedDayWeather: SelectedDayWeather)
}

class HeaderViewModel {
    private var selectedDayWeather: SelectedDayWeather?
    
    private let _locationString = PublishSubject<String>()
    private let _dayString = PublishSubject<String>()
    private let _weatherIconString = PublishSubject<String>()
    private let _temperatureString = PublishSubject<String>()
    private let _humidityString = PublishSubject<String>()
    private let _windSpeedString = PublishSubject<String>()
    private let _windDirectionIconString = PublishSubject<String>()
    private let _hourlyForecast = PublishSubject<[Hourly]>()
    
    deinit {
        print("LOLLLL")
    }
}

//MARK: - Protocol methods
extension HeaderViewModel: HeaderViewModelProtocol {
    var locationString: RxSwift.Observable<String> {
        _locationString
    }
    
    var dayString: RxSwift.Observable<String> {
        _dayString
    }
    
    var weatherIconString: RxSwift.Observable<String> {
        _weatherIconString
    }
    
    var temperatureString: RxSwift.Observable<String> {
        _temperatureString
    }
    
    var humidityString: RxSwift.Observable<String> {
        _humidityString
    }
    
    var windSpeedString: RxSwift.Observable<String> {
        _windSpeedString
    }
    
    var windDirectionIconString: RxSwift.Observable<String> {
        _windDirectionIconString
    }
    
    var hourlyForecast: RxSwift.Observable<[Hourly]> {
        _hourlyForecast
    }
    
    func selectedDayWeatherChanged(_ selectedDayWeather: SelectedDayWeather) {
        _hourlyForecast.onNext(selectedDayWeather.hourlyForecast)
        _locationString.onNext(selectedDayWeather.cityName ?? "Unknown city")
        _humidityString.onNext("\(selectedDayWeather.daily?.humidity ?? 0)%")
        _windSpeedString.onNext("\(selectedDayWeather.daily?.windSpeed ?? 0)m/сек")
        
        setTemperature(from: selectedDayWeather.daily)
        setWeatherIcon(from: selectedDayWeather.daily?.weather?.first)
        setDayStringFrom(timestamp: selectedDayWeather.daily?.dt)
    }
}

//MARK: - Converting values to be ready for UI
private extension HeaderViewModel {
    
    func setTemperature(from dayWeather: Daily?) {
        guard let dayWeather = dayWeather else { return }
        
        let integerMinTemp = Int(dayWeather.temp?.min ?? 0)
        let integerMaxTemp = Int(dayWeather.temp?.max ?? 0)
        let tempString = "\(integerMaxTemp)°/\(integerMinTemp)°"
        
        _temperatureString.onNext(tempString)
    }
    
    func setWeatherIcon(from weather: Weather?) {
        guard let urlString = weather?.icon?.iconLinkFromName else { return }
        _weatherIconString.onNext(urlString)
    }
    
    func setDayStringFrom(timestamp: Double?) {
        guard let timestamp = timestamp else { return }
        
        let dateString = timestamp.dateStringFromTimeStamp(format: "dd MMM")
        let weekDayString = timestamp.dateStringFromTimeStamp(format: "EE").capitalized
        
        let resultString = "\(weekDayString), \(dateString)"
        
        _dayString.onNext(resultString)
    }
}
