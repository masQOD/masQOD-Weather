//
//  ChangeLocationViewController.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 28/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ChangeLocationViewController: UIViewController {
    
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnSave: MaterialButton!
    @IBOutlet weak var btnCancel: MaterialButton!
    
    var weathRepo: WeatherRepository{
        get{
            return WeatherRepository()
        }
    }
    
//    var dest:ViewController?
    var errorModal: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSave.addTarget(self, action: #selector(btn_savePressed), for: .touchUpInside)
        btnCancel.addTarget(self, action: #selector(btn_cancelPressed), for: .touchUpInside)
    }
    
    @objc func btn_savePressed(){
        if txtLocation.text != ""{
            startLoading()
            getLocation()
        }else{
            lblError.isHidden = false
            lblError.text = "Field can not be null"
        }
    }
    
    func getLocation(){
        startLoading()
        weathRepo.changeLocation(location: txtLocation.text!, completion: successNewLoc, errorCompletion: showError)
    }
    
    func successNewLoc(result: JSON, repo: Repository){
        stopLoading()
        let longitude = result["coord"]["lon"].doubleValue
        let latitude = result["coord"]["lat"].doubleValue
        
        LocationWeather.sharedInstance.latitude = latitude
        LocationWeather.sharedInstance.longitude = longitude
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showError(result: JSON, repo: Repository){
        lblError.isHidden = false
        lblError.text = result["message"].stringValue
        stopLoading()
    }
    
    @objc func btn_cancelPressed(){
        self.dismiss(animated: true, completion: nil)
    }
}
