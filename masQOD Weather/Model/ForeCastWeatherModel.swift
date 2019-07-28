//
//  ForeCastWeatherModel.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 27/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation

class ForeCastWeatherModel{
    private var _date: String!
    private var _temp: Double!
    
    var date: String{
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    var temp: Double{
        if _temp == nil{
            _temp = 0.0
        }
        return _temp
    }
    
    init(weatherDict: Dictionary<String, AnyObject>){
        if let temp = weatherDict["temp"] as? Dictionary<String, AnyObject>{
            if let dayTemp = temp["day"] as? Double{
                let rawValue = (dayTemp - 273.15).rounded(toPlaces: 0)
                self._temp = rawValue
            }
        }
        if let date = weatherDict["dt"] as? Double{
            let rawDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let currentDate = dateFormatter.string(from: rawDate)
            
            self._date = "\(rawDate.dayOfTheWeek())"+", \(currentDate)"
        }
    }
}
