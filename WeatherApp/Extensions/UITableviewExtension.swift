//
//  UITableviewExtension.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/28.
//

import Foundation
import UIKit

extension UITableView {
  
  func register<T: UITableViewCell>(_: T.Type) {
    let nib = UINib(nibName: T.nibName, bundle: nil)
    register(nib, forCellReuseIdentifier: T.reuseIdentifier)
  }
  
    func dequeueReuseableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath, reuseIdentifier: String) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
      fatalError("Could not dequeue cell with identifier: \(reuseIdentifier)")
    }
    
    return cell
  }
  
}
