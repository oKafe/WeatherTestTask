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
        setupHeaderView()
        
        bindViewModel()
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "DayForecastTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "DayForecastTableViewCell")
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
    }
    
    func setupHeaderView() {
        headerView.openMapHandler = { [weak self] in
            self?.openMapAction()
        }
        
        headerView.openSearchHandler = { [weak self] in
            self?.openSearchAction()
        }
    }
    
    func bindViewModel() {
        viewModel?
            .selectedDayWeather
            .bind(onNext: { [weak self] selectedDayWeather in
                self?.headerView.configureWith(model: selectedDayWeather)
            })
            .disposed(by: bag)
        
        viewModel?
            .dailyForecast
            .bind(to: tableView.rx.items(cellIdentifier: "DayForecastTableViewCell", cellType: DayForecastTableViewCell.self)) { [weak self] (row, day, cell) in
                
                let selected = self?.viewModel?.isDaySelected(day) ?? false
                cell.configureWith(dayWeather: day, selected: selected)
            }
            .disposed(by: bag)
        
        tableView.rx
            .modelSelected(Daily.self)
            .bind { [weak self] day in
                self?.viewModel?.selectDay(day)
                self?.tableView.reloadData()
            }
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

//MARK: - Open VCs to select locations from map and search
private extension MainViewController {
    func openMapAction() {
        guard let location = viewModel?.location else { return }
        coordinator?
            .openMapView(location: location)
            .bind(onNext: { [weak self] location in
                self?.viewModel?.setLocation(location: location)
            })
            .disposed(by: bag)
    }
    
    func openSearchAction() {
        coordinator?
            .openSearchView()
            .bind(onNext: { [weak self] location in
                self?.viewModel?.setLocation(location: location)
            })
            .disposed(by: bag)
    }
}
