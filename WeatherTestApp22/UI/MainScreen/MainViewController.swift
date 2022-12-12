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
        
    @IBOutlet private weak var tableView: UITableView!
    private let headerView = HeaderView()
    
    private let bag = DisposeBag()
    private var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

//MARK: - Setup
private extension MainViewController {
    func setup() {
        navigationController?.navigationBar.isHidden = true
        
        setupLocationManager()
        setupTableView()
        
        bindViewModel()
    }
    
    func setupTableView() {
        tableView.tableHeaderView = headerView
    }
    
    func bindViewModel() {
        viewModel?.selectedDayWeather
            .bind(onNext: { [weak self] selectedDayWeather in
                self?.headerView.configureWith(model: selectedDayWeather)
            })
            .disposed(by: bag)
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
    
        viewModel?.setLocation(location: location)
        locationManager.stopUpdatingLocation()
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
