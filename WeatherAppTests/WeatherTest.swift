//
//  WeatherTest.swift
//  WeatherAppTests
//
//  Created by Kirsty-Lee Walker on 2022/04/26.
//
import XCTest
import CoreLocation
import CoreData
@testable import WeatherApp

class WeatherTest: XCTestCase {
    private var weatherViewModel: CurrentWeatherViewModel!
    private var mockWeatherDelegat: MockWeatherDelegate!
    private var mockWeatherRepository: MockWeatherRepository!
    private var offlineWeatherRepository: MockOfflineRepository!
    private var container: NSPersistentContainer!
    
    override func setUp() {
        mockWeatherDelegat = MockWeatherDelegate()
        mockWeatherRepository = MockWeatherRepository()
        offlineWeatherRepository = MockOfflineRepository()
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
    
    // MARK: - Current Weather Test
    func testWeatherDetailsCount_ReturnsIncorrectValue() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(self.weatherViewModel.objectCurrentWeather?.weather?.count, 1)
    }
    
    func testWeatherDetailsCount_ReturnsCorrectValue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.weather?.count, 1)
        }
    }
    
    func testWeatherWithIncorrectCoordinates_ReturnsIncorrectValue() {
        mockWeatherRepository.shouldPass = false
        mockWeatherRepository.fetchSearchResults(latitude: -29.4793, longitude:  25.727) { _ in
            XCTAssertNotEqual(self.weatherViewModel.objectCurrentWeather?.weather?[0].main, "rainy")
        }
    }
    
    func testWeatherWithCorrectCoordinates_ReturnsCorrectValue() {
        mockWeatherRepository.shouldPass = false
        weatherViewModel.fetchCurrentWeatherResults { _ in
            
        }
        mockWeatherRepository.fetchSearchResults(latitude: -28.4793, longitude:  24.6727) { _ in
            XCTAssertNotEqual(self.weatherViewModel.objectCurrentWeather?.weather?[0].main, "sunny")
        }
    }
    
    func testWeatherFavouriteCoordinates_ReturnsNotEqual() {
        mockWeatherRepository.shouldPass = false
        weatherViewModel.setFavLatLong(cityLattitude: -28.4793, cityLongitude: 24.6727)
        mockWeatherRepository.fetchSearchResults(latitude: -28.4793, longitude:  24.6727) { _ in
      
        }
        XCTAssertNotEqual(self.weatherViewModel.objectCurrentWeather?.weather?[0].main, "sunny")
    }
    
    func testWeatherFavouriteCoordinates_ReturnsEqual() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.setFavLatLong(cityLattitude: -28.4793, cityLongitude: 24.6727)
        weatherViewModel.fetchCurrentWeatherResults { _ in
            
        }
        XCTAssertEqual(weatherViewModel.objectCurrentWeather?.weather?[0].main, "sunny")
    }
    
    func testWeatherFavouriteCoordinates_ReturnsNil() {
        mockWeatherRepository.shouldPass = false
        weatherViewModel.setFavLatLong(cityLattitude: -28.4793, cityLongitude: 24.6727)
        weatherViewModel.fetchCurrentWeatherResults { _ in
            
        }
        XCTAssertNil(weatherViewModel.objectCurrentWeather?.weather?[0].main, "sunny")
    }
    
    func testTodaysTimestamp_ReturnsCorrectValue() {
        XCTAssertEqual(Date().todaysTimestamp(), weatherViewModel.lastUpdatedDateTime)
    }
    
    func testDateTime_ReturnsTrue() {
        XCTAssertEqual(weatherViewModel.lastUpdatedDateTime, Date().todaysTimestamp())
    }
    
    func testWeatherNameLocation_ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.name, "Cape Town")
        }
    }
    
    func testWeatherNameLocation_ReturnFalse() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectCurrentWeather?.name, "Cape Town")
    }
    
    func testWeatherNameLocation_ReturnsNotNil() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertNotNil(self.weatherViewModel.objectCurrentWeather)
        }
    }
    
    func testCurrentWeather_ReturnsNil() {
        XCTAssertNil(self.weatherViewModel.objectCurrentWeather)
    }

    func testWeatherMain_ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.main?.temp, 23)
        }
    }
    
    func testWeatherMain_ReturnFalse() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectCurrentWeather?.main?.temp, 20)
    }
    
    func testWeatherConditionMain_ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.weather?[0].main, "sunny")
        }
    }
    
    func testWeatherConditionMain_ReturnFalse() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectCurrentWeather?.weather?[0].main, "rainy")
    }
    
    func testWeatherTemperatureMin_ReturnFalse() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectCurrentWeather?.main?.tempMin, 15)
    }
    
    func testWeatherTemperatureMin_ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.main?.tempMin, 20)
        }
    }
    
    func testWeatherTemperatureMax_ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.main?.tempMax, 25)
        }
    }
    
    func testWeatherConditionMax_ReturnFalse() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectCurrentWeather?.main?.tempMax, 15)
    }
    
    func testReloadCalled_ReturnsFalse() {
        mockWeatherRepository.fetchSearchResults(latitude: 0, longitude:  0) { _ in
        }
        XCTAssertFalse(mockWeatherDelegat.reloadViewCalled)
    }
    
    func testReloadCalled__ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        XCTAssertTrue(self.mockWeatherDelegat.reloadViewCalled)
    }
    
    func testReloaddidFailWithError_ReturnsFalse() {
        let expectation = self.expectation(description: "Fetching")
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.fetchSearchResults(latitude: -29.4793, longitude:  25.727) { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertFalse(mockWeatherDelegat.didFailWeatherCalled)
    }

    func testWetaherObject_ReturnsNil() {
        let expectation = self.expectation(description: "Fetching")
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.fetchSearchResults(latitude: -28.4793, longitude:  24.6727) { _ in
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNil(weatherViewModel.objectCurrentWeather)
    }
    
    func testBackgroundImage_ReturnsEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.fetchSearchResults(latitude: -28.4793, longitude:  24.6727) { _ in
        }
        weatherViewModel.imagePressed(pressed: true)
        XCTAssertEqual(weatherViewModel.setBackgroundimage(), Constants.SEASUNNY)
    }
    
    func testBackgroundImage_ReturntEqual() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        weatherViewModel.imagePressed(pressed: false)
        XCTAssertEqual(weatherViewModel.setBackgroundimage(), Constants.FORESTSUNNY)
    }
    
    func testBackgroundImage_ReturntNotEqual() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        weatherViewModel.imagePressed(pressed: true)
        XCTAssertNotEqual(weatherViewModel.setBackgroundimage(), Constants.FORESTSUNNY)
    }
    
    func testBackgroundImageWithData_ReturntEqua() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.imagePressed(pressed: true)
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.setBackgroundimage(), Constants.SEASUNNY)
        }
    }
    
    func testBackgroundImageRainy_ReturntEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "rain"
        weatherViewModel.imagePressed(pressed: true)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertEqual(weatherViewModel.setBackgroundimage(), Constants.SEARAINY)
    }
    
    func testBackgroundImageRainy_ReturntNotEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "rain"
        weatherViewModel.imagePressed(pressed: false)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertNotEqual(weatherViewModel.setBackgroundimage(), Constants.SEARAINY)
    }
    
    func testBackgroundImageClear_ReturntEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "clear"
        weatherViewModel.imagePressed(pressed: true)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertEqual(weatherViewModel.setBackgroundimage(), Constants.SEASUNNY)
    }
    
    func testBackgroundImageClear_ReturntNotEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "clear"
        weatherViewModel.imagePressed(pressed: false)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertNotEqual(weatherViewModel.setBackgroundimage(), Constants.SEASUNNY)
    }
    
    func testBackgroundImageCloudy_ReturntEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "clouds"
        weatherViewModel.imagePressed(pressed: true)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertEqual(weatherViewModel.setBackgroundimage(), Constants.SEACLOUDY)
    }
    
    func testBackgroundImageCloudy_ReturntNotEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "clouds"
        weatherViewModel.imagePressed(pressed: false)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertNotEqual(weatherViewModel.setBackgroundimage(), Constants.SEACLOUDY)
    }
    
    func testBackgroundImageNone_ReturntEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "none"
        weatherViewModel.imagePressed(pressed: true)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertEqual(weatherViewModel.setBackgroundimage(), Constants.SEASUNNY)
    }
    
    func testBackgroundImageNone_ReturntNotEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "none"
        weatherViewModel.imagePressed(pressed: false)
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertNotEqual(weatherViewModel.setBackgroundimage(), Constants.SEASUNNY)
    }
    
    func testBackgroundButtonPressedNotSet_ReturntNotEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "none"
        weatherViewModel.fetchCurrentWeatherResults { _ in
 
        }
        XCTAssertNotEqual(weatherViewModel.setBackgroundimage(), Constants.SEASUNNY)
    }
    
    func testPhoneOffline_ReturnsFalse() {
        XCTAssertFalse(weatherViewModel.isPhoneOffline)
    }
    
    // MARK: - Forecast Weather Test
    func testWeatherForecastDetailsCount_ReturnsIncorrectValue() {
        mockWeatherRepository.shouldPass = false
        weatherViewModel.fetchForecastCurrentWeatherResults { _ in
        }
        XCTAssertNotEqual(self.weatherViewModel.objectForecastWeather?.list.count, 1)
    }
    
    func testWeatherForecastDetailsCount_ReturnsCorrectValue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchForecastCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectForecastWeather?.list.count, 1)
        }
    }
    
    func testForecastWithIncorrectCoordinates_ReturnsIncorrectValue() {
        mockWeatherRepository.shouldPass = false
        mockWeatherRepository.fetchForecastSearchResults(latitude: -29.4793, longitude:  25.727) { _ in
            XCTAssertNotEqual(self.weatherViewModel.objectForecastWeather?.list[0].weather[0].main.lowercased(), "rainy")
        }
    }
    
    func testWeatherWiCoordinates_ReturnsIncorrectValue() {
        mockWeatherRepository.shouldPass = false
        mockWeatherRepository.fetchForecastSearchResults(latitude: -29.4793, longitude:  25.727) { _ in
            XCTAssertNotEqual(self.weatherViewModel.objectForecastWeather?.list[0].weather[0].main, "sunny")
        }
    }
    
    func testWeatherForecastCondition_ReturnsNotEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.fetchForecastSearchResults(latitude: -28.4793, longitude:  24.6727) { _ in
            XCTAssertNotEqual(self.weatherViewModel.objectForecastWeather?.list[0].weather[0].main.lowercased(), "sunny")
        }
    }
    
    func testWeatherCondition_ReturnNotEqual() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(self.weatherViewModel.objectForecastWeather?.list[0].weather[0].main.lowercased(), "rainy")
    }
    
    func testWeatherTemperature_ReturnsNotEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.fetchForecastSearchResults(latitude: -28.4793, longitude:  24.6727) { _ in
            XCTAssertNotEqual(self.weatherViewModel.objectForecastWeather?.list[0].main.temp, 15)
        }
    }
    
    func testForecastFavouriteCoordinates_ReturnsEqual() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.setFavLatLong(cityLattitude: -28.4793, cityLongitude: 24.6727)
        weatherViewModel.fetchForecastCurrentWeatherResults { _ in
            
        }
        XCTAssertEqual(weatherViewModel.objectForecastWeather?.list[0].main.temp, 15)
    }
    
    func testForecastFavouriteCoordinates_ReturnsNil() {
        mockWeatherRepository.shouldPass = false
        weatherViewModel.setFavLatLong(cityLattitude: -28.4793, cityLongitude: 24.6727)
        weatherViewModel.fetchForecastCurrentWeatherResults { _ in
            
        }
        XCTAssertNil(weatherViewModel.objectCurrentWeather?.weather?[0].main, "sunny")
    }
    
    func testWeatherTemperature_ReturnNotEqual() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectForecastWeather?.list[0].main.temp,158)
    }
    
    func testIsPressed_ReturnsEqual() {
        XCTAssertEqual(weatherViewModel.isPressed, false)
    }
    
    func testIsPressed_ReturnsNotEqual() {
        XCTAssertNotEqual(weatherViewModel.isPressed, true)
    }
}

