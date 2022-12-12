//
//  SearchViewController.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit
import RxSwift
import MapKit

class SearchViewController: UIViewController {

    var viewModel: SearchViewModelProtocol?
    var coordinator: SearchCoordinatorProtocol?
    
    @IBOutlet private weak var tableView: UITableView!
    private lazy var searchBar = UISearchBar(frame: CGRectMake(0, 0, 200, 20))
    
    private var bag = DisposeBag()
    private let tapGestureRecognizer = UITapGestureRecognizer()
    
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
}

//MARK: - Setup
private extension SearchViewController {
    func setup() {
        setupGestureRecognizer()
        setupSearchBar()
        setupTableView()
        bindViewModel()
    }
    
    func setupGestureRecognizer() {
        tapGestureRecognizer.addTarget(self, action: #selector(onTap))
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
    }
    
    func setupSearchBar() {
        navigationItem.titleView = searchBar
    }
    
    func setupTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: tableView!,
                           attribute: .bottom,
                           relatedBy: .equal,
                           toItem: view.keyboardLayoutGuide,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0).isActive = true
//        tableView.addConstraint(bottomConstraint)
        
        let nib = UINib(nibName: "CityTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CityTableViewCell")
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
    }
    
    func bindViewModel() {
        searchBar
            .rx
            .text
            .bind { [weak self] text in
                self?.viewModel?.queryChanged(text ?? "")
            }
            .disposed(by: bag)
        
        viewModel?
            .searchResults
            .bind(to: tableView.rx.items(cellIdentifier: "CityTableViewCell",
                                         cellType: CityTableViewCell.self)) { (_, model, cell) in
                cell.configureWith(model: model)
            }
            .disposed(by: bag)
        
        tableView
            .rx
            .modelSelected(MKLocalSearchCompletion.self)
            .bind { [weak self] completion in
                self?.viewModel?.selectCity(completion: completion)
            }
            .disposed(by: bag)
        
        viewModel?
            .rxLocation
            .bind(onNext: { [weak self] _ in
                self?.coordinator?.close()
            })
            .disposed(by: bag)
    }
}

//MARK: - Actions
private extension SearchViewController {
    @objc func onTap() {
        searchBar.resignFirstResponder()
    }
}
