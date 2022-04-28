//
//  UITableviewCellExtension.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/28.
//

import Foundation
import UIKit

extension UITableViewCell {
  static var reuseIdentifier: String {
      return String(describing: self)
  }
  
  static var nibName: String {
    return String(describing: self)
  }
}
