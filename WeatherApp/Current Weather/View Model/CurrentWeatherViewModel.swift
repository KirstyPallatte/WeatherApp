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
    private var offlineWeatherRepository: WeatherOfflineRepository?
    private weak var delegate: CurrentWeatherViewModelDelegate?
    private var currentWeatherObject: CurrentWeather?
    private var currentOfflineWeatherObject: OfflineWeather?
    private var forcastOfflineWeatherObject: OfflineFiveDayForecast?
    private var isOffline = true
    private var forcastObject: ForecastData?
    private lazy var locationManager = CLLocationManager()
    private lazy var isChangeImagePressed = false
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
    
    var objectOfflineCurrentWeather: OfflineWeather? {
        return currentOfflineWeatherObject
    }
    
    var objectOfflineForecastWeather: OfflineFiveDayForecast? {
        return forcastOfflineWeatherObject
    }
    
    var isPressed: Bool? {
        return isChangeImagePressed
    }
    
    var isPhoneOffline: Bool {
        return isOffline
    }
    
    var lastUpdatedDateTime: String {
        return Date().todaysTimestamp()
    }

    var phoneConnectivityStatus: String {
        return isPhoneOffline ? "Offline" : "Online"
    }
    
    var arrayWeatherForecastTemperatures: [Double] {
        var temperatureArr: [Double] = []
        guard let temp1 =  objectOfflineForecastWeather?.temperatureDay1 else { return temperatureArr }
        guard let temp2 =  objectOfflineForecastWeather?.temperatureDay2 else { return temperatureArr }
        guard let temp3 =  objectOfflineForecastWeather?.temperatureDay3 else { return temperatureArr }
        guard let temp4 =  objectOfflineForecastWeather?.temperatureDay4 else { return temperatureArr }
        guard let temp5 =  objectOfflineForecastWeather?.temperatureDay5 else { return temperatureArr }
        temperatureArr = [temp1, temp2, temp3, temp4, temp5]
        return temperatureArr
    }
    
    var arrayWeatherForecastConditions: [String] {
        var conditonArr: [String] = []
        guard let condition1 =  objectOfflineForecastWeather?.condition1 else { return conditonArr }
        guard let condition2 =  objectOfflineForecastWeather?.condition2 else { return conditonArr }
        guard let condition3 =  objectOfflineForecastWeather?.condition3 else { return conditonArr }
        guard let condition4 =  objectOfflineForecastWeather?.condition4 else { return conditonArr }
        guard let condition5 =  objectOfflineForecastWeather?.condition5 else { return conditonArr }
        conditonArr = [condition1, condition2, condition3, condition4, condition5]
        return conditonArr
    }
    
    // MARK: - Constructor
    init(repository: SearchCurrentWeatherRepositoryType, repositoryOffline: WeatherOfflineRepository,
         delegate: CurrentWeatherViewModelDelegate) {
         super.init()
         self.currentWeatherRepository = repository
         self.offlineWeatherRepository = repositoryOffline
         self.delegate = delegate
         locationManager.delegate = self
         let internetReachability = Reachability()
        
        if internetReachability.isConnectedToNetwork() {
            isOffline = false
            setUpLocationData()
        } else {
            isOffline = true
        }
        
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
                    switch result {
                    case .success(let weatherData):
                        self?.currentWeatherObject = weatherData
                        completion(weatherData)
                        self?.delegate?.reloadView()
                    case .failure(let error):
                        self?.delegate?.showError(error: error.rawValue, message: "Could not retrieve the current weather.")
                    }
            })
        }
    
    func fetchForecastCurrentWeatherResults(completion: @escaping (ForecastData) -> Void) {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longitude = locationManager.location?.coordinate.longitude {
            currentWeatherRepository?.fetchForecastSearchResults(latitude: latitude, longitude: longitude, completion: { [weak self] result in
                    switch result {
                    case .success(let forecastData):
                        self?.forcastObject = forecastData
                        completion(forecastData)
                        self?.delegate?.reloadView()
                    case .failure(let error):
                        self?.delegate?.showError(error: error.rawValue, message: "Could not retrieve the forecast weather.")
                    }
            })
        }
    }
    
    func isCurrentLocalDatabseWeatherEmpty() -> Bool {
        guard let bCurrentWeatherIsEmpty = offlineWeatherRepository?.checkIfLocalDatabaseCurrentWeatherIsEmpty() else { return true }
        return bCurrentWeatherIsEmpty
    }
    
    func isForecastLocalDatabseWeatherEmpty() -> Bool {
        guard let bCurrentWeatherIsEmpty = offlineWeatherRepository?.checkIfLocalDatabaseForecastWeatherIsEmpty() else { return true }
        return bCurrentWeatherIsEmpty
    }
    
    // MARK: - Local Database function fetch
    func fetchOfflineCurrentWeatherResults() {
        offlineWeatherRepository?.fetchSavedOfflineWeather { [weak self] savedWeather in
            switch savedWeather {
            case .success(let savedWeatherData):
                self?.currentOfflineWeatherObject = savedWeatherData
            case .failure:
                self?.delegate?.showError(error: "Unable to get offline data",
                                          message: "There was a problem fetching offline weather data")
            }
        }
    }
    
    func fetchOfflineFiveDayForecastWeatherResults() {
        offlineWeatherRepository?.fetchFiveDayForecastWeather { [weak self] savedForecatWeather in
            switch savedForecatWeather {
            case .success(let savedsavedForecatWeatherData):
                self?.forcastOfflineWeatherObject = savedsavedForecatWeatherData
                self?.delegate?.reloadView()
            case .failure:
                self?.delegate?.showError(error: "Unable to get offline data",
                                          message: "There was a problem fetching offline forecast data")
            }
        }
    }
    
    // MARK: - Local Database function save
    func saveCurrentWeatherInLocalDatabase(nameCity: String,
                                           currentCondition: String,
                                           currentTemperature: Double,
                                           maxTemperature: Double,
                                           minTemperature: Double) {

        offlineWeatherRepository?.saveOfflineCurrentWeather(cityName: nameCity,
                                                            currentCondition: currentCondition,
                                                            currentTemp: currentTemperature,
                                                            maxTemp: maxTemperature,
                                                            minTemp: minTemperature,
                                                            dateTime: lastUpdatedDateTime) { [weak self] savedWeather in
            switch savedWeather {
            case .success:
                self?.delegate?.reloadView()
            case .failure:
                self?.delegate?.showError(error: "Unable to save \(nameCity)",
                                          message: "There was a problem saving offline weather data")
            }
            self?.fetchOfflineCurrentWeatherResults()
        }
    }
    
    func saveCurrentForecastInLocalDatabase(condition1: String,
                                            condition2: String,
                                            condition3: String,
                                            condition4: String,
                                            condition5: String,
                                            temperatureDay1: Double,
                                            temperatureDay2: Double,
                                            temperatureDay3: Double,
                                            temperatureDay4: Double,
                                            temperatureDay5: Double) {
        offlineWeatherRepository?.saveOfflineFiveDayForecastWeather(conditionDay1: condition1,
                                                                    conditionDay2: condition2,
                                                                    conditionDay3: condition3,
                                                                    conditionDay4: condition4,
                                                                    conditionDay5: condition5,
                                                                    tempDay1: temperatureDay1,
                                                                    tempDay2: temperatureDay2,
                                                                    tempDay3: temperatureDay3,
                                                                    tempDay4: temperatureDay4,
                                                                    tempDay5: temperatureDay5) { [weak self] savedForecastWeather in
            switch savedForecastWeather {
            case .success:
                self?.delegate?.reloadView()
            case .failure:
                self?.delegate?.showError(error: "Unable to save offline weather",
                                          message: "There was a problem saving offline weather data")
            }
            self?.fetchOfflineCurrentWeatherResults()
        }
    }
    
    // MARK: - Local Database function save
    func updateCurrentWeatherInLocalDatabase(nameCity: String,
                                             currentCondition: String,
                                             currentTemperature: Double,
                                             maxTemperature: Double,
                                             minTemperature: Double) {
        offlineWeatherRepository?.updateCurrentWeather(cityName: nameCity,
                                                       currentCondition: currentCondition,
                                                       currentTemp: currentTemperature,
                                                       maxTemp: maxTemperature,
                                                       minTemp: minTemperature,
                                                       datetime: lastUpdatedDateTime)
    }
    
    func updateCurrentForecastInLocalDatabase(condition1: String,
                                              condition2: String,
                                              condition3: String,
                                              condition4: String,
                                              condition5: String,
                                              temperatureDay1: Double,
                                              temperatureDay2: Double,
                                              temperatureDay3: Double,
                                              temperatureDay4: Double,
                                              temperatureDay5: Double) {
        offlineWeatherRepository?.updateForecastWeather(conditionDay1: condition1,
                                                                    conditionDay2: condition2,
                                                                    conditionDay3: condition3,
                                                                    conditionDay4: condition4,
                                                                    conditionDay5: condition5,
                                                                    tempDay1: temperatureDay1,
                                                                    tempDay2: temperatureDay2,
                                                                    tempDay3: temperatureDay3,
                                                                    tempDay4: temperatureDay4,
                                                                    tempDay5: temperatureDay5)
    }
    
    func setFavLatLong(cityLattitude: Double, cityLongitude: Double) {
        favLattiude = cityLattitude
        favLongitude = cityLongitude
    }
    
    private func weekDay() {
        dayWeekIndex = Date().dayNumberOfWeek()!
    }
    
     func setweekDayArr() {
         restructDayWeek = Date().setNewWeekArray
    }

    func dayOfWeeekArray(index: Int) -> String {
        return restructDayWeek[index]
    }
    
    func imagePressed(pressed: Bool) {
        isChangeImagePressed = pressed
    }
    
    func setBackgroundimage() -> String {
        
        var weatherConditionType: String
        var imagePath = ""
        
        if isPhoneOffline {
            guard let currentWeatherOffline = objectOfflineCurrentWeather else { return Constants.SEASUNNY  }
            weatherConditionType = currentWeatherOffline.currentCondition?.lowercased() ?? Constants.SEASUNNY
        } else {
            guard let currentWeather = objectCurrentWeather else { return Constants.SEASUNNY }
            weatherConditionType = currentWeather.weather?[0].main.lowercased() ?? Constants.SEASUNNY
        }
 
        guard let pressedimage = isPressed else { return Constants.FORESTSUNNY }
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
