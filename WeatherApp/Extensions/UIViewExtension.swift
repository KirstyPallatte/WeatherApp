//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/28.
//

import Foundation
import UIKit

extension UIView {
    func loadViewFromNib<T: UIView>(nibName: String) -> T {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        guard let view = nib.instantiate(withOwner: self, options: nil)[0] as? T else {
            fatalError("Could not instantiate this view") }
        return view
    }
}
