//
//  MainViewController.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit
import RxSwift
import MapKit

class MainViewController: UIViewController {

    var coordinator: MainCoordinatorProtocol?
    var viewModel: MainViewModelProtocol?
    
    private let bag = DisposeBag()
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setup()
    }
}

//MARK: - Setup
private extension MainViewController {
    func setup() {
        setupLocationManager()
    }
}

//MARK: - Location
extension MainViewController: CLLocationManagerDelegate {
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else {
            return
        }
    
        print(location)
        locationManager.stopUpdatingLocation()
        //viewModel.setLocation(location: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let accuracy = manager.accuracyAuthorization
        
        switch accuracy {
        case .fullAccuracy:
            print("Location accuracy is precise.")
            
        case .reducedAccuracy:
            print("Location accuracy is not precise.")
            
        @unknown default:
          fatalError()
        }

        switch status {
        case .restricted, .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
            
        case .denied:
            print("denied")
            
        case .notDetermined:
            print("not determined")
            
        @unknown default:
            fatalError()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      locationManager.stopUpdatingLocation()
      print("Error: \(error)")
    }
}
