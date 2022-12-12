//
//  SearchCoordinator.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import UIKit
import RxSwift
import MapKit

protocol SearchCoordinatorProtocol {
    func close()
}

class SearchCoordinator: BaseCoordinator<CLLocation> {
    
    private var navigationController: UINavigationController!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() -> Observable<CLLocation> {
        let searchViewModel = SearchViewModel()
        
        let searchViewController = SearchViewController()
        searchViewController.coordinator = self
        searchViewController.viewModel = searchViewModel
        
        navigationController.pushViewController(searchViewController, animated: true)

        return searchViewModel.rxLocation
    }
}


extension SearchCoordinator: SearchCoordinatorProtocol {
    func close() {
        navigationController.popViewController(animated: true)
    }
}
