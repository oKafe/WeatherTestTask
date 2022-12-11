//
//  BaseCoordinator.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import RxSwift
import Foundation

class BaseCoordinator<ResultType>: NSObject {
    
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
        
    private func store<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }
    
    private func free<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }
    
    func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.free(coordinator: coordinator)
            })
    }
    
    func start() -> Observable<ResultType> {
        fatalError("Coordinator start method should be implemented")
    }
}
