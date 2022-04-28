//
//  FavouriteListTest.swift
//  WeatherAppTests
//
//  Created by Kirsty-Lee Walker on 2022/04/27.
//

import XCTest
import CoreData
@testable import WeatherApp

struct CityObject {
    var cityName: String
    var lattitude: Double
    var longitude: Double
    var image: String
}

class FavouriteListTest: XCTestCase {
    private var favouriteViewModel: FavouriteLocationViewModel!
    private var mockFavouriteCitySearchrDelegat: MockLocalDatabaseViewModelDelegate!
    private var mockFavouriteCityRepository: MockFavouriteCityRepository!
    private var container: NSPersistentContainer!
    
    override func setUp() {
        mockFavouriteCitySearchrDelegat = MockLocalDatabaseViewModelDelegate()
        mockFavouriteCityRepository = MockFavouriteCityRepository()
        favouriteViewModel = FavouriteLocationViewModel(repository: mockFavouriteCityRepository,
                                                        delegate: mockFavouriteCitySearchrDelegat)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        container = NSPersistentContainer(name: "WeatherApp")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    // MARK: - Local database Favourites
    
    func testSearchCityCount_ReturnsEqual() {
        mockFavouriteCityRepository.shouldPass = true
        let expectedCount = 1
        var localFavouriteDatabse: Favourites
        localFavouriteDatabse = Favourites(context: container.viewContext)
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        localFavouriteDatabse.locationName = "Johburg"
        localFavouriteDatabse.lattitude = 20.55
        localFavouriteDatabse.longitude = 30.65
        favouriteViewModel.fetchCityDataResults()
        XCTAssertEqual(favouriteViewModel.citySavedCount, expectedCount)
    }
    
    func testSearchCityCount_ReturnsNotEqual() {
        let expectedCount = 1
        var localFavouriteDatabse: Favourites
        localFavouriteDatabse = Favourites(context: container.viewContext)
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        localFavouriteDatabse.locationName = "Johburg"
        localFavouriteDatabse.lattitude = 20.55
        localFavouriteDatabse.longitude = 30.65
        favouriteViewModel.fetchCityDataResults()
        XCTAssertNotEqual(favouriteViewModel.citySavedCount, expectedCount)
    }
    
    func testErrorCalled_ReturnsTrue() {
        var localFavouriteDatabse: Favourites
        localFavouriteDatabse = Favourites(context: container.viewContext)
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        localFavouriteDatabse.locationName = "Johburg"
        localFavouriteDatabse.lattitude = 20.55
        localFavouriteDatabse.longitude = 30.65
        favouriteViewModel.fetchCityDataResults()
        XCTAssertTrue(mockFavouriteCitySearchrDelegat.errorCalled)
    }
    
    func testSettingCityName_ReturnsEqual() {
        mockFavouriteCityRepository.shouldPass = true
         guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
         let cityName = cityData.cityName
         let lattitude = cityData.lattitude
         let longitude = cityData.longitude
         let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.nameSingleCity, "Cape Town")
    }
    
