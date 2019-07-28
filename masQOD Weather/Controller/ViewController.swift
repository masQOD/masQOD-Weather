//
//  ViewController.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 27/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var imgSunny: UIImageView!
    @IBOutlet weak var lblTemp: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var bgEffect: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnChangeDegree: MaterialButton!
    @IBOutlet weak var btnChangeLoc: MaterialButton!
    @IBOutlet weak var btnChangeCelcius: MaterialButton!
    
    
    let locationManager = CLLocationManager()
    
//    var currentWeather: CurrentWeather!
    var currentLocation: CLLocation!
    var foreCastWeather: ForeCastWeatherModel!
    var foreCastArray = [ForeCastWeatherModel]()
    var foreCastWeatherF: ForeCastWeatherModelF!
    var foreCastArrayF = [ForeCastWeatherModelF]()
    var btnClick:String = "Celcius"
//    var latitude:Double = 0
//    var longitude:Double = 0
    var errorModal: UIAlertController?
    
    var weatherRepo: WeatherRepository{
        get{
            return WeatherRepository()
        }
    }
    
    private var _locationName: String!
    private var _date: String!
    private var _weatherCondition: String!
    private var _currentTemp: Double!
    
    var locationName: String{
        if _locationName == nil{
            _locationName = ""
        }
        return _locationName
    }
    
    var date: String{
        if _date == nil{
            _date = ""
        }
        return _date
    }
    
    var weatherCodition: String{
        if _weatherCondition == nil{
            _weatherCondition = ""
        }
        return _weatherCondition
    }
    
    var currentTemp: Double{
        if _currentTemp == nil{
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegates()
//        downloadCurrentWeather()
        setTempLocation()
        applyEffect()
        defaultButton()
        btnChangeLoc.addTarget(self, action: #selector(btnChangeLocPressed), for: .touchUpInside)
        btnChangeDegree.addTarget(self, action: #selector(btnChangeDegreePressed), for: .touchUpInside)
        btnChangeCelcius.addTarget(self, action: #selector(btnChangeCelciusPressed), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(loudly), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    func defaultButton(){
        if btnClick == "Celcius"{
            btnChangeCelcius.isEnabled = false
            btnChangeDegree.isEnabled = true
        }else if btnClick == "Fahrenheit"{
            btnChangeDegree.isEnabled = false
            btnChangeCelcius.isEnabled = true
        }
    }
    
    @objc func loudly(){
        downloadCurrentWeather()
        downloadForeCastWeather{
            print("Data Completed")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        AuthCheckLocation()
        downloadForeCastWeather{
            print("Data Completed")
        }
    }
    
    func AuthCheckLocation(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currentLocation = locationManager.location //ambil current location di device
            print(currentLocation)
            
            //ambil longlatnya
            LocationWeather.sharedInstance.latitude = currentLocation.coordinate.latitude
            LocationWeather.sharedInstance.longitude = currentLocation.coordinate.longitude
            
            //setelah dapat longlatnya baru di update ke UI
            downloadCurrentWeather()
            
        }else{
            locationManager.requestWhenInUseAuthorization() //looping minta ijin
            AuthCheckLocation()
        }
    }
    
    func downloadForeCastWeather(completed: @escaping DownloadComplete){
        Alamofire.request(FORECAST_API_URL).responseJSON{(response)in
            let result = response.result
            if let dictionary = result.value as? Dictionary<String, AnyObject>{
                if let list = dictionary["list"] as? [Dictionary<String, AnyObject>]{
                    self.foreCastArray.removeAll()
                    for item in list{
                        let foreCast = ForeCastWeatherModel(weatherDict: item)
                        self.foreCastArray.append(foreCast)
                    }
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func setTempLocation(){
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization() //permintaan izin lokasi
        locationManager.startMonitoringSignificantLocationChanges()
    }

    func callDelegates(){
        locationManager.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func applyEffect(){
        specialEffect(view: bgEffect, intensity: 40)
        specialEffect(view: imgSunny, intensity: -20)
    }
    
    func specialEffect(view:UIView, intensity: Double){
        let horizontalMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalMotion.minimumRelativeValue = -intensity
        horizontalMotion.maximumRelativeValue = intensity
        
        let verticalMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalMotion.minimumRelativeValue = -intensity
        verticalMotion.maximumRelativeValue = intensity
        
        let movement = UIMotionEffectGroup()
        movement.motionEffects = [horizontalMotion,verticalMotion]
        
        view.addMotionEffect(movement)
    }
    
    func updateViewController(){
        stopLoading()
        lblLocation.text = locationName
        lblCondition.text = weatherCodition
        if btnClick == "Celcius"{
            lblTemp.text = "\(Int(currentTemp))"+" ºC"
        }else{
            lblTemp.text = "\(Int(currentTemp))"+" ºF"
        }
        lblDate.text = date
    }
    
    @objc func btnChangeLocPressed(){
        self.performSegue(withIdentifier: "gotoLocation", sender: self)
    }
    
    @objc func btnChangeDegreePressed(){
//        updateToF()
        btnClick = "Fahrenheit"
        defaultButton()
        foreCastArrayF.removeAll()
        AuthCheckLocationF()
    }
    
    @objc func btnChangeCelciusPressed(){
        btnClick = "Celcius"
        defaultButton()
        foreCastArray.removeAll()
//        currentWeather.downloadCurrentWeather {
//            self.updateViewController()
//        }
        downloadCurrentWeather()
        downloadForeCastWeather{
            print("Data Completed")
        }
    }
    
    func AuthCheckLocationF(){
//        currentWeather.downloadCurrentWeather{
//            self.updateToF()
//        }
        downloadCurrentWeather()
        downloadForeCastWeatherF{
            print("Data Completed")
        }
    }
    
    func downloadForeCastWeatherF(completed: @escaping DownloadComplete){
        Alamofire.request(FORECAST_API_URL).responseJSON{(response)in
            let result = response.result
            if let dictionary = result.value as? Dictionary<String, AnyObject>{
                if let list = dictionary["list"] as? [Dictionary<String, AnyObject>]{
                    for item in list{
                        let foreCast = ForeCastWeatherModelF(weatherDict: item)
                        self.foreCastArrayF.append(foreCast)
                        print(foreCast)
                    }
                    self.tableView.reloadData()
                }
            }
            completed()
        }
    }
    
    func downloadCurrentWeather(){
        startLoading()
        weatherRepo.currentWeather(completion: successGetWeather, errorCompletion: showError)
    }
    
    func successGetWeather(result: JSON, repo: Repository){
        self._locationName = result["name"].stringValue
        let tempDate = result["dt"].double
        let convertDate = Date(timeIntervalSince1970: tempDate!) //Converting to Current Date
        print(convertDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy', 'HH:mm"
        let currentDate = dateFormatter.string(from: convertDate)
        print(currentDate)
        self._date = "\(currentDate)"
        
        self._weatherCondition = result["weather"][0]["main"].stringValue
        
        let downloadTemp = result["main"]["temp"].double
        let celciusTemp = (downloadTemp! - 273.15).rounded(toPlaces: 0)
        let fahrenheitTemp = celciusTemp * (9/5) + 32
        if btnClick == "Celcius"{
            self._currentTemp = celciusTemp
            updateViewController()
        }else{
            self._currentTemp = fahrenheitTemp
            updateViewController()
        }
    }
    
    func showError(result: JSON, repo: Repository){
        let alert = UIAlertController(title: "",
                                      message: "Oops, something went wrong",
            preferredStyle: UIAlertController.Style.alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default){
            UIAlertAction in
            NSLog("Retry Pressed")
            self.downloadCurrentWeather()
        }
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(retryAction)
        alert.addAction(cancelAction)
        errorModal = alert
        
        self.present(alert, animated: true, completion: nil)
        stopLoading()
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForeCastCell") as! ForeCastCell
//        cell.configurattionCell(temp: 10, day: "SABTU")
        if btnClick == "Celcius"{
            cell.configurattionCell(foreCastData: foreCastArray[indexPath.row])
        }else if btnClick == "Fahrenheit"{
            cell.configurattionCellF(foreCastData: foreCastArrayF[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foreCastArray.count
    }
}
