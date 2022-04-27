//
//  ForecastOfflineWeatherTest.swift
//  ForecastOfflineWeatherTest
//
//  Created by Kirsty-Lee Walker on 2022/04/26.
//

import XCTest
import CoreLocation
import CoreData
@testable import WeatherApp

class OfflineWeatherTest: XCTestCase {
    private var weatherViewModel: CurrentWeatherViewModel!
    private var mockWeatherDelegat: MockForecastWeatherDelegate!
    private var mockWeatherRepository: MockWeatherForecastRepository!
    private var offlineWeatherRepository: MockOfflineForecastRepository!
    private var container: NSPersistentContainer!
    
    override func setUp() {
        mockWeatherDelegat = MockForecastWeatherDelegate()
        mockWeatherRepository = MockWeatherForecastRepository()
        offlineWeatherRepository = MockOfflineForecastRepository()
        weatherViewModel = CurrentWeatherViewModel(repository: mockWeatherRepository,
                                                   repositoryOffline: offlineWeatherRepository,
                                                   delegate: mockWeatherDelegat)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        container = NSPersistentContainer(name: "WeatherApp")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    // MARK: - Local database Current Weather
    func testWeatherCount_ReturnsEqual() {
        let expectedCount = 1
        var localDatabse: OfflineWeather
        localDatabse = OfflineWeather(context: container.viewContext)
        offlineWeatherRepository.setContainer(viewContainer: container)
        localDatabse.cityName = "Johburg"
        localDatabse.timeLastUpdated = "25 August 1999"
        localDatabse.currentCondition = "sunny"
        localDatabse.currentTemp = 20
        localDatabse.maxTemp = 30
        localDatabse.minTemp = 20
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        let weatherCount = offlineWeatherRepository.totalNumber(in: container.viewContext)
        XCTAssertEqual(weatherCount, expectedCount)
    }

    func testWeatherSaved_ReturnsNotNil() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentWeatherInLocalDatabase(nameCity: "Johburg", currentCondition: "sunny",
                                                           currentTemperature: 20, maxTemperature: 30, minTemperature: 10)
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        XCTAssertNotNil(weatherViewModel.objectOfflineCurrentWeather)
    }
    
    func testWeatherSaved_ReturnsNil() {
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentWeatherInLocalDatabase(nameCity: "Johburg", currentCondition: "sunny", currentTemperature: 20,
                                                           maxTemperature: 30, minTemperature: 10)
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        XCTAssertNil(weatherViewModel.objectOfflineCurrentWeather)
    }
    
