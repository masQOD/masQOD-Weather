//
//  MaterialButton.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 28/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class MaterialButton: UIButton {
    
    var buttonFont = "OpenSans"
    @IBInspectable
    var imageName: String = ""
    
    var dashedLine : CAShapeLayer!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configure()
    }
    
    public override var isEnabled: Bool{
        get{
            return super.isEnabled
        }
        set{
            super.isEnabled = newValue
            if isEnabled{
//                self.backgroundColor = UIColor(red: 0.42, green: 0.13, blue: 0.15, alpha: 1)
                self.backgroundColor = UIColor(red:0.81, green:0.10, blue:0.13, alpha:1.0)
            }
            else{
                //self.backgroundColor = UIColor.lightGray
                self.backgroundColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1.0)
                self.setTitleColor(UIColor.white, for:.normal)
            }
        }
    }
    
    public func configure(){
        self.setTitleColor(UIColor.white, for:.normal)
        self.setTitleColor(UIColor.darkGray, for: .disabled)
        self.setTitleShadowColor(UIColor(red:0.50, green:0.50, blue:0.50, alpha:1.0), for: .normal)
        self.setTitleShadowColor(UIColor.darkGray, for: .disabled)
        self.titleLabel?.textAlignment = .center
        self.titleLabel?.font = UIFont(name: buttonFont, size: 18.0)
        self.backgroundColor = UIColor(red:0.81, green:0.10, blue:0.13, alpha:1.0)
        
        // corner radius
        self.layer.cornerRadius = 5
    }
    
}
