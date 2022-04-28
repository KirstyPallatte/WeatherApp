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
    @IBOutlet weak private var weatherTableView: UITableView!
    @IBOutlet weak private var timestampLabel: UILabel!
    @IBOutlet weak var currentWeatherView: CurrentWeatherView!

    // MARK: - Vars/Lets
    private lazy var currentWeatherViewModel = CurrentWeatherViewModel(repository: CurrentWeatherRepository(),
                                                                       repositoryOffline: WeatherOfflineRepository(), 
                                                                       delegate: self)
    private lazy var locationManager = CLLocationManager()
    private var isImagePressed = false
    private var overallBackgroundColour: UIColor?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableview()
        setUpTodaysWeather()
        self.title = currentWeatherViewModel.phoneConnectivityStatus + " Weather"
    }
    
    // MARK: - @IBAction
    @IBAction private func changeImageButtonPressed(_ sender: Any) {
        isImagePressed = !isImagePressed
        currentWeatherViewModel.imagePressed(pressed: isImagePressed)
        setUpTodaysWeather()
    }
    
    @IBAction private func saveLocationButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "FaouritesViewController", sender: self)
    }
    
    // MARK: - Functions
    private func setUpTableview() {
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        weatherTableView.register(FiveDayForecastTableViewCell.self)
    }
    
    func setFavLatLong(cityLattitude: Double, cityLongitude: Double) {
        currentWeatherViewModel.setFavLatLong(cityLattitude: cityLattitude, cityLongitude: cityLongitude)
    }
    
    private func setUpTodaysWeather() {
        var isCurrentWeatherSavedInLocalDatabase = false
        var isForecastWeatherSavedInLocalDatabase = false
        
        if !currentWeatherViewModel.isPhoneOffline {
            currentWeatherViewModel.fetchCurrentWeatherResults { _ in
                isCurrentWeatherSavedInLocalDatabase = self.currentWeatherViewModel.isCurrentLocalDatabseWeatherEmpty()
                isForecastWeatherSavedInLocalDatabase =  self.currentWeatherViewModel.isForecastLocalDatabseWeatherEmpty()
                
                if isCurrentWeatherSavedInLocalDatabase && isForecastWeatherSavedInLocalDatabase {
                    self.fetchFiveDayForecastData()
                    self.updateUICurrentWeather()
                } else {
                    self.updateCurrentWetherInLocalDatabase()
                    self.fetchFiveDayForecastData()
                    self.updateForecastWetherInLocalDatabase()
                    self.updateUICurrentWeather()
                }
            }
        } else {
            currentWeatherViewModel.fetchOfflineCurrentWeatherResults()
            currentWeatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
            self.updateUICurrentWeather()
        }
    }
    
    func fetchFiveDayForecastData() {
        
        currentWeatherViewModel.fetchForecastCurrentWeatherResults { _ in
            guard self.currentWeatherViewModel.objectForecastWeather != nil else { return }
            self.saveForecastWetherInLocalDatabase()
            self.weatherTableView.reloadData()
        }
    }
    
    // MARK: - Local database
    func saveCurrentWetherInLocalDatabase() {
        guard let currentWeather = self.currentWeatherViewModel.objectCurrentWeather else { return }
        guard let nameCity = currentWeather.name else { return }
        guard let currentCondition = currentWeather.weather?[0].main else { return }
        guard let currentTemp = currentWeather.main?.temp else { return }
        guard let minTemp = currentWeather.main?.tempMin else { return }
        guard let maxTemp = currentWeather.main?.tempMin else { return }
        currentWeatherViewModel.saveCurrentWeatherInLocalDatabase(nameCity: nameCity,
                                                                  currentCondition: currentCondition,
                                                                  currentTemperature: currentTemp,
                                                                  maxTemperature: minTemp,
                                                                  minTemperature: maxTemp)
    }
    
    func saveForecastWetherInLocalDatabase() {
        guard let forecastWeatherCount = currentWeatherViewModel.objectForecastWeather?.list.count else { return }
        var conditionArr = [String]()
        var temperatureArr = [Double]()
        for index in 0..<forecastWeatherCount {
            guard let temperature = currentWeatherViewModel.objectForecastWeather?.list[index].main.temp,
                  let weatherCondition = currentWeatherViewModel.objectForecastWeather?.list[index].weather[0].main.lowercased() else { return }
            conditionArr.append(weatherCondition)
            temperatureArr.append(temperature)
            
        }
        currentWeatherViewModel.saveCurrentForecastInLocalDatabase(condition1: conditionArr[0],
                                                                   condition2: conditionArr[1],
                                                                   condition3: conditionArr[2],
                                                                   condition4: conditionArr[3],
                                                                   condition5: conditionArr[4],
                                                                   temperatureDay1: temperatureArr[0],
                                                                   temperatureDay2: temperatureArr[1],
                                                                   temperatureDay3: temperatureArr[2],
                                                                   temperatureDay4: temperatureArr[3],
                                                                   temperatureDay5: temperatureArr[4])
    }
    
    func updateCurrentWetherInLocalDatabase() {
        guard let currentWeather = self.currentWeatherViewModel.objectCurrentWeather,
        let nameCity = currentWeather.name,
        let currentCondition = currentWeather.weather?[0].main,
        let currentTemp = currentWeather.main?.temp,
        let minTemp = currentWeather.main?.tempMin,
        let maxTemp = currentWeather.main?.tempMin else { return }
        currentWeatherViewModel.updateCurrentWeatherInLocalDatabase(nameCity: nameCity,
                                                                    currentCondition: currentCondition,
                                                                    currentTemperature: currentTemp,
                                                                    maxTemperature: minTemp,
                                                                    minTemperature: maxTemp)
    }
    
    func updateForecastWetherInLocalDatabase() {
        guard let forecastWeatherCount = currentWeatherViewModel.objectForecastWeather?.list.count else { return }
        var conditionArr = [String]()
        var temperatureArr = [Double]()
        for index in 0..<forecastWeatherCount {
            guard let temperature = currentWeatherViewModel.objectForecastWeather?.list[index].main.temp,
                  let weatherCondition = currentWeatherViewModel.objectForecastWeather?.list[index].weather[0].main.lowercased() else { return }
            conditionArr.append(weatherCondition)
            temperatureArr.append(temperature)
            
        }
        currentWeatherViewModel.updateCurrentForecastInLocalDatabase(condition1: conditionArr[0],
                                                                     condition2: conditionArr[1],
                                                                     condition3: conditionArr[2],
                                                                     condition4: conditionArr[3],
                                                                     condition5: conditionArr[4],
                                                                     temperatureDay1: temperatureArr[0],
                                                                     temperatureDay2: temperatureArr[1],
                                                                     temperatureDay3: temperatureArr[2],
                                                                     temperatureDay4: temperatureArr[3],
                                                                     temperatureDay5: temperatureArr[4])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let currentWeather = self.currentWeatherViewModel.objectCurrentWeather,
        let locationName = currentWeather.name else { return }
        let locationLattitude = currentWeather.coord.lat
        let locationLogitude = currentWeather.coord.lon
        if let destination = segue.destination as? FavouriteLocationsViewController {
            destination.setSingleCityData(cityName: locationName,
                                          lattitude: locationLattitude,
                                          longitude: locationLogitude,
                                          image: Constants.SEASUNNY)
        }
        
    }
    
    private func updateUICurrentWeather() {
        
        if self.currentWeatherViewModel.isPhoneOffline {
            guard let currentWeatherOffline = self.currentWeatherViewModel.objectOfflineCurrentWeather else { return }
            setCurrentWeatherOffline(currentWeather: currentWeatherOffline)
        } else {
            guard let currentWeather = self.currentWeatherViewModel.objectCurrentWeather else { return }
            setCurrentWeather(currentWeather: currentWeather)
        }
    }
    
    func setCurrentWeather(currentWeather: CurrentWeather) {

        guard let nameCity = currentWeather.name,
        let currentCondition = currentWeather.weather?[0].main,
        let currentTemp = currentWeather.main?.temp,
        let minTemp = currentWeather.main?.tempMin,
        let maxTemp = currentWeather.main?.tempMin else { return }
        let imageCondition = currentWeatherViewModel.setBackgroundimage()
        let date = currentWeatherViewModel.lastUpdatedDateTime

        setWeatherUI(currentTemp: currentTemp,
                     minTemp: minTemp,
                     maxTemp: maxTemp,
                     nameCity: nameCity,
                     imageCondition: imageCondition,
                     currentCondition: currentCondition,
                     dateLastUpdated: date)
                     setBackgroundColoursCurrentWeather()
    }
    
    func setCurrentWeatherOffline(currentWeather: OfflineWeather) {
        guard let nameCity = currentWeather.cityName,
        let currentCondition = currentWeather.currentCondition else { return }
        let currentTemp = currentWeather.currentTemp
        guard let date = currentWeather.timeLastUpdated else { return }
        let minTemp = currentWeather.minTemp
        let maxTemp = currentWeather.minTemp
        let imageCondition = currentWeatherViewModel.setBackgroundimage()

        setWeatherUI(currentTemp: currentTemp,
                     minTemp: minTemp,
                     maxTemp: maxTemp,
                     nameCity: nameCity,
                     imageCondition: imageCondition,
                     currentCondition: currentCondition,
                     dateLastUpdated: date)
        setBackgroundColoursCurrentWeather()
    }
    
    private func setWeatherUI(currentTemp: Double,
                              minTemp: Double,
                              maxTemp: Double,
                              nameCity: String,
                              imageCondition:  String,
                              currentCondition: String,
                              dateLastUpdated: String) {
        
        currentWeatherView.setUpUI(currentTemp: currentTemp.description + "°",
                                   minTemp:  minTemp.description + "°",
                                   maxTemp: maxTemp.description  + "°",
                                   nameCity: nameCity,
                                   imageCondition: imageCondition,
                                   currentCondition: currentCondition)

        timestampLabel.text = "Last update: " + dateLastUpdated

    }
    
    private func setBackgroundColoursCurrentWeather() {
        
        var weatherConditionType: String

        if self.currentWeatherViewModel.isPhoneOffline {
            guard let currentWeatherOffline = self.currentWeatherViewModel.objectOfflineCurrentWeather else { return }
            weatherConditionType = currentWeatherOffline.currentCondition?.lowercased() ?? "sunny"
        } else {
            guard let currentWeather = self.currentWeatherViewModel.objectCurrentWeather else { return }
            weatherConditionType = currentWeather.weather?[0].main.lowercased() ?? "sunny"
        }

        let weatherCondition = WeatherCondition.init(rawValue: weatherConditionType)
        var backgroundColour: UIColor
        switch weatherCondition {
        case .sunny:
            backgroundColour = UIColor.sunnyAppColor
            
        case .clear:
            backgroundColour = UIColor.sunnyAppColor
            
        case .clouds:
            backgroundColour = UIColor.cloudyAppColor
            
        case .rain:
            backgroundColour = UIColor.rainyAppColor
            
        case .none:
            backgroundColour = UIColor.sunnyAppColor
        }
        
        currentWeatherView.setUpBackgroundColour(backgroundColour: backgroundColour)
        overallBackgroundColour = backgroundColour
    }
    
    private func setIconForecastWeather(currentCondition: String) -> UIImage {
        var backgroundIcon: UIImage
        let weatherCondition = WeatherCondition.init(rawValue: currentCondition)
        switch weatherCondition {
        case .sunny:
            backgroundIcon = UIImage.sunnyIcon
            
        case .clear:
            backgroundIcon =  UIImage.sunnyIcon
            
        case .clouds:
            backgroundIcon =  UIImage.cloudyIcon
            
        case .rain:
            backgroundIcon =  UIImage.rainyIcon
            
        case .none:
            backgroundIcon =  UIImage.sunnyIcon
        }
        return backgroundIcon
    }
}

