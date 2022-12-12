//
//  MainScreenCoordinator.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import Foundation
import UIKit
import Moya
import RxSwift
import CoreLocation

protocol MainCoordinatorProtocol {
    func openMapView(location: CLLocation) -> Observable<CLLocation>
    func openSearchView() -> Observable<CLLocation>
}

class MainCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow
    private var navigationController: UINavigationController!
    
    private let bag = DisposeBag()

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let mainScreenProvider = MoyaProvider<WeatherEndpoints>()
        let mainViewModel = MainViewModel(provider: mainScreenProvider)
        
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        mainViewController.viewModel = mainViewModel
        
        
        navigationController = UINavigationController(rootViewController: mainViewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        return Observable.never()
    }
}

extension MainCoordinator: MainCoordinatorProtocol {
    func openMapView(location: CLLocation) -> Observable<CLLocation> {
        let coordinator = MapViewCoordinator(navigationController: navigationController, location: location)
        
        return coordinate(to: coordinator)
    }
    
    func openSearchView() -> Observable<CLLocation> {
        let coordinator = SearchCoordinator(navigationController: navigationController)
        
        return coordinate(to: coordinator)
    }
}