    func testWeatherUpdated_ReturnsEqual() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.updateCurrentWeatherInLocalDatabase(nameCity: "Cape Town", currentCondition: "sunny", currentTemperature: 20,
                                                             maxTemperature: 30, minTemperature: 10)
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        XCTAssertEqual(weatherViewModel.objectOfflineCurrentWeather?.cityName, "Cape Town")
    }
    
    func testWeatherUpdated_ReturnsNotEqual() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.updateCurrentWeatherInLocalDatabase(nameCity: "Johburg", currentCondition: "sunny", currentTemperature: 20,
                                                             maxTemperature: 30,  minTemperature: 10)
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        XCTAssertNotEqual(weatherViewModel.objectOfflineCurrentWeather?.cityName, "Cape Town")
        XCTAssertFalse(mockWeatherDelegat.errorCalled)
    }
    
    func testWeatherIsEmpty_ReturnsFalse() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentWeatherInLocalDatabase(nameCity: "Johburg", currentCondition: "sunny", currentTemperature: 20,
                                                           maxTemperature: 30, minTemperature: 10)
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        XCTAssertFalse(offlineWeatherRepository.checkIfLocalDatabaseCurrentWeatherIsEmpty(in: container.viewContext))
    }
    
    // MARK: - Local database Forecast
    func testWeatherCount_ReturnsTrue() {
        var localDatabse: OfflineFiveDayForecast
        localDatabse = OfflineFiveDayForecast(context: container.viewContext)
        offlineWeatherRepository.setContainer(viewContainer: container)
        localDatabse.condition1 = "sunny"
        localDatabse.condition2 = "sunny"
        localDatabse.condition3 = "sunny"
        localDatabse.condition4 = "rainy"
        localDatabse.condition5 = "sunny"
        localDatabse.temperatureDay1 = 10
        localDatabse.temperatureDay2 = 10
        localDatabse.temperatureDay3 = 10
        localDatabse.temperatureDay4 = 10
        localDatabse.temperatureDay5 = 10
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
        XCTAssertTrue(mockWeatherDelegat.errorCalled)
    }
    
    func testWeatherForecastCount_ReturnsEqual() {
        offlineWeatherRepository.shouldPass = true
        let expectedCount = 1
        var localDatabse: OfflineFiveDayForecast
        localDatabse = OfflineFiveDayForecast(context: container.viewContext)
        offlineWeatherRepository.setContainer(viewContainer: container)
        localDatabse.condition1 = "sunny"
        localDatabse.condition2 = "sunny"
        localDatabse.condition3 = "sunny"
        localDatabse.condition4 = "rainy"
        localDatabse.condition5 = "sunny"
        localDatabse.temperatureDay1 = 10
        localDatabse.temperatureDay2 = 10
        localDatabse.temperatureDay3 = 10
        localDatabse.temperatureDay4 = 10
        localDatabse.temperatureDay5 = 10
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
        let weatherCount = offlineWeatherRepository.totalNumberForecast(in: container.viewContext)
        XCTAssertEqual(weatherCount,expectedCount)
    }
    
    func testForecastWeatherSaved_ReturnsNotNil() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentForecastInLocalDatabase(condition1: "sunny", condition2: "sunny", condition3: "sunny",
                                                            condition4: "sunny", condition5: "sunny", temperatureDay1: 12,
                                                            temperatureDay2: 25, temperatureDay3: 18, temperatureDay4: 20, temperatureDay5: 20)
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
        XCTAssertNotNil(weatherViewModel.objectOfflineForecastWeather)
    }
    
    func testForecastWeatherSaved_ReturnsTrue() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentForecastInLocalDatabase(condition1: "sunny", condition2: "sunny", condition3: "sunny",
                                                            condition4: "sunny", condition5: "sunny", temperatureDay1: 12, temperatureDay2: 25,
                                                            temperatureDay3: 18, temperatureDay4: 20, temperatureDay5: 20)
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
        XCTAssertTrue(mockWeatherDelegat.reloadViewCalled)
    }
    
    func testForecastWeatherSaved_ReturnsFalse() {
        offlineWeatherRepository.shouldPass = false
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentForecastInLocalDatabase(condition1: "sunny", condition2: "sunny", condition3: "sunny",
                                                            condition4: "sunny", condition5: "sunny", temperatureDay1: 12,
                                                            temperatureDay2: 25, temperatureDay3: 18, temperatureDay4: 20, temperatureDay5: 20)
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
        XCTAssertFalse(mockWeatherDelegat.reloadViewCalled)
    }
    
    func testForecastWeatherSaved_ReturnsNil() {
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentForecastInLocalDatabase(condition1: "sunny", condition2: "sunny", condition3: "sunny",
                                                            condition4: "sunny", condition5: "sunny", temperatureDay1: 12,
                                                            temperatureDay2: 25, temperatureDay3: 18, temperatureDay4: 20, temperatureDay5: 20)
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
        XCTAssertNil(weatherViewModel.objectOfflineForecastWeather)
    }
    
    func testForcastWeatherUpdated_ReturnsEqual() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.updateCurrentForecastInLocalDatabase(condition1: "rainy", condition2: "sunny", condition3: "sunny",
                                                              condition4: "sunny", condition5: "sunny", temperatureDay1: 10,
                                                              temperatureDay2: 10, temperatureDay3: 10, temperatureDay4: 10, temperatureDay5: 20)
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()
        XCTAssertEqual(weatherViewModel.objectOfflineForecastWeather?.condition1, "rainy")
    }
    
    func testForecastWeatherUpdated_ReturnsNotEqual() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.updateCurrentForecastInLocalDatabase(condition1: "rainy", condition2: "sunny",
                                                              condition3: "sunny", condition4: "sunny",
                                                              condition5: "sunny", temperatureDay1: 10,
                                                              temperatureDay2: 10, temperatureDay3: 10,
                                                              temperatureDay4: 10, temperatureDay5: 20)
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        XCTAssertNotEqual(weatherViewModel.objectOfflineForecastWeather?.condition1, "sunny")
    }
    
    func testForecastWeatherIsEmpty_ReturnsFalse() {
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentForecastInLocalDatabase(condition1: "rainy", condition2: "sunny",
                                                            condition3: "sunny", condition4: "sunny",
                                                            condition5: "sunny", temperatureDay1: 10,
                                                            temperatureDay2: 10, temperatureDay3: 10,
                                                            temperatureDay4: 10, temperatureDay5: 20)
        weatherViewModel.fetchOfflineCurrentWeatherResults()
        XCTAssertFalse(offlineWeatherRepository.checkIfLocalDatabaseForecastWeatherIsEmpty(in: container.viewContext))
    }
    
    func testWeatherForecastCount_ReturnsTrue() {
        let conditonArr: [String] = ["sunny","sunny","sunny","sunny","sunny"]
        let conditonTemp: [Double] = [12,25,18,20,20]
        offlineWeatherRepository.shouldPass = true
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentForecastInLocalDatabase(condition1: "sunny", condition2: "sunny",
                                                            condition3: "sunny", condition4: "sunny",
                                                            condition5: "sunny", temperatureDay1: 12,
                                                            temperatureDay2: 25, temperatureDay3: 18,
                                                            temperatureDay4: 20, temperatureDay5: 20)
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()

        XCTAssertEqual(conditonArr,weatherViewModel.arrayWeatherForecastConditions)
        XCTAssertEqual(conditonTemp,weatherViewModel.arrayWeatherForecastTemperatures)
    }
    
    func testWeatherForecastCount_ReturnsFalse() {
        let conditonArr: [String] = ["sunny","sunny","sunny","sunny","sunny"]
        let conditonTemp: [Double] = [12,25,18,20,20]
        offlineWeatherRepository.setContainer(viewContainer: container)
        weatherViewModel.saveCurrentForecastInLocalDatabase(condition1: "sunny", condition2: "sunny",
                                                            condition3: "sunny", condition4: "sunny",
                                                            condition5: "sunny",
                                                            temperatureDay1: 12, temperatureDay2: 25,
                                                            temperatureDay3: 18, temperatureDay4: 20,
                                                            temperatureDay5: 20)
        weatherViewModel.fetchOfflineFiveDayForecastWeatherResults()

        XCTAssertNotEqual(conditonArr,weatherViewModel.arrayWeatherForecastConditions)
        XCTAssertNotEqual(conditonTemp,weatherViewModel.arrayWeatherForecastTemperatures)
    }
}

