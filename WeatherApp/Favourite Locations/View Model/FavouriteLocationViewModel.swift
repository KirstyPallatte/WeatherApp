//
//  FavouriteLocationViewModel.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/23.
//

import Foundation
import UIKit

// MARK: - cityLocalDatabaseViewModel Delegate
protocol CityLocalDatabaseViewModelDelegate: AnyObject {
    func reloadView()
    func showError(errorTitle: String, errorMessage: String, action: LocalDatabaseError)
    func refreshCity()
}

class FavouriteLocationViewModel {
    
    // MARK: - Vars/Lets
    private var cityLocalDatabaseRepository: FavouriteLocationRepository?
    private weak var delegate: CityLocalDatabaseViewModelDelegate?
    private var favouriteCities: [Favourites]? = []
    private var cityLocationName = ""
    private var cityLattitude = 0.00
    private var cityLongitude = 0.00
    private var isDeleteSucess = false
    private var singleCityName: String?
    private var singleCityLattitude: Double?
    private var singleCityLongitude: Double?
    private var singleCityImage: String?

    // MARK: - Constructor
    init(repository: FavouriteLocationRepository,
         delegate: CityLocalDatabaseViewModelDelegate) {
        self.cityLocalDatabaseRepository = repository
        self.delegate = delegate
    }
    
    func setSingleCityObject(cityName: String, lattitude: Double, longitude: Double, image: String) {
        singleCityName = cityName
        singleCityLattitude = lattitude
        singleCityLongitude = longitude
        singleCityImage = image
    }
    
    func set(isCityDeleteSuccess: Bool) {
        isDeleteSucess = isCityDeleteSuccess
    }
    
    // MARK: - Tableview data
    var citySavedCount: Int {
        return favouriteCities?.count ?? 0
    }
    
    var nameSingleCity: String? {
        return singleCityName
    }

    var lattitudeSingleCity: Double? {
        return singleCityLattitude
    }
    
    var longitudeSingleCity: Double? {
        return singleCityLongitude
    }
    
    var imageSingleCity: String? {
        return singleCityImage
    }

    var isCitySucessDeleted: Bool {
        return isDeleteSucess
    }

    func savedCity(at index: Int) -> Favourites? {
        return favouriteCities?[index]
    }
    
    func favouriteCitySaved() -> [Favourites?] {
        let favourite: [Favourites] = []
        guard favouriteCities != nil else { return favourite }
        return favourite
    }

    func cityLocationNameSaved(city: Favourites) -> String {
        return city.value(forKeyPath: "locationName") as? String ?? ""
    }

    func cityLattitudeSaved(city: Favourites) -> Double {
        return city.value(forKeyPath: "lattitude") as? Double ?? 0.00
    }
    
    func cityLongitudeSaved(city: Favourites) -> Double {
        return city.value(forKeyPath: "longitude") as? Double ?? 0.00
    }
    
    // MARK: - Local Database function fetch
    func fetchCityDataResults() {
        cityLocalDatabaseRepository?.fetchSavedCity { [weak self] savedCity in
            switch savedCity {
            case .success(let savedCityData):
                self?.favouriteCities = savedCityData
                self?.delegate?.reloadView()
            case .failure:
                self?.delegate?.showError(errorTitle: "Unable to retreive all your saved cities",
                                          errorMessage: "There was a problem retrieving your cities",
                                          action: .retrievedCitySavedError)
            }
        }
    }

    // MARK: - Local Database function save
    func saveCityInLocalDatabase(nameCity: String, lattitude: Double, longitude: Double) {
        cityLocalDatabaseRepository?.saveCity(nameLocation: nameCity, lattitudeCity: lattitude, longitudeCity: longitude) { [weak self] savedCity in
            switch savedCity {
            case .success:
                self?.delegate?.reloadView()
            case .failure:
                self?.delegate?.showError(errorTitle: "Unable to save \(nameCity)",
                                          errorMessage: "There was a problem savings",
                                          action: .saveCityError)
            }
            self?.fetchCityDataResults()
        }
    }

    // MARK: - Local Database function delete
    func deleteCityLocaldatabase(cityToRemove: Favourites) {
        guard let cityDeleteName = cityToRemove.locationName else { return }
        cityLocalDatabaseRepository?.deleteSavedCity(locationToRemove: cityToRemove) { [weak self] savedCity in
            switch savedCity {
            case .success:
                self?.delegate?.refreshCity()
            case .failure:
                self?.delegate?.showError(errorTitle: "Unable to delete \(cityDeleteName)?",
                                           errorMessage: "There was a problem deleting \(cityDeleteName)",
                                           action: .deleteCityError)
            }
        }
    }
}
