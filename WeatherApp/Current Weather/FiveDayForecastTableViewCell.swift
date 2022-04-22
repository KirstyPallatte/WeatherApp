//
//  FiveDayForecastTableViewCell.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/22.
//

import UIKit

class FiveDayForecastTableViewCell: UITableViewCell {
    @IBOutlet weak private var forecastView: UIView!
    @IBOutlet weak private var fiveDayTemperatureLabel: UILabel!
    @IBOutlet weak private var fiveDayIconImage: UIImageView!
    @IBOutlet weak private var fiveDayLabel: UILabel!
    private var backgroundCellColour: UIColor?
    
    static let identifier = "ForecastCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = backgroundCellColour

    }
    
    func setCellItems(temperature: Double, day: String, colour: UIColor, imageIcon: UIImage) {
        fiveDayTemperatureLabel.text = temperature.description + "°"
        fiveDayLabel.text = day.description
        fiveDayIconImage.image = imageIcon
        forecastView.backgroundColor = colour
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