class MockForecastWeatherDelegate: CurrentWeatherViewModelDelegate {
    var reloadViewCalled = false
    var errorCalled = false
    var didUpdateWeaherCalled = false
    var didFailWeatherCalled = false
    
    func reloadView() {
        reloadViewCalled = true
    }
    
    func showError(error: String, message: String) {
        errorCalled = true
    }
    
    func didUpdateWeather(weather: CurrentWeather) {
        didUpdateWeaherCalled = true
    }
    
    func didFailWithError(error: NSError?) {
        didFailWeatherCalled = true
    }
}

class MockWeatherForecastRepository: SearchCurrentWeatherRepositoryType {
    var shouldPass = false
    func fetchSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CurrentWeatherResult)) {
    }
    
    func fetchForecastSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (FiveDayForecastResult)) {
    }

    private var setForecastMockData: ForecastData {
        var forecastData: ForecastData
        forecastData = ForecastData(cod: "24", message: 1, cnt: 1,
                                    list: [ListItem(dt: 15, main: ForecastMain(temp: 15, tempMin: 16, tempMax: 20, pressure: 23,
                                                                               seaLevel: 24, grndLevel: 56, humidity: 1, tempKf: 12),
                                                    weather: [ForecastWeather(id: 1, main: "sunny", description: "sunny", icon: "sun")],
                                                    clouds: ForecastClouds(all: 1), wind: ForecastWind(speed: 15, deg: 24),
                                                    sys: ForecastSys(pod: ""), dtTxt: "")])
        return forecastData
    }
}

