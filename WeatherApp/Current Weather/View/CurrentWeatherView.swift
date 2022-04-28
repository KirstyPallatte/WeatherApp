//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/28.
//

import UIKit

@IBDesignable class CurrentWeatherView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet weak  var currentTempValueLabel: UILabel!
    @IBOutlet weak private var weatherConditionLabel: UILabel!
    @IBOutlet weak private var weatherImageViewTheme: UIImageView!
    @IBOutlet weak private var currentBackgroundView: UIView!
    @IBOutlet weak private var minTempLabel: UILabel!
    @IBOutlet weak private var currentTempLabel: UILabel!
    @IBOutlet weak private var maxTempLabel: UILabel!
    @IBOutlet weak private var cityNameLabel: UILabel!
    @IBOutlet var weatherView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        weatherView = loadViewFromNib(nibName: "CurrentWeatherView")
        weatherView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        weatherView.frame = self.bounds
        addSubview(weatherView)
    }

    func setUpUI(currentTemp: String,
                 minTemp: String,
                 maxTemp: String,
                 nameCity: String,
                 imageCondition: String,
                 currentCondition: String) {
        
        weatherView.bringSubviewToFront(currentTempValueLabel)
        weatherView.bringSubviewToFront(weatherConditionLabel)
        weatherView.bringSubviewToFront(cityNameLabel)
        
        currentTempValueLabel.text = currentTemp
        currentTempLabel.text = currentTemp
        minTempLabel.text = minTemp
        maxTempLabel.text = maxTemp
        cityNameLabel.text = nameCity
        weatherConditionLabel.text = currentCondition
        weatherImageViewTheme.image = UIImage(named: imageCondition)
    }
    
    func setUpBackgroundColour(backgroundColour: UIColor) {
        weatherImageViewTheme.backgroundColor = backgroundColour
        currentBackgroundView.backgroundColor = backgroundColour
        weatherView.backgroundColor = backgroundColour
    }
}
