//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import UIKit
import CoreLocation

class CurrentWeatherViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak private var currentTempValueLabel: UILabel!
    @IBOutlet weak private var weatherConditionLabel: UILabel!
    @IBOutlet weak private var weatherImageViewTheme: UIImageView!
    @IBOutlet weak private var currentBackgroundView: UIView!
    @IBOutlet weak private var minTempLabel: UILabel!
    @IBOutlet weak private var currentTempLabel: UILabel!
    @IBOutlet weak private var maxTempLabel: UILabel!
    @IBOutlet weak private var cityNameLabel: UILabel!
    
    // MARK: - Vars/Lets
    private lazy var currentWeatherViewModel = CurrentWeatherViewModel(repository: CurrentWeatherRepository(),
                                                                       delegate: self)
    private lazy var locationManager = CLLocationManager()
    private var currentWeather: CurrentWeather?
    private var isImagePressed = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTodaysWeather()
    }
    
    // MARK: - @IBAction
    @IBAction private func changeImageButtonPressed(_ sender: Any) {
        isImagePressed = !isImagePressed
        currentWeatherViewModel.imagePressed(pressed: isImagePressed)
        setUpTodaysWeather()
    }
    
    // MARK: - Functions
    private func setUpTodaysWeather() {
        currentWeatherViewModel.fetchCurrentWeatherResults { _ in
            guard let currentWeather = self.currentWeatherViewModel.objectCurrentWeather else { return }
            self.updateUpUI(currentWeather: currentWeather)
           }
       }
    
    func updateUpUI(currentWeather: CurrentWeather) {
        guard let currentTemp = currentWeather.main?.temp else { return }
        guard let minTemp = currentWeather.main?.tempMin else { return }
        guard let maxTemp = currentWeather.main?.tempMin else { return }
        let imageCondition = currentWeatherViewModel.setBackgroundimage()
        let currentCondition = currentWeather.weather?[0].main
        
        currentTempValueLabel.text = currentTemp.description + "°"
        currentTempLabel.text = currentTemp.description + "°"
        minTempLabel.text = minTemp.description + "°"
        maxTempLabel.text = maxTemp.description  + "°"
        cityNameLabel.text = currentWeather.sys.country
        weatherConditionLabel.text = currentCondition
        weatherImageViewTheme.image = UIImage(named: imageCondition)
        setBackgroundColours(currentWeather: currentWeather)
    }
    
    func setBackgroundColours(currentWeather: CurrentWeather) {
        
        guard let weatherConditionType = currentWeather.weather?[0].main.lowercased() else { return }
        let weatherCondition = WeatherCondition.init(rawValue: weatherConditionType)
        switch weatherCondition {
        case .sunny:
            currentBackgroundView.backgroundColor = UIColor.sunnyAppColor
            weatherImageViewTheme.backgroundColor = UIColor.sunnyAppColor
            
        case .clear:
            currentBackgroundView.backgroundColor = UIColor.sunnyAppColor
            weatherImageViewTheme.backgroundColor = UIColor.sunnyAppColor
            
        case .clouds:
            currentBackgroundView.backgroundColor = UIColor.cloudyAppColor
            weatherImageViewTheme.backgroundColor = UIColor.cloudyAppColor
        
        case .rain:
            weatherImageViewTheme.image = UIImage(named: Constants.FORESTRAINY)
            currentBackgroundView.backgroundColor = UIColor.rainyAppColor
            weatherImageViewTheme.backgroundColor = UIColor.rainyAppColor
        
        case .none:
            currentBackgroundView.backgroundColor = UIColor.sunnyAppColor
            weatherImageViewTheme.backgroundColor = UIColor.sunnyAppColor
}
}
}

extension CurrentWeatherViewController: CurrentWeatherViewModelDelegate {
    func didUpdateWeather(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.setUpTodaysWeather()
        }
    }
    
    func didFailWithError(error: NSError?) {
        print(error?.localizedDescription as Any)
    }
    
    func reloadView() {
        
    }
    
    func showError(error: String, message: String) {
        
    }
}