class MockOfflineForecastRepository: WeatherOfflineRepository {
    var container: NSPersistentContainer!
    var shouldPass = false
    
    func setContainer(viewContainer: NSPersistentContainer) {
        container = viewContainer
    }
    
    // MARK: - Local database Current Weather
    override func fetchSavedOfflineWeather(completionHandler: @escaping WeatherOfflineFetchSavedResult) {
        let offlineWeather = try? container.viewContext.fetch(OfflineWeather.fetchRequest())
        guard let savedOfflineWeather = offlineWeather else { return }
        guard let savedWeather = savedOfflineWeather.last else { return }
        try? container.viewContext.save()
        
        if shouldPass {
            let mockData = savedWeather
            completionHandler(.success(mockData))
        } else {
            completionHandler(.failure(.retrievedOfflieWeatherSavedError))
        }
    }
    
    override func saveOfflineCurrentWeather(cityName: String,
                                            currentCondition: String,
                                            currentTemp: Double,
                                            maxTemp: Double,
                                            minTemp: Double,
                                            dateTime: String,
                                            completionHandler: @escaping SaveWeatherOfflineResults) {
        
        var localDatabse: OfflineWeather
        localDatabse = OfflineWeather(context: container.viewContext)
        localDatabse.cityName = cityName
        localDatabse.timeLastUpdated = dateTime
        localDatabse.currentCondition = currentCondition
        localDatabse.currentTemp = currentTemp
        localDatabse.maxTemp = maxTemp
        localDatabse.minTemp = minTemp
        try? container.viewContext.save()
        
        if shouldPass {
            fetchSavedOfflineWeather { _ in
                
            }
        } else {
            completionHandler(.failure(.retrievedOfflieWeatherSavedError))
        }
    }
    
    override func updateCurrentWeather(cityName: String,
                                       currentCondition: String,
                                       currentTemp: Double,
                                       maxTemp: Double,
                                       minTemp: Double,
                                       datetime: String) {
        
        var localDatabse: OfflineWeather
        localDatabse = OfflineWeather(context: container.viewContext)
        localDatabse.setValue(cityName, forKeyPath: "cityName")
        localDatabse.setValue(currentCondition, forKeyPath: "currentCondition")
        localDatabse.setValue(currentTemp, forKeyPath: "currentTemp")
        localDatabse.setValue(maxTemp, forKeyPath: "minTemp")
        localDatabse.setValue(minTemp, forKeyPath: "maxTemp")
        localDatabse.setValue(datetime, forKeyPath: "timeLastUpdated")
        try? container.viewContext.save()
    }
    
    func totalNumber(in context: NSManagedObjectContext) -> Int {
        let countRequest = try? context.count(for: OfflineWeather.fetchRequest())
        return countRequest ?? 0
    }
    
    func checkIfLocalDatabaseCurrentWeatherIsEmpty(in context: NSManagedObjectContext) -> Bool {
        var isCurrentWeatherDBEmpty = true
        guard let results = try? context.fetch(OfflineWeather.fetchRequest()) else { return  false}
        if results.isEmpty {
            isCurrentWeatherDBEmpty = true
        } else {
            isCurrentWeatherDBEmpty = false
        }
        return isCurrentWeatherDBEmpty
    }
    
