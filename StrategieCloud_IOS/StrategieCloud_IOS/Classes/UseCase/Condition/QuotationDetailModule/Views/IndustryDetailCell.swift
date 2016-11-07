//
//  IndustryDetailCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol IndustryCellDelegate : NSObjectProtocol {
    func skipToDetailView(option: String,name : String)
}
class IndustryDetailCell: UITableViewCell,IndustryDataSource {
    var delegate : IndustryCellDelegate?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var riseLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!

    var code = ""
    var number = ""
    var headName = "" {
        didSet {
        
            
        }
    }
    var name = "" {
        didSet {
            self.nameLabel.text = name
        }
    }
    
    var industryName = "" {
        didSet {
            self.industryLabel.adjustsFontSizeToFitWidth = true
            self.industryLabel.text = industryName
        }
    }
    
    var change : Double = 0 {
        didSet {
            setLabelState()
            if self.change > 0 {
                self.riseLabel.text = "+" + String(change) + "%"
            }else {
                self.riseLabel.text = String(change) + "%"
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setLabelState() {
        if self.change < 0 {
            self.riseLabel.textColor = UIColor.TextDownColor()
        }else {
            self.riseLabel.textColor = UIColor.TextUpColor()
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if self.selected == true {
           self.delegate?.skipToDetailView(self.number, name: self.industryName)
        }
        // Configure the view for the selected state
    }
    
    func set(stockName name: String){
        self.name = name
    }
    
    func set(stockCode code: String){
        self.code = code
    }
    
    func set(industryName name : String){
        self.industryName = name
    }
    
    func set(percentage percentage: Double){
        self.change = percentage
    }
    
    func set(headName name: String){
        self.headName = name
    }
    
    func set(number number: String){
        self.number = number
    }
    
}
