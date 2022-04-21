//
//  Constants.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/21.
//

import Foundation
import UIKit

struct Constants {
    static var APIKey = "8184f7495ce900d66677e0558be90083"
    static var weatherCurrentURl = "https://api.openweathermap.org/data/2.5/weather?lat=8&lon=5&appid=8184f7495ce900d66677e0558be90083"
    static var weatherForecast5URl = "api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&cnt=5&appid=8184f7495ce900d66677e0558be90083"
    
    static let viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
}