    func testSettingCityNameEmpty_ReturnsEqual() {
        guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
        let cityName = cityData.cityName
        let lattitude = cityData.lattitude
        let longitude = cityData.longitude
        let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.nameSingleCity, "")
    }
    
    func testSettingLattitude_ReturnsEqual() {
        mockFavouriteCityRepository.shouldPass = true
        guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
        let cityName = cityData.cityName
        let lattitude = cityData.lattitude
        let longitude = cityData.longitude
        let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.lattitudeSingleCity, 25.00)
    }
    
    func testSettingLattiudeEmpty_ReturnsNotEqual() {
        guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
        let cityName = cityData.cityName
        let lattitude = cityData.lattitude
        let longitude = cityData.longitude
        let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.lattitudeSingleCity, 0.00)
    }
    
    func testSettingLongitude_ReturnsEqual() {
        mockFavouriteCityRepository.shouldPass = true
        guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
        let cityName = cityData.cityName
        let lattitude = cityData.lattitude
        let longitude = cityData.longitude
        let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.longitudeSingleCity, 23.66)
    }
    
    func testSettingLongitudeEmpty_ReturnsNotEqual() {
        guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
        let cityName = cityData.cityName
        let lattitude = cityData.lattitude
        let longitude = cityData.longitude
        let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.longitudeSingleCity, 0.00)
    }
    
    func testSettingImage_ReturnsEqual() {
        mockFavouriteCityRepository.shouldPass = true
        guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
        let cityName = cityData.cityName
        let lattitude = cityData.lattitude
        let longitude = cityData.longitude
        let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.imageSingleCity, "link")
    }
    
    func testSettingImageEmpty_ReturnsNotEqual() {
        guard let cityData = mockFavouriteCityRepository.setFavouriteCity() else { return }
        let cityName = cityData.cityName
        let lattitude = cityData.lattitude
        let longitude = cityData.longitude
        let image = cityData.image
        favouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
        XCTAssertEqual(favouriteViewModel.imageSingleCity, "")
    }
    
    func testSuccessDeleted() {
       favouriteViewModel.set(isCityDeleteSuccess: true)
        XCTAssertTrue(favouriteViewModel.isCitySucessDeleted)
    }
    
    func testSearchCityAtIndex_ReturnsEqual() {
        mockFavouriteCityRepository.shouldPass = true
        var localFavouriteDatabse: Favourites
        localFavouriteDatabse = Favourites(context: container.viewContext)
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        localFavouriteDatabse.locationName = "Johburg"
        localFavouriteDatabse.lattitude = 20.55
        localFavouriteDatabse.longitude = 30.65
        favouriteViewModel.fetchCityDataResults()
        XCTAssertEqual(favouriteViewModel.savedCity(at: 0)?.locationName, "Johburg")
    }
    
    func testReloadViewCalled_ReturnsTrue() {
        mockFavouriteCityRepository.shouldPass = true
        var localFavouriteDatabse: Favourites
        localFavouriteDatabse = Favourites(context: container.viewContext)
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        localFavouriteDatabse.locationName = "Johburg"
        localFavouriteDatabse.lattitude = 20.55
        localFavouriteDatabse.longitude = 30.65
        favouriteViewModel.fetchCityDataResults()
        XCTAssertTrue(mockFavouriteCitySearchrDelegat.reloadViewCalled)
    }
    
    func testErroralled_ReturnsTrue() {
        var localFavouriteDatabse: Favourites
        localFavouriteDatabse = Favourites(context: container.viewContext)
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        localFavouriteDatabse.locationName = "Johburg"
        localFavouriteDatabse.lattitude = 20.55
        localFavouriteDatabse.longitude = 30.65
        favouriteViewModel.fetchCityDataResults()
        XCTAssertTrue(mockFavouriteCitySearchrDelegat.errorCalled)
    }
    
    func testFavouritesrSaved_ReturnsNotNil() {
        mockFavouriteCityRepository.shouldPass = true
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        XCTAssertNotNil(favouriteViewModel.savedCity(at: 0))
    }
    
    func testFavouritesrSaved_ReturnsTrue() {
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        XCTAssertTrue(mockFavouriteCitySearchrDelegat.errorCalled)
    }
    
    func testFavouriteLocationSaved_ReturnsNotNil() {
        mockFavouriteCityRepository.shouldPass = true
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        guard let city = favouriteViewModel.savedCity(at: 0) else { return }
        XCTAssertNotNil(favouriteViewModel.cityLocationNameSaved(city: city))
    }
    
    func testFavouriteLocationSaved_ReturnsTrue() {
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        XCTAssertTrue(mockFavouriteCitySearchrDelegat.errorCalled)
    }
    
    func testFavoruiteLattitudeSaved_ReturnsNotNil() {
        mockFavouriteCityRepository.shouldPass = true
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        guard let city = favouriteViewModel.savedCity(at: 0) else { return }
        XCTAssertNotNil(favouriteViewModel.cityLattitudeSaved(city: city))
    }
    
    func testFavoruiteLattitudeSaved_ReturnsTrue() {
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        XCTAssertTrue(mockFavouriteCitySearchrDelegat.errorCalled)
    }
    
    func testFavoruiteLongitdeSaved_ReturnsNotNil() {
        mockFavouriteCityRepository.shouldPass = true
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        guard let city = favouriteViewModel.savedCity(at: 0) else { return }
        XCTAssertNotNil(favouriteViewModel.cityLongitudeSaved(city: city))
    }
    
    func testFavoruiteLongitdeSaved_ReturnsTrue() {
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        XCTAssertTrue(mockFavouriteCitySearchrDelegat.errorCalled)
    }
    
    func testFavoruiteSaved_ReturnsNotNil() {
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        XCTAssertNotNil(favouriteViewModel.favouriteCitySaved)
    }
    
    func testFavoruiteLocationDelete_ReturnsNotNil() {
        mockFavouriteCityRepository.shouldPass = true
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        guard let city = favouriteViewModel.savedCity(at: 0) else { return }
        mockFavouriteCityRepository.deleteSavedCity(locationToRemove: city) { _ in
            
        }
        favouriteViewModel.fetchCityDataResults()
        XCTAssertEqual(favouriteViewModel.citySavedCount, 0)
    }
    
    func testFavoruiteRefreshCity_ReturnsTrue() {
        mockFavouriteCityRepository.shouldPass = true
        mockFavouriteCityRepository.shouldDelete = true
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        guard let city = favouriteViewModel.savedCity(at: 0) else { return }
        favouriteViewModel.deleteCityLocaldatabase(cityToRemove: city)
        XCTAssertTrue(self.mockFavouriteCitySearchrDelegat.refrshCalled) 
    }
    
    func testFavoruiteErrorCalled_ReturnsTrue() {
        mockFavouriteCityRepository.shouldPass = true
        mockFavouriteCityRepository.shouldDelete = false
        mockFavouriteCityRepository.setContainer(viewContainer: container)
        favouriteViewModel.saveCityInLocalDatabase(nameCity: "Johburg", lattitude: 90.00, longitude: 20.45)
        favouriteViewModel.fetchCityDataResults()
        guard let city = favouriteViewModel.savedCity(at: 0) else { return }
        favouriteViewModel.deleteCityLocaldatabase(cityToRemove: city)
        XCTAssertTrue(self.mockFavouriteCitySearchrDelegat.errorCalled)
    }
}

