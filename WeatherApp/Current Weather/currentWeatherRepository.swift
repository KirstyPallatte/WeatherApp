//
// CurrentWeatherRepository.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.

import Foundation
import CoreLocation

typealias CurrentWeatherResult = (Result<CurrentWeather, APIError>) -> Void
typealias FiveDayForecastResult = (Result<ForecastData, APIError>) -> Void

protocol SearchCurrentWeatherRepositoryType: AnyObject {
    func fetchSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping(CurrentWeatherResult))
    func fetchForecastSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (FiveDayForecastResult))
}

class CurrentWeatherRepository: SearchCurrentWeatherRepositoryType {
    func fetchSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (CurrentWeatherResult)) {
        let urlString = "\(Constants.weatherCurrentURl)&lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(Constants.APIKey)"
        request(endpoint: urlString, method: .GET, completion: completion)
    }
    
    private func request<T: Codable>(endpoint: String, method: HTTPMethod, completion: @escaping((Result<T, APIError>) -> Void)) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.internalError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        call(with: request, completion: completion)
    }
    
    private func call<T: Codable>(with request: URLRequest, completion: @escaping((Result<T, APIError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }
            do {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.serverError))
                    }
                    return
                }
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(.parsingError))
                }
            }
        }
        dataTask.resume()
    }
    
    func fetchForecastSearchResults(latitude: CLLocationDegrees, longitude: CLLocationDegrees, completion: @escaping (FiveDayForecastResult)) {
        let urlString = "\(Constants.weatherForecast5URl)&lat=\(latitude)&lon=\(longitude)&cnt=5&appid=\(Constants.APIKey)"
        requestForecast(endpoint: urlString, method: .GET, completion: completion)
    }
    
    private func requestForecast<T: Codable>(endpoint: String, method: HTTPMethod, completion: @escaping((Result<T, APIError>) -> Void)) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.internalError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        callForecast(with: request, completion: completion)
    }
    
    private func callForecast<T: Codable>(with request: URLRequest, completion: @escaping((Result<T, APIError>) -> Void)) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.serverError))
                }
                return
            }
            do {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(.serverError))
                    }
                    return
                }
                let object = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(Result.success(object))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(.parsingError))
                }
            }
        }
        dataTask.resume()
    }
}
