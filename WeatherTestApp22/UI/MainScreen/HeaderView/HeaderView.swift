//
//  HeaderView.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit

class HeaderView: UIView {
    
    @IBOutlet private weak var locationStackView: UIStackView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var windDirectionImageView: UIImageView!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windSpeedLabel: UILabel!
    @IBOutlet private weak var weatherIconImageView: UIImageView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var selectLocationButton: UIButton!
    @IBOutlet private weak var hourForecastCollectionView: UICollectionView!
    @IBOutlet private weak var cityLabel: UILabel!
    
    init() {
        let size = CGSize(width: UIScreen.main.bounds.width, height: 380)
        let frame = CGRect(origin: .zero, size: size)
        super.init(frame: frame)
        initXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initXib()
    }
    
    private func initXib() {
        guard let viewFromXib = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?[0] as? UIView else {
            print("HeaderView init error")
            return
        }
        
        viewFromXib.frame = self.bounds
        viewFromXib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(viewFromXib)
    }
}


//MARK: - Setup
private extension HeaderView {
    func setup() {
        registerNibs()
    }
    
    func registerNibs() {
        let nib = UINib(nibName: "HourForecastCollectionViewCell", bundle: .main)
        hourForecastCollectionView.register(nib,
                                            forCellWithReuseIdentifier: "HourForecastCollectionViewCell")
    }
}