class MockWeatherDelegate: CurrentWeatherViewModelDelegate {
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

class MockWeatherRepository: SearchCurrentWeatherRepositoryType {
    var shouldPass = false
    var weatherCondition = ""
    func fetchSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CurrentWeatherResult)) {
        if shouldPass {
            if weatherCondition == "" {
                weatherCondition = "sunny"
            }
            let mockData = setMockData(weatherConditions: weatherCondition)
            completion(.success(mockData))
        } else {
            completion(.failure(.serverError))
        }
    }
    
    func fetchForecastSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (FiveDayForecastResult)) {
        if shouldPass {
            let mockData = setForecastMockData
            completion(.success(mockData))
        } else {
            completion(.failure(.serverError))
        }
    }
    
    func setMockData(weatherConditions: String) -> CurrentWeather {
        var weathherData: CurrentWeather
      
        weathherData = CurrentWeather(coord: Coord(lon: 24.6727, lat: -28.4793),
                                      weather: [Weather(id: 1,
                                      main: weatherCondition,
                                      description: "sunny with clouds", icon: "sunny")],
                                      main: Main(temp: 23, feelsLike: 25, tempMin: 20, tempMax: 25, pressure: 20, humidity: 50),
                                      base: "", visibility: 100, wind: Wind(speed: 25, deg: 28),
                                      clouds: Clouds(all: 1), dt: 30, sys: SunType(type: 2, id: 3,
                                      country: "South Africa", sunrise: 6, sunset: 6), timezone: 20, id: 1,
                                      name: "Cape Town", cod: 1)
        return weathherData
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

class MockOfflineRepository: WeatherOfflineRepository {
    var container: NSPersistentContainer!
    var shouldPass = false
    
    func setContainer(viewContainer: NSPersistentContainer) {
        container = viewContainer
    }
}
