//
//  MapViewController.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var coordinator: MapViewCoordinatorProtocol?
    var viewModel: MapViewModelProtocol?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Action
    @IBAction func tapOnMapAction(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            viewModel?.saveLocation(location)
            coordinator?.close()
        }
    }
}

//MARK: - Setup
private extension MapViewController {
    func setup() {
        title = "Select place on map"
        setupMap()
    }
    
    func setupMap() {
        guard let location = viewModel?.location else { return }
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: 10000,
                                                  longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
