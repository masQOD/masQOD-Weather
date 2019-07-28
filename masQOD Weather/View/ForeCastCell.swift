//
//  ForeCastCell.swift
//  masQOD Weather
//
//  Created by Qodir Masruri on 27/07/19.
//  Copyright © 2019 Moonlay Technologies. All rights reserved.
//

import UIKit

class ForeCastCell: UITableViewCell {

    @IBOutlet weak var lblDayCell: UILabel!
    @IBOutlet weak var lblTempCell: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configurattionCell(foreCastData: ForeCastWeatherModel){
        self.lblDayCell.text = "\(foreCastData.date)"
        self.lblTempCell.text = "\(foreCastData.temp)" + " °C"
    }
    
    func configurattionCellF(foreCastData: ForeCastWeatherModelF){
        self.lblDayCell.text = "\(foreCastData.date)"
        self.lblTempCell.text = "\(foreCastData.temp)" + " °F"
    }
}
