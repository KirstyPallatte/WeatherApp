//
//  FavouriteLocationsViewController.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/23.
//

import Foundation
import UIKit

class FavouriteLocationsViewController: UIViewController {
    
    // MARK: - VIBOutlets
    @IBOutlet weak private var favouriteCityTableview: UITableView!

    // MARK: - Vars/Lets
    private lazy var cityFavouriteViewModel = FavouriteLocationViewModel(repository: FavouriteLocationRepository(),
                                                                         delegate: self)

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        cityFavouriteViewModel.fetchCityDataResults()
        guard let cityName =  cityFavouriteViewModel.nameSingleCity,
                let cityLattitude =  cityFavouriteViewModel.lattitudeSingleCity,
                let cityLongitude =  cityFavouriteViewModel.longitudeSingleCity else { return }
        cityFavouriteViewModel.saveCityInLocalDatabase(nameCity: cityName, lattitude: cityLattitude, longitude: cityLongitude)
    }
    
    @IBAction private func addFavouritesButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "SearchCityViewController", sender: self)
    }

    func setSingleCityData(cityName: String, lattitude: Double, longitude: Double, image: String) {
        cityFavouriteViewModel.setSingleCityObject(cityName: cityName, lattitude: lattitude, longitude: longitude, image: image)
    }
    
    private func setupTableView() {
        favouriteCityTableview.dataSource = self
        favouriteCityTableview.delegate = self
        title = "Favourite Locations"
        favouriteCityTableview.register(FavouriteTableViewCell.self)
    }
}

// MARK: - UITableViewDataSource
extension FavouriteLocationsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityFavouriteViewModel.citySavedCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let city = cityFavouriteViewModel.savedCity(at: indexPath.row) else { return UITableViewCell() }
        guard let cell = tableView.dequeueReuseableCell(forIndexPath: indexPath,
                                                        reuseIdentifier: FavouriteTableViewCell.reuseIdentifier)
                                                        as? FavouriteTableViewCell
        else { return UITableViewCell() }
        
        let cityName = cityFavouriteViewModel.cityLocationNameSaved(city: city)
        let cityLattitude = cityFavouriteViewModel.cityLattitudeSaved(city: city)
        let cityLongitude = cityFavouriteViewModel.cityLongitudeSaved(city: city)
        cell.updateUI(cityName: cityName, lattitudeCity: cityLattitude, longitudeCity: cityLongitude)
        cell.setNeedsLayout()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CurrentWeatherViewController", sender: self)
        reloadView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CurrentWeatherViewController {
            guard let indexRow = favouriteCityTableview.indexPathForSelectedRow?.row else { return }
            guard let lattitude = cityFavouriteViewModel.savedCity(at: indexRow)?.lattitude,
                  let longitude = cityFavouriteViewModel.savedCity(at: indexRow)?.longitude else { return }
            destination.setFavLatLong(cityLattitude:lattitude, cityLongitude: longitude)
        }

    }

    // MARK: - Delete
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal,
                                              title: "Delete",
                                              handler: { (_: UIContextualAction, _: UIView, success: (Bool) -> Void) in
            self.showDeleteWarning(for: indexPath)
            success(true)
        })

        deleteAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func showDeleteWarning(for indexPath: IndexPath) {
        guard let cityToRemove = cityFavouriteViewModel.savedCity(at: indexPath.row),
                let cityDeleteName = cityToRemove.locationName else { return }
        
        presentAlertWarning(title: "Delete \(cityDeleteName)",
                                  message: "Are you sure you want to delete \(cityDeleteName)",
                                  options: "Cancel", "Delete") { [self] (optionPressed) in
            switch optionPressed {
            case "Cancel":
                break
            case "Delete":
                cityFavouriteViewModel.deleteCityLocaldatabase(cityToRemove: cityToRemove)
            default:
                break
            }
    }
}
}

extension FavouriteLocationsViewController: CityLocalDatabaseViewModelDelegate {
    func refreshCity() {
        cityFavouriteViewModel.fetchCityDataResults()
    }

    func isPetDeletedSuccessfully(isDeleteSuccess: Bool) {
        cityFavouriteViewModel.set(isCityDeleteSuccess: isDeleteSuccess)
    }

    func reloadView() {
        favouriteCityTableview.reloadData()
    }

    func showError(errorTitle: String, errorMessage: String, action: LocalDatabaseError) {
        displayAlert(alertTitle: errorTitle,
                     alertMessage: errorMessage,
                     alertActionTitle: "Try Again" ,
                     alertDelegate: self,
                     alertTriggered: .fatalLocalDatabaseAlert)
    }
}
