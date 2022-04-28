//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Kirsty-Lee Walker on 2022/04/23.
//

import Foundation

extension Date {
    
    // MARK: - Vars/Lets
    private var weekDayArray: [String] {
        return  ["Sunday", "Monday", "Tuesday", "Wednesday", "Thurday", "Friday", "Saturday"]
    }
    
    var setNewWeekArray: [String] {
           let indexTomorrow = Calendar.current.component(.weekday, from: self)
           let indexFiveNumbers = (indexTomorrow + 4) % 7
           if indexTomorrow > indexFiveNumbers {
               let dayFirst = weekDayArray[indexTomorrow...6]
               let dayLast = weekDayArray[0...indexFiveNumbers]
               return Array(dayFirst + dayLast)
           } else {
               return Array(weekDayArray[indexTomorrow...indexFiveNumbers])
           }
       }
    
    // MARK: - Functions
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func todaysTimestamp() -> String {
        let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium , timeStyle: .short)
        return timestamp
    }
}
