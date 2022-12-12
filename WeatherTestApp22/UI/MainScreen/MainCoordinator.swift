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

protocol MainCoordinatorProtocol {
    
}

class MainCoordinator: BaseCoordinator<Void>, MainCoordinatorProtocol {
    
    private let window: UIWindow
    private var navigationController: UINavigationController!

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
