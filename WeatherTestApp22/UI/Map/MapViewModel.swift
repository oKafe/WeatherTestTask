//
//  MapViewModel.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import CoreLocation
import RxSwift

protocol MapViewModelProtocol {
    var location: CLLocation { get }
    func saveLocation(_ location: CLLocation)
}

class MapViewModel: MapViewModelProtocol {
    private(set) var location: CLLocation
    var rxLocation = PublishSubject<CLLocation>()
    
    init(location: CLLocation) {
        self.location = location
    }
    
    func saveLocation(_ location: CLLocation) {
        rxLocation.onNext(location)
    }
}
