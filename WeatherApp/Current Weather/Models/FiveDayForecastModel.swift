//
//  FiveDayForecastModel.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import Foundation

struct ForecastData: Codable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ListItem]
}

// MARK: Forecast List
struct ListItem: Codable {
    let dt: Double
    let main: ForecastMain
    let weather: [ForecastWeather]
    let clouds: ForecastClouds
    let wind: ForecastWind
    let sys: ForecastSys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: Forecast Main
struct ForecastMain: Codable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Double
    let seaLevel: Double
    let grndLevel: Double
    let humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: Forecast ForecastSys
struct ForecastSys: Codable {
    let pod: String
}

// MARK: Forecast Weather
struct ForecastWeather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: Forecast - Wind
struct ForecastWind: Codable {
    let speed: Double
    let deg: Double?
}

// MARK: Forecst - Clouds
struct ForecastClouds: Codable {
    let all: Int
}
