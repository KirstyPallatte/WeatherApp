//
//  UIImageExtension.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/22.
//

import Foundation
import UIKit

extension UIImage {
    
    static var sunnyIcon: UIImage {
        return UIImage(named: "clear")!
    }
    
    static var rainyIcon: UIImage {
        return UIImage(named: "rain")!
    }
    
    static var cloudyIcon: UIImage {
        return UIImage(named: "partlysunny")!
    }
}
