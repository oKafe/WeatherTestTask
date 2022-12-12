//
//  CityTableViewCell.swift
//  WeatherTestApp22
//
//  Created by JkPhTrue Just on 13.12.2022.
//

import UIKit
import MapKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(model: MKLocalSearchCompletion) {
        titleLabel.text = model.title + (model.subtitle.isEmpty ? "" : ", " + model.subtitle)
    }
}
