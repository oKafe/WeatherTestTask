//
//  HeaderView.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 11.12.2022.
//

import UIKit
import RxSwift
import RxCocoa

class HeaderView: UIView {
    
    var viewModel: HeaderViewModelProtocol? = HeaderViewModel()
    
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
    
    var openMapHandler: (() -> Void)?
    
    private let bag = DisposeBag()
    
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
        
        setup()
    }
    
    func configureWith(model: SelectedDayWeather) {
        viewModel?.selectedDayWeatherChanged(model)
        hourForecastCollectionView.isHidden = model.hourlyForecast.count <= 0
    }
    
    @IBAction func openMapAction(_ sender: Any) {
        openMapHandler?()
    }
}


//MARK: - Setup
private extension HeaderView {
    func setup() {
        setupCollectionView()
        bindViewModel()
    }
    
    func setupCollectionView() {
        let nib = UINib(nibName: "HourForecastCollectionViewCell", bundle: .main)
        hourForecastCollectionView.register(nib,
                                            forCellWithReuseIdentifier: "HourForecastCollectionViewCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        flowLayout.itemSize = CGSize(width: 60, height: 128)
        
        hourForecastCollectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
    
    func bindViewModel() {
        viewModel?.locationString.bind(to: cityLabel.rx.text).disposed(by: bag)
        viewModel?.dayString.bind(to: dayLabel.rx.text).disposed(by: bag)
        viewModel?.temperatureString.bind(to: temperatureLabel.rx.text).disposed(by: bag)
        viewModel?.humidityString.bind(to: humidityLabel.rx.text).disposed(by: bag)
        viewModel?.windSpeedString.bind(to: windSpeedLabel.rx.text).disposed(by: bag)
        
        viewModel?.weatherIconString
            .bind(onNext: { [weak self] urlString in
                self?.weatherIconImageView.downloaded(from: urlString)
            })
            .disposed(by: bag)
        
        viewModel?
            .hourlyForecast
            .bind(to: hourForecastCollectionView.rx.items(cellIdentifier: "HourForecastCollectionViewCell", cellType: HourForecastCollectionViewCell.self)) { (row, model, cell) in
                cell.configureWith(hourWeather: model)
            }
            .disposed(by: bag)
    }
}
