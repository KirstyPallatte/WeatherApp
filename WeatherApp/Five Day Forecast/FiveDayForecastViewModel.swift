//
//  FiveDayForecastViewModel.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import Foundation

// MARK: - CurrentWeatherViewModel Delegate
protocol FiveDayForecastViewModelDelegate: AnyObject {
    func reloadView()
    func showError(error: String, message: String)
}

class FiveDayForecastViewModel {
    // MARK: - Vars/Lets
    private var forcastRepository: SearchFiveDayFroecastRepositoryType?
    private weak var delegate: FiveDayForecastViewModelDelegate?
    private var fiveDayForecastObject: CurrentWeather?
    
    // MARK: - Constructor
    init(repository: SearchFiveDayFroecastRepositoryType,
         delegate: FiveDayForecastViewModelDelegate) {
         self.forcastRepository = repository
         self.delegate = delegate
    }
    
    // MARK: - Functions
    func fetchCurrentWeatherResults() {
        forcastRepository?.fetchSearchResults(completion: { [weak self] result in
                switch result {
                case .success(let weatherData):
                    self?.fiveDayForecastObject = weatherData
                    print(weatherData)
                    self?.delegate?.reloadView()
                case .failure(let error):
                    self?.delegate?.showError(error: error.rawValue, message: "Could not retrieve the forecast.")
                }
        })
    }
}
