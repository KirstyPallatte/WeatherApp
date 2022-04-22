//
//  CityRepository.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/22.
//

import Foundation
typealias CityDataResult = (Result<CityData, APIError>) -> Void

protocol SearchCityRepositoryType: AnyObject {
    func fetchCityDataResults(completion: @escaping(CityDataResult))
}

class CityRepository: SearchCityRepositoryType {
    func fetchCityDataResults(completion: @escaping (CityDataResult)) {
        let urlString = Constants.cityURL
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
                    print("Sucess")
                }
            } catch {
                DispatchQueue.main.async {
                    completion(Result.failure(.parsingError))
                    print(error)
                }
            }
        }
        dataTask.resume()
    }

}
