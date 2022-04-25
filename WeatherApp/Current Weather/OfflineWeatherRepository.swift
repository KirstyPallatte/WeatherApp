//
//  OfflineWeatherRepository.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/25.
//

import Foundation
import CoreData

class WeatherOfflineRepository {

    // MARK: - Vars/Lets
    typealias WeatherOfflineFetchSavedResult = (Result<OfflineWeather, LocalDatabaseOfflineError>) -> Void
    typealias SaveWeatherOfflineResults = (Result<[OfflineWeather], LocalDatabaseOfflineError>) -> Void
    
    typealias WeatherOfflineForecastFetchSavedResult = (Result<OfflineFiveDayForecast, LocalDatabaseOfflineError>) -> Void
    typealias SaveWeatherOfflineForecastResults = (Result<[OfflineFiveDayForecast], LocalDatabaseOfflineError>) -> Void

    private var offlineWeather: [OfflineWeather]? = []
    private var fiveDayForecastWeather: [OfflineFiveDayForecast]? = []

    // MARK: - Local database Fetch Function
    func fetchSavedOfflineWeather(completionHandler: @escaping WeatherOfflineFetchSavedResult) {
        do {
            self.offlineWeather = try Constants.viewContext?.fetch(OfflineWeather.fetchRequest())
            guard let savedOfflineWeather = self.offlineWeather else { return }
            guard let savedWeather = savedOfflineWeather.last else { return }
            completionHandler(Result.success(savedWeather))
        } catch _ as NSError {
            completionHandler(Result.failure(.retrievedOfflieWeatherSavedError))
        }
    }
    
    func fetchFiveDayForecastWeather(completionHandler: @escaping WeatherOfflineForecastFetchSavedResult) {
        do {
            self.fiveDayForecastWeather = try Constants.viewContext?.fetch(OfflineFiveDayForecast.fetchRequest())
            guard let savedOfflineWeather = self.fiveDayForecastWeather else { return }
            guard let savedWeatherForecast = savedOfflineWeather.last else { return }
            completionHandler(Result.success(savedWeatherForecast))
        } catch _ as NSError {
            completionHandler(Result.failure(.retrievedOfflieWeatherSavedError))
        }
    }

    // MARK: - Local database Save Function
    func saveOfflineCurrentWeather(cityName: String,
                                   currentCondition: String,
                                   currentTemp: Double,
                                   maxTemp: Double,
                                   minTemp: Double,
                                   dateTime: String,
                                   completionHandler: @escaping SaveWeatherOfflineResults) {

        guard let weatherOfflineContext = Constants.viewContext else { return }
        let offlineWeatherObject = OfflineWeather(context: weatherOfflineContext)
        offlineWeatherObject.cityName = cityName
        offlineWeatherObject.currentCondition = currentCondition
        offlineWeatherObject.currentTemp = currentTemp
        offlineWeatherObject.minTemp = minTemp
        offlineWeatherObject.maxTemp = maxTemp
        offlineWeatherObject.timeLastUpdated = dateTime

        DispatchQueue.main.async {
        do {
            guard let offlineWeatherContext = Constants.viewContext,
                  let savedOfflineWeather = self.offlineWeather else { return }
            try offlineWeatherContext.save()
            completionHandler(Result.success(savedOfflineWeather))
        } catch _ as NSError {
            completionHandler(Result.failure(.saveOfflieWeatherError))
        }
        }
    }
    
    func saveOfflineFiveDayForecastWeather(conditionDay1: String,
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

        guard let offlineWeatherForecastContext = Constants.viewContext else { return }
        let offlineForecastWeatherObject = OfflineFiveDayForecast(context: offlineWeatherForecastContext)
        offlineForecastWeatherObject.condition1 = conditionDay1
        offlineForecastWeatherObject.condition2 = conditionDay2
        offlineForecastWeatherObject.condition3 = conditionDay3
        offlineForecastWeatherObject.condition4 = conditionDay4
        offlineForecastWeatherObject.condition5 = conditionDay5
        offlineForecastWeatherObject.temperatureDay1 = tempDay1
        offlineForecastWeatherObject.temperatureDay2 = tempDay2
        offlineForecastWeatherObject.temperatureDay3 = tempDay3
        offlineForecastWeatherObject.temperatureDay4 = tempDay4
        offlineForecastWeatherObject.temperatureDay5 = tempDay5

        DispatchQueue.main.async {
        do {
            guard let offlineWeatherContext = Constants.viewContext else { return }
            try offlineWeatherContext.save()
        } catch _ as NSError {
            print("Error")
        }
        }
    }

