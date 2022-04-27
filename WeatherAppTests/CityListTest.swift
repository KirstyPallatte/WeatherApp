//
//  CityListTest.swift
//  CityListTest
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import XCTest
@testable import WeatherApp

class CityListTest: XCTestCase {

    private var cityViewModel: SearchCityViewModel!
    private var mockCityDelegate: MockCityListDelegate!
    private var mockCityRepository: MockCityListDataRepository!

      override func setUp() {
          mockCityDelegate = MockCityListDelegate()
          mockCityRepository = MockCityListDataRepository()
          cityViewModel = SearchCityViewModel(repository: mockCityRepository,
                                              delegate: mockCityDelegate)
      }
    
    // MARK: - Tableview data
     func testAllCityDetailsCount_ReturnsIncorrectValue() {
         mockCityRepository.shouldPass = false
         XCTAssertEqual(cityViewModel.cityCount, 0)
     }
    
    func testAllCityDetailsCount_ReturnsCorrectValue() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        XCTAssertEqual(cityViewModel.cityCount, 1)
    }
    
    func testCityObject_ReturnsNil() {
        cityViewModel.fetchCityResults()
        XCTAssertNil(cityViewModel.arrCity)
    }

    func testCityObject_ReturnsNotNill() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        XCTAssertNotNil(cityViewModel.arrCity)
    }
    
    func testSearchPetBySpecificCityName_ReturnsNotEqual() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        cityViewModel.search(searchText: "Cape Town")
        XCTAssertEqual(cityViewModel.filteredCity?.count,0)
    }
    
    func testSearchPetBySpecificCityName_ReturnsEqual() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        cityViewModel.search(searchText: "Johburg")
        XCTAssertEqual(cityViewModel.filteredCity?.count,1)
    }
    
    func testSearchPetBySpecificCityName_ReturnsIncorrectValue() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        cityViewModel.search(searchText: "Cape Town")
        XCTAssertEqual(cityViewModel.filteredCityCount,0)
    }
    
    func testSearchPetBySpecificCityName_ReturnsCorrectValue() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        cityViewModel.search(searchText: "Johburg")
        XCTAssertEqual(cityViewModel.filteredCityCount,1)
    }
    
    func testFetchSearch_ResultsFailure() {
        cityViewModel.fetchCityResults()
        XCTAssertFalse(mockCityDelegate.reloadViewCalled)
        XCTAssert(mockCityDelegate.errorCalled)
    }

    func testFetchSearch_ResultsSuccess() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        XCTAssert(mockCityDelegate.reloadViewCalled)
        XCTAssertFalse(mockCityDelegate.errorCalled)
    }

    func testCityCount_ResultIncorrectCount() {
        cityViewModel.fetchCityResults()
        XCTAssertEqual(cityViewModel.cityCount, 0)
    }
    
    func testCityCount_ResultCorrectCount() {
        mockCityRepository.shouldPass = true
        cityViewModel.fetchCityResults()
        XCTAssertEqual(cityViewModel.cityCount, 1)
    }
}

class MockCityListDelegate: searchCityViewModelDelegate {
    var reloadViewCalled = false
    var errorCalled = false
    
    func reloadView() {
        reloadViewCalled = true
    }
    
    func showError(error: String, message: String) {
        errorCalled = true
    }
}

class MockCityListDataRepository: SearchCityRepositoryType {
    var shouldPass = false
    
    func fetchCityDataResults(completion: @escaping CityDataResult) {
        if shouldPass {
            let mockData = setMockData
            completion(.success(mockData))
        } else {
            completion(.failure(.serverError))
        }
    }
    
    private var setMockData: [CityData] {
        var cityData: [CityData] = []
        cityData.append(CityData.init(id: 1, name: "Johburg", state: "SA", country: "SA", coord: Coordinate(lon: 26.55, lat: 23.88)))
        return cityData
    }
}
