//
//  WeatherTest.swift
//  WeatherAppTests
//
//  Created by Kirsty-Lee Walker on 2022/04/26.
//

import XCTest
import CoreLocation
@testable import WeatherApp

class WeatherTest: XCTestCase {

    private var weatherViewModel: CurrentWeatherViewModel!
    private var mockWeatherDelegate: MockWeatherDelegate!
    private var mockWeatherRepository: MockWeatherRepository!
    private var offlineWeatherRepository: MockOfflineRepository!

      override func setUp() {
          mockWeatherDelegate = MockWeatherDelegate()
          mockWeatherRepository = MockWeatherRepository()
          offlineWeatherRepository = MockOfflineRepository()
          weatherViewModel = CurrentWeatherViewModel(repository: mockWeatherRepository,
                                                     repositoryOffline: offlineWeatherRepository,
                                                     delegate: mockWeatherDelegate)
      }
    
    // MARK: - Current Weather Test
    func testWeatherDetailsCount_ReturnsIncorrectValue() {
        mockWeatherRepository.shouldPass = false
        weatherViewModel.fetchCurrentWeatherResults { _ in
        }
        XCTAssertNotEqual(self.weatherViewModel.objectCurrentWeather?.weather?.count, 1)
    }
    
    func testWeatherDetailsCount_ReturnsCorrectValue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.weather?.count, 1)
        }
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
        XCTAssertEqual(self.weatherViewModel.objectCurrentWeather?.main?.tempMax, 20)
    }
    }
        
    func testWeatherConditionMax_ReturnFalse() {
         mockWeatherRepository.shouldPass = false
         XCTAssertNotEqual(weatherViewModel.objectCurrentWeather?.main?.tempMax, 15)
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
    
    func testWeatherForecastCondition_ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectForecastWeather?.list[0].weather[0].main.lowercased(),"sunny")
        }

    }
    
    func testWeatherCondition_ReturnFalse() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectForecastWeather?.list[0].weather[0].main.lowercased(),"rainy")
    }
    
    func testWeatherTemperature_ReturnsTrue() {
        mockWeatherRepository.shouldPass = true
        weatherViewModel.fetchCurrentWeatherResults { _ in
            XCTAssertEqual(self.weatherViewModel.objectForecastWeather?.list[0].main.temp,15)
        }

    }
    
    func testWeatherTTemperature_ReturnFalse() {
        mockWeatherRepository.shouldPass = false
        XCTAssertNotEqual(weatherViewModel.objectForecastWeather?.list[0].main.temp,158)
    }
}

class MockWeatherDelegate: CurrentWeatherViewModelDelegate {
    func reloadView() {
        
    }
    
    func showError(error: String, message: String) {
        
    }
    
    func didUpdateWeather(weather: CurrentWeather) {
        
    }
    
    func didFailWithError(error: NSError?) {
        
    }
}

class MockWeatherRepository: SearchCurrentWeatherRepositoryType {
    
    var shouldPass = false
    func fetchSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CurrentWeatherResult)) {
        if shouldPass {
            let mockData = setMockData
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
    
    private var setMockData: CurrentWeather {
        var weathherData: CurrentWeather
        
        weathherData = CurrentWeather(coord: Coord(lon: 22.45, lat: 22.67),
                                     weather: [Weather(id: 1,
                                                       main: "sunny",
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
    
}
