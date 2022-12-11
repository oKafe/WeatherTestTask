//
//  MainViewController.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit

class MainViewController: UIViewController {

    var coordinator: MainCoordinatorProtocol?
    var viewModel: MainViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
}