extension CurrentWeatherViewController: CurrentWeatherViewModelDelegate {
    func didUpdateWeather(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.setUpTodaysWeather()
        }
    }
    
    func didFailWithError(error: NSError?) {
        displayAlert(alertTitle: "Location Error",
                     alertMessage: "Could not get your location",
                     alertActionTitle: "Try Again" ,
                     alertDelegate: self,
                     alertTriggered: .errorAlert)
    }
    
    func reloadView() {
        weatherTableView.reloadData()
    }
    
    func showError(error: String, message: String) {
        displayAlert(alertTitle: error,
                     alertMessage: message,
                     alertActionTitle: "Try Again" ,
                     alertDelegate: self,
                     alertTriggered: .errorAlert)
    }
}

// MARK: - Extension - UITableViewDelegate and DataSource
extension CurrentWeatherViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        var forecastWeatherCount = 0
        if !currentWeatherViewModel.isPhoneOffline {
            forecastWeatherCount = currentWeatherViewModel.objectForecastWeather?.list.count ?? 0
        } else {
            forecastWeatherCount = currentWeatherViewModel.objectOfflineForecastWeather?.condition1?.count ?? 0
        }
        return forecastWeatherCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var imageIcon: UIImage
        var forecastWeatherCount = 0
        let temperatureArr: [Double] = currentWeatherViewModel.arrayWeatherForecastTemperatures
        let conditionArr: [String] = currentWeatherViewModel.arrayWeatherForecastConditions
        
        guard let cell = tableView.dequeueReuseableCell(forIndexPath: indexPath,
                                                        reuseIdentifier: FiveDayForecastTableViewCell.reuseIdentifier)
                                                        as? FiveDayForecastTableViewCell
        else { return UITableViewCell() }

        if !currentWeatherViewModel.isPhoneOffline {
            forecastWeatherCount = currentWeatherViewModel.objectForecastWeather?.list.count ?? 0
        } else {
            forecastWeatherCount = 5
        }

        if indexPath.row > forecastWeatherCount - 1 {
            return UITableViewCell()
        } else {
            
            if !currentWeatherViewModel.isPhoneOffline {
               guard let temperature = currentWeatherViewModel.objectForecastWeather?.list[indexPath.row].main.temp else { return UITableViewCell() }
               guard let weatherCondition = currentWeatherViewModel.objectForecastWeather?.list[indexPath.row].weather[0].main.lowercased()
            else { return UITableViewCell() }
               guard let colour =  overallBackgroundColour else { return UITableViewCell() }
               imageIcon = setIconForecastWeather(currentCondition: weatherCondition)
               cell.setCellItems(temperature: temperature,
                              day: currentWeatherViewModel.dayOfWeeekArray(index: indexPath.row),
                              colour: colour,
                              imageIcon: imageIcon)
            } else {
                let temperatureForecast = temperatureArr[indexPath.row]
                let weatherConditionForecast = conditionArr[indexPath.row]
                guard let colour =  overallBackgroundColour else { return UITableViewCell() }
                imageIcon = setIconForecastWeather(currentCondition: weatherConditionForecast)
                cell.setCellItems(temperature: temperatureForecast,
                                  day: currentWeatherViewModel.dayOfWeeekArray(index: indexPath.row),
                                  colour: colour,
                                  imageIcon: imageIcon)
        }
        }
        return cell
    }
}
