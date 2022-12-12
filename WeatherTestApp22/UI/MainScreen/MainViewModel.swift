//
//  MainViewModel.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import Foundation
import RxSwift
import MapKit
import Moya
import Mapper
import Moya_ModelMapper
import RxRelay

protocol MainViewModelProtocol {
    var selectedDayWeather: Observable<SelectedDayWeather> { get }
    var dailyForecast: Observable<[Daily]> { get }

    var location: CLLocation? { get }
    
    func setLocation(location: CLLocation)
    func selectDay(_ day: Daily)
    func isDaySelected(_ day: Daily) -> Bool
}

class MainViewModel {
    
    private var forecast: Forecast?
    private var _selectedDayWeather = BehaviorRelay<SelectedDayWeather>(value: SelectedDayWeather())
    private var _dailyForecast = PublishSubject<[Daily]>()
    
    private var currentLocation: Coordinates?
    private let provider: MoyaProvider<WeatherEndpoints>
    private let bag = DisposeBag()
    
    init(provider: MoyaProvider<WeatherEndpoints>, currentLocation: Coordinates? = nil) {
        self.provider = provider
        self.currentLocation = currentLocation
    }
}

//MARK: - Protocol methods
extension MainViewModel: MainViewModelProtocol {
    
    var location: CLLocation? {
        currentLocation?.clLocation
    }
    
    var selectedDayWeather: RxSwift.Observable<SelectedDayWeather> {
        _selectedDayWeather.asObservable()
    }
    
    var dailyForecast: RxSwift.Observable<[Daily]> {
        _dailyForecast
    }
    
    func setLocation(location: CLLocation) {
        setCurrentLocation(location)
    }
    
    func selectDay(_ day: Daily) {
        let hourlyForecast = (forecast?.hourly ?? []).filter({
            ($0.dt ?? 0) >= (day.dt ?? 0) &&
            ($0.dt ?? 0) <= (day.dt ?? 0) + 86400 /// 86400 - seconds in day
        })
        
        let selectedDayWeather = SelectedDayWeather(cityName: currentLocation?.cityName,
                                                    daily: day,
                                                    hourlyForecast: hourlyForecast)
        _selectedDayWeather.accept(selectedDayWeather)
    }
    
    func isDaySelected(_ day: Daily) -> Bool {
        return _selectedDayWeather.value.daily?.dt == day.dt
    }
}

//MARK: - Private
private extension MainViewModel {
    func setCurrentLocation(_ location: CLLocation) {
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] (placemarks, _) -> Void in
            
            var coordinates = Coordinates(lon: location.coordinate.longitude,
                                                lat: location.coordinate.latitude)
            
            placemarks?.forEach { (placemark) in
                if let city = placemark.locality {
                    coordinates.cityName = city
                }
            }
            self?.currentLocation = coordinates
            self?.getWeather(for: coordinates)
        })
    }
    
    func getWeather(for location: Coordinates) {
        provider
            .rx
            .request(.weatherForecast(coordinates: location))
            .debug()
            .mapOptional(to: Forecast.self)
            .subscribe { [weak self] forecast in
                guard let forecast = forecast else { return }
                
                self?.selectFirstDayFrom(forecast: forecast)
                self?._dailyForecast.onNext(forecast.daily ?? [])
                self?.forecast = forecast
                
            } onError: { error in
                print("GET WEATHER ERROR:")
                print(error.localizedDescription)
            }
            .disposed(by: bag)
    }
    
    func selectFirstDayFrom(forecast: Forecast) {
        let selectedDayWeather = SelectedDayWeather(cityName: currentLocation?.cityName,
                                                    daily: forecast.daily?.first,
                                                    hourlyForecast: forecast.hourly ?? [])
        _selectedDayWeather.accept(selectedDayWeather)
    }
}
