//
//  DownloadImageViewController.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 29/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation
import UIKit

class DownloadImageViewController: UIViewController{
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var imgWeather: UIImageView!
    @IBOutlet weak var btnOK: MaterialButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOK.addTarget(self, action: #selector(btnOKPressed), for: .touchUpInside)
        loadImg()
    }
    
    func loadImg(){
        let imgBackground = UIImage(named: "background")
        imgBg.image = imgBackground
        let imgCloud = UIImage(named: "cloud")
        imgWeather.image = imgCloud
    }
    
    @objc func btnOKPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