    // MARK: - Update Local Database
    func updateCurrentWeather(cityName: String,
                              currentCondition: String,
                              currentTemp: Double,
                              maxTemp: Double,
                              minTemp: Double,
                              datetime: String) {

    guard let weatherOfflineContext = Constants.viewContext else { return }
    let offlineWeatherObject = OfflineWeather(context: weatherOfflineContext)
        offlineWeatherObject.setValue(cityName, forKeyPath: "cityName")
        offlineWeatherObject.setValue(currentCondition, forKeyPath: "currentCondition")
        offlineWeatherObject.setValue(currentTemp, forKeyPath: "currentTemp")
        offlineWeatherObject.setValue(maxTemp, forKeyPath: "minTemp")
        offlineWeatherObject.setValue(minTemp, forKeyPath: "maxTemp")
        offlineWeatherObject.setValue(datetime, forKeyPath: "timeLastUpdated")
    DispatchQueue.main.async {
    do {
    try weatherOfflineContext.save()
    } catch _ as NSError {
       print("Error")
    }
    }
    }
    
    func updateForecastWeather(conditionDay1: String,
                               conditionDay2: String,
                               conditionDay3: String,
                               conditionDay4: String,
                               conditionDay5: String,
                               tempDay1: Double,
                               tempDay2: Double,
                               tempDay3: Double,
                               tempDay4: Double,
                               tempDay5: Double) {

    guard let weatherOfflineContext = Constants.viewContext else { return }
    let offlineWeatherObject = OfflineFiveDayForecast(context: weatherOfflineContext)
        offlineWeatherObject.setValue(conditionDay1, forKeyPath: "condition1")
        offlineWeatherObject.setValue(conditionDay2, forKeyPath: "condition2")
        offlineWeatherObject.setValue(conditionDay3, forKeyPath: "condition3")
        offlineWeatherObject.setValue(conditionDay4, forKeyPath: "condition4")
        offlineWeatherObject.setValue(conditionDay5, forKeyPath: "condition5")
        offlineWeatherObject.setValue(tempDay1, forKeyPath: "temperatureDay1")
        offlineWeatherObject.setValue(tempDay2, forKeyPath: "temperatureDay2")
        offlineWeatherObject.setValue(tempDay3, forKeyPath: "temperatureDay3")
        offlineWeatherObject.setValue(tempDay4, forKeyPath: "temperatureDay4")
        offlineWeatherObject.setValue(tempDay5, forKeyPath: "temperatureDay5")
        
        do {
        try weatherOfflineContext.save()
        } catch _ as NSError {
           print("Error")
        }
    }
    
    // MARK: - Empty Local database check
    
    func checkIfLocalDatabaseForecastWeatherIsEmpty() -> Bool {
       var isCurrentWeatherDBEmpty = true
       do {
           guard let results = try Constants.viewContext?.fetch(OfflineFiveDayForecast.fetchRequest()) else { return  false}
           if results.isEmpty {
               isCurrentWeatherDBEmpty = true
           } else {
               isCurrentWeatherDBEmpty = false
           }
       } catch {
           isCurrentWeatherDBEmpty = true
       }
       return isCurrentWeatherDBEmpty
   }
    
    func checkIfLocalDatabaseCurrentWeatherIsEmpty() -> Bool {
       var isCurrentWeatherDBEmpty = true
       do {
           guard let results = try Constants.viewContext?.fetch(OfflineWeather.fetchRequest()) else { return  false}
           if results.isEmpty {
               isCurrentWeatherDBEmpty = true
           } else {
               isCurrentWeatherDBEmpty = false
           }
       } catch {
           isCurrentWeatherDBEmpty = true
       }
       return isCurrentWeatherDBEmpty
   }
}