    // MARK: - Local database Forecast Weather
    override func fetchFiveDayForecastWeather(completionHandler: @escaping WeatherOfflineForecastFetchSavedResult) {
        let offlineWeather = try? container.viewContext.fetch(OfflineFiveDayForecast.fetchRequest())
        guard let savedOfflineWeather = offlineWeather else { return }
        guard let savedWeather = savedOfflineWeather.last else { return }
        try? container.viewContext.save()
        
        if shouldPass {
            let mockData = savedWeather
            completionHandler(.success(mockData))
        } else {
            completionHandler(.failure(.retrievedOfflieWeatherSavedError))
        }
    }
    
    override func saveOfflineFiveDayForecastWeather(conditionDay1: String,
                                                    conditionDay2: String,
                                                    conditionDay3: String,
                                                    conditionDay4: String,
                                                    conditionDay5: String,
                                                    tempDay1: Double,
                                                    tempDay2: Double,
                                                    tempDay3: Double,
                                                    tempDay4: Double,
                                                    tempDay5: Double,
                                                    completionHandler: @escaping SaveWeatherOfflineForecastResults) {
        
        var localDatabse: OfflineFiveDayForecast
        localDatabse = OfflineFiveDayForecast(context: container.viewContext)
        localDatabse.condition1 = conditionDay1
        localDatabse.condition2 = conditionDay2
        localDatabse.condition3 = conditionDay3
        localDatabse.condition4 = conditionDay4
        localDatabse.condition5 = conditionDay5
        localDatabse.temperatureDay1 = tempDay1
        localDatabse.temperatureDay2 = tempDay2
        localDatabse.temperatureDay3 = tempDay3
        localDatabse.temperatureDay4 = tempDay4
        localDatabse.temperatureDay5 = tempDay5
        try? container.viewContext.save()
        
        if shouldPass {
            fetchSavedOfflineWeather { _ in
                
            }
        } else {
            completionHandler(.failure(.retrievedOfflieWeatherSavedError))
        }
    }
    
    override func updateForecastWeather(conditionDay1: String,
                                        conditionDay2: String,
                                        conditionDay3: String,
                                        conditionDay4: String,
                                        conditionDay5: String,
                                        tempDay1 : Double,
                                        tempDay2 : Double,
                                        tempDay3 : Double,
                                        tempDay4 : Double,
                                        tempDay5 : Double) {
        
        var localDatabse: OfflineFiveDayForecast
        localDatabse = OfflineFiveDayForecast(context: container.viewContext)
        localDatabse.setValue(conditionDay1, forKeyPath: "condition1")
        localDatabse.setValue(conditionDay2, forKeyPath: "condition2")
        localDatabse.setValue(conditionDay3, forKeyPath: "condition3")
        localDatabse.setValue(conditionDay4, forKeyPath: "condition4")
        localDatabse.setValue(conditionDay5, forKeyPath: "condition5")
        localDatabse.setValue(tempDay1, forKeyPath: "temperatureDay1")
        localDatabse.setValue(tempDay2, forKeyPath: "temperatureDay2")
        localDatabse.setValue(tempDay3, forKeyPath: "temperatureDay3")
        localDatabse.setValue(tempDay4, forKeyPath: "temperatureDay4")
        localDatabse.setValue(tempDay5, forKeyPath: "temperatureDay5")
        try? container.viewContext.save()
    }
    
    func totalNumberForecast(in context: NSManagedObjectContext) -> Int {
        let countRequest = try? context.count(for: OfflineFiveDayForecast.fetchRequest())
        return countRequest ?? 0
    }
    
    func checkIfLocalDatabaseForecastWeatherIsEmpty(in context: NSManagedObjectContext) -> Bool {
        var isCurrentWeatherDBEmpty = true
        guard let results = try? context.fetch(OfflineFiveDayForecast.fetchRequest()) else { return  false}
        if results.isEmpty {
            isCurrentWeatherDBEmpty = true
        } else {
            isCurrentWeatherDBEmpty = false
        }
        return isCurrentWeatherDBEmpty
    }
}
