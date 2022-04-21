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

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTodaysWeather()
    }
    
    private func setUpTodaysWeather() {
        currentWeatherViewModel.fetchCurrentWeatherResults { _ in
            guard let currentWeather = self.currentWeatherViewModel.objectCurrentWeather else { return }
            self.updateUpUI(currentWeather: currentWeather)
           }
       }
    
    func updateUpUI(currentWeather: CurrentWeather) {
        let currentTemp = currentWeather.main?.temp
        let minTemp = currentWeather.main?.tempMin
        let maxTemp = currentWeather.main?.tempMin
        currentTempValueLabel.text = String(currentTemp?.description ?? "" + "°")
        currentTempLabel.text = String(currentTemp?.description ?? "" + "°")
        minTempLabel.text = String(minTemp?.description ?? "" + "°")
        maxTempLabel.text = String(maxTemp?.description ?? "" + "°")
        cityNameLabel.text = currentWeather.sys.country
        weatherConditionLabel.text = currentWeather.weather?[0].main
        // weatherConditionLabel.text = currentWeather.weather?.first?.id
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
