//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/23.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
