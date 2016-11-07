//
//  IncomeTopCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
class IncomeTopCell: UITableViewCell ,IncomeTopDataSource{
    let positionColor = UIColor.colorWith(83, green: 192, blue: 111, alpha: 1)
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var strategyLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var codelabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    let downColor = UIColor.colorWith(15, green: 199, blue: 15, alpha: 1)
    let upColor = UIColor.colorWith(255, green: 78, blue: 86, alpha: 1)
    var stockId: Int?
    
    var code = "" {
        didSet {
            self.codelabel.text = (code as NSString).substringFromIndex(2)
        }
    }
    
    var name = "" {
        didSet {
            self.nameLabel.text = name
        }
    }
    
    var position : Int = 0 {
        didSet {
            self.strategyLabel.text = "总收益"
            
            switch position {
            case 0:
                self.positionLabel.textColor = UIColor.KLineDownColor()
                self.positionLabel.text = "空仓"
                self.positionLabel.font = UIFont.boldSystemFontOfSize(14)
            case 1:
                self.positionLabel.text = "1/3仓位"
                self.positionLabel.textColor = UIColor(red: 255/255.0, green: 142/255.0, blue: 150/255.0, alpha: 1.0)
            case 2:
                self.positionLabel.text = "2/3仓位"
                self.positionLabel.textColor = UIColor(red: 255/255.0, green: 108/255.0, blue: 118/255.0, alpha: 1.0)
            default:
                self.positionLabel.text = "满仓"
                self.positionLabel.font = UIFont.boldSystemFontOfSize(14)
                self.positionLabel.textColor = UIColor.TextUpColor()
            }
            //message
        }
    }
    
    var percentage : Double = 0 {
        didSet {
            if percentage >= 0 {
               self.percentageLabel.text = String(format: "%.2f",percentage*100) + "%"
               self.percentageLabel.textColor = upColor
            }else {
               self.percentageLabel.text = String(format: "%.2f",percentage*100) + "%"
               self.percentageLabel.textColor = downColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: TO DO
    
    func setDataToView(data: String) {
        self.positionLabel.text = data
        setPositionLabelState(data)
    }
    
    func setPositionLabelState(position: String) {
        if position == "" {
            self.positionLabel.textColor = positionColor
            self.positionLabel.font = UIFont.boldSystemFontOfSize(14)
        }else if position == "满仓" {
            self.positionLabel.font = UIFont.boldSystemFontOfSize(14)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func set(stockName name: String) {
        self.name = name
    }
    
    func set(stockCode code: String) {
        self.code = code
    }
    
    func set(percentage percentage: Double){
        self.percentage = percentage
    }
    
    func set(position position: Int) {
        self.position = position
    }
    
    func set(rowId rowId: Int) {
        self.stockId = rowId
    }
  
    
}
