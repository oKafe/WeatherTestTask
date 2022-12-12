//
//  MapViewCoordinator.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import UIKit
import RxSwift
import MapKit

protocol MapViewCoordinatorProtocol {
    func close()
}

class MapViewCoordinator: BaseCoordinator<CLLocation> {
    
    private var navigationController: UINavigationController!
    private let location: CLLocation

    init(navigationController: UINavigationController, location: CLLocation) {
        self.navigationController = navigationController
        self.location = location
    }
    
    override func start() -> Observable<CLLocation> {
        let mapViewModel = MapViewModel(location: location)
        
        let mapViewController = MapViewController()
        mapViewController.coordinator = self
        mapViewController.viewModel = mapViewModel
        
        navigationController.pushViewController(mapViewController, animated: true)

        return mapViewModel.rxLocation
    }
}


extension MapViewCoordinator: MapViewCoordinatorProtocol {
    func close() {
        navigationController.popViewController(animated: true)
    }
}
