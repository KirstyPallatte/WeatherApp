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
    private var forcastObject: ForecastData?
    private lazy var locationManager = CLLocationManager()
    private lazy var isChangeImagePressed = false
    private var dayOfWeek = ["Sunday","Monday","Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    private var dayWeekIndex: Int = 0
    private var restructDayWeek: [String] = []
    private var favLattiude: Double?
    private var favLongitude: Double?
    private var currentLocationLattiude: Double?
    private var currentLoationLongitude: Double?
    
    var objectCurrentWeather: CurrentWeather? {
        return currentWeatherObject
    }
    
    var objectForecastWeather: ForecastData? {
        return forcastObject
    }
    
    var isPressed: Bool? {
        return isChangeImagePressed
    }
    
    func setFavLatLong(cityLattitude: Double, cityLongitude: Double) {
        favLattiude = cityLattitude
        favLongitude = cityLongitude
    }
    
    // MARK: - Constructor
    init(repository: SearchCurrentWeatherRepositoryType,
         delegate: CurrentWeatherViewModelDelegate) {
         super.init()
         self.currentWeatherRepository = repository
         self.delegate = delegate
         locationManager.delegate = self
         setUpLocationData()
         weekDay()
         setweekDayArr()
    }
    
    // MARK: - Functions
    func fetchCurrentWeatherResults(completion: @escaping (CurrentWeather) -> Void) {
        if favLattiude != nil && favLongitude != nil {
            currentLocationLattiude = favLattiude
            currentLoationLongitude = favLongitude
        } else {
            currentLocationLattiude = locationManager.location?.coordinate.latitude
            currentLoationLongitude = locationManager.location?.coordinate.longitude
        }
            currentWeatherRepository?.fetchSearchResults(latitude: currentLocationLattiude ?? -28.4793,
                                                         longitude: currentLoationLongitude ?? 24.6727,
                                                         completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let weatherData):
                        self?.currentWeatherObject = weatherData
                        completion(weatherData)
                        self?.delegate?.reloadView()
                    case .failure(let error):
                        self?.delegate?.showError(error: error.rawValue, message: "Could not retrieve the current weather.")
                    }
                }
            })
        }
    
    func fetchForecastCurrentWeatherResults(completion: @escaping (ForecastData) -> Void) {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            currentWeatherRepository?.fetchForecastSearchResults(latitude: latitude, longitude: longitude, completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let forecastData):
                        self?.forcastObject = forecastData
                        completion(forecastData)
                        self?.delegate?.reloadView()
                    case .failure(let error):
                        self?.delegate?.showError(error: error.rawValue, message: "Could not retrieve the forecast weather.")
                    }
                }
            })
        }
    }
    
    private func weekDay() {
        dayWeekIndex = Date().dayNumberOfWeek()!
    }
    
    private func setweekDayArr() {
        var arrWeekDayIndex = dayWeekIndex
        var weekDayIndex = 1
        
        while weekDayIndex != 7 {
            if arrWeekDayIndex + 1 == 7 || arrWeekDayIndex + 1 == 8 {
                arrWeekDayIndex = 0
            } else {
                arrWeekDayIndex += 1
            }
            restructDayWeek.append(dayOfWeek[arrWeekDayIndex])
            weekDayIndex += 1
        }
    }

    func dayOfWeeekArray(index: Int) -> String {
        return restructDayWeek[index]
    }
    
    func imagePressed(pressed: Bool) {
        isChangeImagePressed = pressed
    }
    
    func setBackgroundimage() -> String {
        var imagePath = ""
        guard let pressedimage = isPressed else { return Constants.FORESTSUNNY }
        guard let weatherConditionType = currentWeatherObject?.weather?[0].main.lowercased() else { return Constants.FORESTSUNNY }
        let weatherCondition = WeatherCondition.init(rawValue: weatherConditionType)
        switch weatherCondition {
        case .sunny:
            imagePath = !pressedimage ? Constants.FORESTSUNNY :  Constants.SEASUNNY
        case .clear:
            imagePath = !pressedimage ? Constants.FORESTSUNNY :  Constants.SEASUNNY
        case .clouds:
            imagePath = !pressedimage ? Constants.FORESTCLOUDY :  Constants.SEACLOUDY
        case .rain:
            imagePath = !pressedimage ? Constants.FORESTRAINY :  Constants.SEARAINY
        case .none:
            imagePath = !pressedimage ? Constants.FORESTSUNNY :  Constants.SEASUNNY
        }
        return imagePath
    }
}

// MARK: - Current Location
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
        delegate?.showError(error: "Location Error", message: "Cannot get your current location")
    }
}
