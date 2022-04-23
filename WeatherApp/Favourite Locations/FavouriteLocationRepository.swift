//
//  FavouriteLocationRepository.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/23.
//

import Foundation
import UIKit
import CoreData

class FavouriteLocationRepository {

    // MARK: - Vars/Lets
    typealias CityLocationFetchSavedResult = (Result<[Favourites], LocalDatabaseError>) -> Void
    typealias SaveCityLocationResults = (Result<[Favourites], LocalDatabaseError>) -> Void
    typealias DeleteCityLocationResults = (Result<[Favourites], LocalDatabaseError>) -> Void
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var favouriteCities: [Favourites]? = []

    // MARK: - Local database Fetch Function
    func fetchSavedCity(completionHandler: @escaping CityLocationFetchSavedResult) {
        DispatchQueue.main.async {
        do {
            self.favouriteCities = try self.context?.fetch(Favourites.fetchRequest())
            guard let savedCities = self.favouriteCities else { return }
            completionHandler(Result.success(savedCities))
        } catch _ as NSError {
            completionHandler(Result.failure(.retrievedCitySavedError))
        }
        }
    }

    // MARK: - Local database Save Function
    func saveCity(nameLocation: String, lattitudeCity: Double,longitudeCity: Double, completionHandler: @escaping SaveCityLocationResults) {

        guard let cityContext = self.context else { return }
        let favouriteObject = Favourites(context: cityContext)
        favouriteObject.locationName = nameLocation
        favouriteObject.longitude = longitudeCity
        favouriteObject.lattitude = lattitudeCity

        DispatchQueue.main.async {
        do {
            guard let cityContext = self.context,
                  let savedCity = self.favouriteCities else { return }
            try cityContext.save()
            completionHandler(Result.success(savedCity))
        } catch _ as NSError {
            completionHandler(Result.failure(.saveCityError))
        }
        }
    }

    // MARK: - Local database Delete Functions
    func deleteSavedPet(petToRemove: Favourites, completionHandler: @escaping DeleteCityLocationResults) {
        self.context?.delete(petToRemove)
        guard let savedCity = self.favouriteCities else { return }

        do {
            try self.context?.save()
            completionHandler(Result.success(savedCity))
        } catch _ as NSError {
            completionHandler(Result.failure(.deleteCityError))
        }
    }
}
