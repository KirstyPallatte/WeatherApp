//
//  FiveDayForecastRepository.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import Foundation

typealias FiveDayForecastResult = (Result<CurrentWeather, APIError>) -> Void

protocol SearchFiveDayFroecastRepositoryType: AnyObject {
    func fetchSearchResults(completion: @escaping(FiveDayForecastResult))
}

class FiveDayForecastRepository: SearchFiveDayFroecastRepositoryType {
    
    func fetchSearchResults(completion: @escaping (CurrentWeatherResult)) {
        request(endpoint: Constants.weatherCurrentURl, method: .GET, completion: completion)
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
}
