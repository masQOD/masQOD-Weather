//
//  WeatherRepository.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 28/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherRepository: Repository{
    let mainWeather = "https://api.openweathermap.org/data/2.5/weather?"
    let apikey = "&appid=c0bc0dfdf007f85ba77f5fc9fb8fa7c0"
    
    func currentWeather(completion: @escaping jsonCompletion, errorCompletion: @escaping jsonCompletion){
        let url = mainWeather + "lat=\(LocationWeather.sharedInstance.latitude!)&lon=\(LocationWeather.sharedInstance.longitude!)"+apikey
        let defaultHeaders = ["Content-Type":"application/json"]
        
        RequestAsync(url: url, headers: defaultHeaders, httpMethod: .get, completion: completion, errorCompletion: errorCompletion)
    }

    func changeLocation(location: String, completion: @escaping jsonCompletion, errorCompletion: @escaping jsonCompletion){
        let url = mainWeather+"q="+location+apikey
        let parameter : [String: Any] = ["data":[["name": location]]]
        let defaultHeaders = ["Content-Type":"application/json"]
        
        RequestAsync(url: url,  headers: defaultHeaders, httpMethod: .post, parameters: parameter, completion: completion, errorCompletion: errorCompletion)
    }
}
