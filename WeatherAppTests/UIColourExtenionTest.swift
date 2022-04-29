//
//  UIColourExtenion.swift
//  WeatherAppTests
//
//  Created by Kirsty-Lee Walker on 2022/04/29.
//

import XCTest
import CoreData
import CoreLocation
import UIKit
@testable import WeatherApp

class UIColourExtenionTest: XCTestCase {

    private var weatherViewModel: CurrentWeatherViewModel!
    private var mockWeatherDelegat: MockWeatherDelegate!
    private var mockWeatherRepository: MockWeatherRepository!
    private var offlineWeatherRepository: MockOfflineRepository!
    private var viewController: CurrentWeatherViewController!
    
    override func setUp() {
        mockWeatherDelegat = MockWeatherDelegate()
        viewController = CurrentWeatherViewController()
        mockWeatherRepository = MockWeatherRepository()
        offlineWeatherRepository = MockOfflineRepository()
        weatherViewModel = CurrentWeatherViewModel(repository: mockWeatherRepository,
                                                   repositoryOffline: offlineWeatherRepository,
                                                   delegate: mockWeatherDelegat)
    }

    func testColourSun_ReturnEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "sunny"
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        
        XCTAssertNotNil(viewController.setBackgroundColoursCurrentWeather())
    }
    
    func testColourClear_ReturnEqual() {
        mockWeatherRepository.shouldPass = true
        mockWeatherRepository.weatherCondition = "clear"
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        XCTAssertNotNil(viewController.setBackgroundColoursCurrentWeather())
    }
    
    func testColourRain_ReturnEqual() {
        mockWeatherRepository.weatherCondition = "rain"
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        XCTAssertNotNil(viewController.setBackgroundColoursCurrentWeather())
    }
    
    
    func testColourCloud_ReturnEqual() {
        mockWeatherRepository.weatherCondition = "clouds"
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        XCTAssertNotNil(viewController.setBackgroundColoursCurrentWeather())
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
}

