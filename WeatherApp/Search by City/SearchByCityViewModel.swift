//
//  SearchByCityViewModel.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/22.
//

import Foundation

// MARK: - searchCityViewModel Delegate
protocol searchCityViewModelDelegate: AnyObject {
    func reloadView()
    func showError(error: String, message: String)
}

class SearchCityViewModel {
    // MARK: - Vars/Lets
    private var searchCityRepository: SearchCityRepositoryType?
    private weak var delegate: searchCityViewModelDelegate?
    private var cityList: CityData?
    private var cityFilteredList: CityData?
    
    // MARK: - Constructor
    init(repository: SearchCityRepositoryType,
         delegate: searchCityViewModelDelegate) {
         self.searchCityRepository = repository
         self.delegate = delegate
    }
    
    func fetchCityResults() {
        searchCityRepository?.fetchCityDataResults { [weak self] result in
            switch result {
            case .success(let cityData):
                self?.cityList = cityData
                self?.delegate?.reloadView()
            case .failure(let error):
                self?.delegate?.showError(error: error.rawValue, message: "Cannot get a list of cities")
            }
    }
}
    
    var cityCount: Int {
        return cityList?.name.count ?? 0
    }
    
    var filteredCityCount: Int {
        return cityFilteredList?.count ?? 0
    }
    
    var listCity: CityData? {
        return cityList
    }
    
    var arrCity: [CityData]? {
        return cityList
    }
    
    var filteredCity: [CityData? {
        return cityFilteredList
    }
    
    func search(searchText: String) {
        cityFilteredList = listCity.name.lowercased().contains(searchText.lowercased())}))
    }
}
