//
//  ServiceErrors.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import Foundation

enum APIError: String, Error {
    case internalError
    case serverError
    case parsingError
}

enum LocalDatabaseError: String, Error {
    case retrievedCitySavedError
    case saveCityError
    case deleteCityError
    case serverError
    case internalApiError
}

enum LocalDatabaseOfflineError: String, Error {
    case retrievedOfflieWeatherSavedError
    case saveOfflieWeatherError
    case deleteOfflieWeatherError
}

enum HTTPMethod {
    case GET
    case POST
}
