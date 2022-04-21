//
//  FiveDayForecastViewController.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import Foundation
import UIKit

class FiveDayForecastViewController: UIViewController {

    // MARK: - Vars/Lets
    private lazy var fiveDayForecastViewModel = FiveDayForecastViewModel(repository: FiveDayForecastRepository(),
                                                                       delegate: self)
    override func viewDidLoad() {
        super.viewDidLoad()
        fiveDayForecastViewModel.fetchCurrentWeatherResults()
    }
}

extension FiveDayForecastViewController: FiveDayForecastViewModelDelegate {
    func reloadView() {
        
    }
    
    func showError(error: String, message: String) {
        
    }
    
}
