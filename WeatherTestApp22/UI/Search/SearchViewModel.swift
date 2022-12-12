//
//  SearchViewModel.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 12.12.2022.
//

import Foundation
import MapKit
import RxSwift

protocol SearchViewModelProtocol {
    var searchResults: Observable<[MKLocalSearchCompletion]> { get }
    var rxLocation: Observable<CLLocation> { get }
    
    func queryChanged(_ query: String)
    func selectCity(completion: MKLocalSearchCompletion)
}

class SearchViewModel: NSObject {
    private var _rxLocation = PublishSubject<CLLocation>()
    private var _searchResults = PublishSubject<[MKLocalSearchCompletion]>()
    
    private var searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        setupSearchCompleter()
    }
}

//MARK: - SearchViewModelProtocol
extension SearchViewModel: SearchViewModelProtocol {
    var searchResults: Observable<[MKLocalSearchCompletion]> {
        _searchResults
    }
    
    var rxLocation: Observable<CLLocation> {
        _rxLocation
    }
    
    func queryChanged(_ query: String) {
        searchCompleter.queryFragment = query
    }
    
    func selectCity(completion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: completion)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { [weak self] (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }

            let location = CLLocation(latitude: coordinate.latitude,
                                       longitude: coordinate.longitude)
            self?._rxLocation.onNext(location)
        }
    }
}

//MARK: - MKLocalSearchCompleterDelegate
extension SearchViewModel: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        let results = completer.results.filter { result in
            guard result.title.contains(",") || !result.subtitle.isEmpty else { return false }
            
            guard !result.subtitle.contains("Nearby") else { return false }
                    return true
            }
        
        self._searchResults.onNext(results)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}

private extension SearchViewModel {
    func setupSearchCompleter() {
        self.searchCompleter.delegate = self
        self.searchCompleter.region = MKCoordinateRegion(.world)
        self.searchCompleter.pointOfInterestFilter = MKPointOfInterestFilter.excludingAll
    }
}
