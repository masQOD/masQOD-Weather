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
    @IBOutlet weak var btnDownload: UIButton!
    
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    var foreCastWeather: ForeCastWeatherModel!
    var foreCastArray = [ForeCastWeatherModel]()
    var foreCastWeatherF: ForeCastWeatherModelF!
    var foreCastArrayF = [ForeCastWeatherModelF]()
    var btnClick:String = "Celcius"
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
        setTempLocation()
        applyEffect()
        defaultButton()
        btnChangeLoc.addTarget(self, action: #selector(btnChangeLocPressed), for: .touchUpInside)
        btnChangeDegree.addTarget(self, action: #selector(btnChangeDegreePressed), for: .touchUpInside)
        btnChangeCelcius.addTarget(self, action: #selector(btnChangeCelciusPressed), for: .touchUpInside)
        btnDownload.addTarget(self, action: #selector(btnDownloadPressed), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(loudly), name: NSNotification.Name(rawValue: "load"), object: nil)
    }
    
    @objc func btnDownloadPressed(){
        self.performSegue(withIdentifier: "gotoDownload", sender: self)
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
        if foreCastArray.count >= 0{
            foreCastArray.removeAll()
        }
        if foreCastArrayF.count >= 0{
            foreCastArrayF.removeAll()
        }
        downloadCurrentWeather()
        downloadForeCastWeather()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if foreCastArray.count >= 0{
            foreCastArray.removeAll()
        }
        if foreCastArrayF.count >= 0{
            foreCastArrayF.removeAll()
        }
        AuthCheckLocation()
        downloadForeCastWeather()
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
    
    func downloadForeCastWeather(){
        startLoading()
        weatherRepo.getTempWeekly(completion: successForecast, errorCompletion: showError)
    }
    
    func successForecast(result: JSON, repo: Repository){
        if let dictionary = result.rawValue as? Dictionary<String, AnyObject>{
            if let list = dictionary["list"] as? [Dictionary<String, AnyObject>]{
                for item in list{
                    if btnChangeCelcius.isEnabled == false{
                        let foreCast = ForeCastWeatherModel(weatherDict: item)
                        self.foreCastArray.append(foreCast)
                    }else{
                        let foreCast = ForeCastWeatherModelF(weatherDict: item)
                        self.foreCastArrayF.append(foreCast)
                    }
                }
                self.tableView.reloadData()
            }
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
        if btnChangeCelcius.isEnabled == false{
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
        downloadCurrentWeather()
        downloadForeCastWeather()
    }
    
    @objc func btnChangeCelciusPressed(){
        btnClick = "Celcius"
        defaultButton()
        foreCastArray.removeAll()
        downloadCurrentWeather()
        downloadForeCastWeather()
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
        if btnChangeCelcius.isEnabled == false{
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
        if btnChangeCelcius.isEnabled == false {
            cell.configurattionCell(foreCastData: foreCastArray[indexPath.row])
        }else{
            cell.configurattionCellF(foreCastData: foreCastArrayF[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foreCastArray.count
    }
}
