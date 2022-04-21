//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import Foundation
import CoreLocation

// MARK: - CurrentWeatherViewModel Delegate
protocol CurrentWeatherViewModelDelegate: AnyObject {
    func didUpdateWeather(weather: CurrentWeather)
    func didFailWithError(error: NSError?)
    func reloadView()
    func showError(error: String, message: String)
}

class CurrentWeatherViewModel: NSObject {
    
    // MARK: - Vars/Lets
    private var currentWeatherRepository: SearchCurrentWeatherRepositoryType?
    private weak var delegate: CurrentWeatherViewModelDelegate?
    private var currentWeatherObject: CurrentWeather?
    private lazy var locationManager = CLLocationManager()
    
    // MARK: - Constructor
    init(repository: SearchCurrentWeatherRepositoryType,
         delegate: CurrentWeatherViewModelDelegate) {
         super.init()
         self.currentWeatherRepository = repository
         self.delegate = delegate
         locationManager.delegate = self
         setUpLocationData()
    }
    
    // MARK: - Functions
    func fetchCurrentWeatherResults(completion: @escaping (CurrentWeather) -> Void) {
        if let latitude = locationManager.location?.coordinate.latitude,
                let longitude = locationManager.location?.coordinate.longitude {
        currentWeatherRepository?.fetchSearchResults(latitude: latitude, longitude: longitude, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let weatherData):
                    self?.currentWeatherObject = weatherData
                    print(weatherData)
                    completion(weatherData)
                    self?.delegate?.reloadView()
                case .failure(let error):
                    self?.delegate?.showError(error: error.rawValue, message: "Could not retrieve the current weather.")
                }
            }
        })
        }
    }
    
     var objectCurrentWeather: CurrentWeather? {
        return currentWeatherObject
    }
}

extension CurrentWeatherViewModel: CLLocationManagerDelegate {
    
    func setUpLocationData() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil {
            locationManager.stopUpdatingLocation()
            guard let safeWeather = currentWeatherObject else { return }
            self.delegate?.didUpdateWeather(weather: safeWeather)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
