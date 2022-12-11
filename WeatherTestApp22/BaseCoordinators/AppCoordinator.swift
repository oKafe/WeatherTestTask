//
//  AppCoordinator.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import Foundation
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {

    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }

    override func start() -> Observable<Void> {
        let mainCoordinator = MainCoordinator(window: window)
        
        return coordinate(to: mainCoordinator)
    }
}
