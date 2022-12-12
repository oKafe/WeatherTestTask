//
//  Observable+Ext.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import RxSwift
import Moya

protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension ObservableType where Element == Response {

    func filterApiSuccess() -> Observable<Element> {
        return flatMap { (response) -> Observable<Element> in
            if 200 ... 299 ~= response.statusCode {
                return Observable.just(response)
            }

            return .error(MoyaError.statusCode(response))
        }
    }
}
