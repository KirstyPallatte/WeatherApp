//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/22.
//

import Foundation
import UIKit

class SearchCityViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var cityTableview: UITableView!
    @IBOutlet weak private var searchBar: UISearchBar!
    
    // MARK: - Var/Lets
    private lazy var searchCityViewModel = SearchCityViewModel(repository: CityRepository(),
                                                               delegate: self)
    private weak var delegate: searchCityViewModelDelegate?
    private var citySearchText: String?
    private var bSearch = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        setUpTableview()
        cityList()
    }
    
    func setUpTableview() {
        self.cityTableview.delegate = self
        self.cityTableview.dataSource = self
    }
    
    func cityList() {
        searchCityViewModel.fetchCityResults()
    }
}

// MARK: - Extension - UITableViewDelegate and DataSource
extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
     if !bSearch {
        return searchCityViewModel.cityCount
     } else {
         return searchCityViewModel.filteredCityCount
     }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "FaouritesViewController", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var pageItem: CityData.RefCountryCode?
        guard let indexRow = cityTableview.indexPathForSelectedRow?.row else { return }
        if let destination = segue.destination as? FavouriteLocationsViewController {
            if !bSearch {
                pageItem = searchCityViewModel.arrCity?[indexRow]
            } else {
                pageItem = searchCityViewModel.filteredCity?[indexRow]
            }
            guard let cityName = pageItem?.country else { return }
            guard let cityLattitude = pageItem?.latitude else { return }
            guard let cityLongitude = pageItem?.longitude else { return }
            destination.setSingleCityData(cityName: cityName,
                                          lattitude: cityLattitude,
                                          longitude: cityLongitude,
                                          image: Constants.SEASUNNY)
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                  for: indexPath)
        if !bSearch {
            cell.textLabel?.text = searchCityViewModel.arrCity?[indexPath.row].country
        } else {
            cell.textLabel?.text = searchCityViewModel.filteredCity?[indexPath.row].country
            
        }
        return cell
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        citySearchText = searchText
        searchCityViewModel.search(searchText: searchText)
        bSearch = true
        reloadView()
    }
}

extension SearchCityViewController: searchCityViewModelDelegate {
    func reloadView() {
       cityTableview.reloadData()
    }
    
    func showError(error: String, message: String) {
        displayAlert(alertTitle: error,
                     alertMessage: message,
                     alertActionTitle: "Try Again" ,
                     alertDelegate: self,
                     alertTriggered: .errorAlert)
    }
}
