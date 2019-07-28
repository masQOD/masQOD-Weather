////
////  CurrentWeather.swift
////  masQOD Weather
////
////  Created by Qodir Masruri on 27/07/19.
////  Copyright © 2019 Moonlay Technologies. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Alamofire
//import SwiftyJSON
//
//class CurrentWeather{
//
//    private var _locationName: String!
//    private var _date: String!
//    private var _weatherCondition: String!
//    private var _currentTemp: Double!
//
//    var errorModal: UIAlertController?
//
//    var weatherRepo: WeatherRepository{
//        get{
//            return WeatherRepository()
//        }
//    }
//
//    var locationName: String{
//        if _locationName == nil{
//            _locationName = ""
//        }
//        return _locationName
//    }
//
//    var date: String{
//        if _date == nil{
//            _date = ""
//        }
//        return _date
//    }
//
//    var weatherCodition: String{
//        if _weatherCondition == nil{
//            _weatherCondition = ""
//        }
//        return _weatherCondition
//    }
//
//    var currentTemp: Double{
//        if _currentTemp == nil{
//            _currentTemp = 0.0
//        }
//        return _currentTemp
//    }
//
//    func downloadCurrentWeather(){
//        weatherRepo.currentWeather(completion: successGetWeather, errorCompletion: showError)
//    }
//
//    func successGetWeather(result: JSON, repo: Repository){
//        self._locationName = result["name"].stringValue
//        let tempDate = result["dt"].double
//        let convertDate = Date(timeIntervalSince1970: tempDate!) //Converting to Current Date
//        print(convertDate)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMMM yyyy', 'HH:mm"
//        //            dateFormatter.dateStyle = .medium
//        //            dateFormatter.timeStyle = .none
//        let currentDate = dateFormatter.string(from: convertDate)
//        print(currentDate)
//        self._date = "\(currentDate)"
//
//        self._weatherCondition = result["weather"][0]["main"].stringValue
//
//        let downloadTemp = result["main"]["temp"].double
//        self._currentTemp = (downloadTemp! - 273.15).rounded(toPlaces: 0)
//    }
//
//    func showError(result: JSON, repo: Repository){
//        let alert = UIAlertController(title: "",
//                                      message: "Oops, something went wrong",
//            preferredStyle: UIAlertController.Style.alert)
//
//        let retryAction = UIAlertAction(title: "Retry", style: .default)
//        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//
//        alert.addAction(retryAction)
//        alert.addAction(cancelAction)
//        errorModal = alert
//
//        self.downloadCurrentWeather()
//
//    }
//
////    func downloadCurrentWeather2(completed: @escaping DownloadComplete){
////        Alamofire.request(API_URL).responseJSON{(response) in
////            let result = response.result
////            let json = JSON(result.value)
////
////            self._locationName = json["name"].stringValue
////
////            let tempDate = json["dt"].double
////            let convertDate = Date(timeIntervalSince1970: tempDate!) //Converting to Current Date
////            print(convertDate)
////            let dateFormatter = DateFormatter()
////            dateFormatter.dateFormat = "dd MMMM yyyy', 'HH:mm"
//////            dateFormatter.dateStyle = .medium
//////            dateFormatter.timeStyle = .none
////            let currentDate = dateFormatter.string(from: convertDate)
////            print(currentDate)
////            self._date = "\(currentDate)"
////
////            self._weatherCondition = json["weather"][0]["main"].stringValue
////
////            let downloadTemp = json["main"]["temp"].double
////            self._currentTemp = (downloadTemp! - 273.15).rounded(toPlaces: 0) //Converting dari Kelvin ke Celcius
////            completed()
////        }
////    }
//}