class MockLocalDatabaseViewModelDelegate: CityLocalDatabaseViewModelDelegate {
    var reloadViewCalled = false
    var errorCalled = false
    var refrshCalled = false
    
    func reloadView() {
        reloadViewCalled = true
    }
    
    func showError(errorTitle: String, errorMessage: String, action: LocalDatabaseError) {
        errorCalled = true
    }
    
    func refreshCity() {
        refrshCalled = true
    }

}

class MockFavouriteCityRepository: FavouriteLocationRepository {
    var container: NSPersistentContainer!
    var shouldPass = false
    var shouldDelete = false
    func setContainer(viewContainer: NSPersistentContainer) {
        container = viewContainer
    }
    
    // MARK: - Local database Favourites
    override func fetchSavedCity(completionHandler: @escaping CityLocationFetchSavedResult) {
        var favouriteLocation: [Favourites]? = []
        favouriteLocation = try? container.viewContext.fetch(Favourites.fetchRequest())
        guard let locationFavouriteSaved = favouriteLocation else { return }
        let savedCities = locationFavouriteSaved
        
        let favouriteCities: [Favourites] = savedCities
        
        try? container.viewContext.save()
    
        if shouldPass {
            completionHandler(.success(favouriteCities))
        } else {
            completionHandler(.failure(.retrievedCitySavedError))
        }
    }
    
    override func saveCity(nameLocation: String,
                           lattitudeCity: Double,
                           longitudeCity: Double,
                           completionHandler: @escaping SaveCityLocationResults) {
        
        var localDatabseFavourites: [Favourites]
        localDatabseFavourites = [Favourites(context: container.viewContext)]
        localDatabseFavourites[0].locationName = nameLocation
        localDatabseFavourites[0].lattitude = lattitudeCity
        localDatabseFavourites[0].longitude = longitudeCity
        try? container.viewContext.save()
        
        if shouldPass {
            fetchSavedCity { _ in
                completionHandler(.success(localDatabseFavourites))
            }
        } else {
            completionHandler(.failure(.retrievedCitySavedError))
        }
    }
    
    override func deleteSavedCity(locationToRemove: Favourites,
                                  completionHandler: @escaping DeleteCityLocationResults) {
            container.viewContext.delete(locationToRemove)
            do {
                if shouldDelete {
                try self.container.viewContext.save()
                completionHandler(Result.success(locationToRemove))
                } else {
                    completionHandler(Result.failure(.deleteCityError))
                }
            } catch _ as NSError {
                completionHandler(Result.failure(.deleteCityError))
            }
        }

    func setFavouriteCity() -> CityObject? {
        var city = CityObject(cityName: "", lattitude: 0.00, longitude:0.00, image: "")
        if shouldPass {
            city = CityObject(cityName: "Cape Town", lattitude: 25.00, longitude: 23.66, image: "link")
        }
        return city
    }
}
