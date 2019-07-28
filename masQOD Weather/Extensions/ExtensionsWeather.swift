//
//  ExtensionsWeather.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 27/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
