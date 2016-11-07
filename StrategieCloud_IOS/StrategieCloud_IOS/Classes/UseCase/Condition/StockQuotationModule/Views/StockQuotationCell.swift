//
//  StockQuotationCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class StockQuotationCell: UITableViewCell,QuotationDataSource{

    @IBOutlet weak var changeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    let downColor = UIColor.colorWith(15, green: 199, blue: 15, alpha: 1)
    let upColor = UIColor.colorWith(255, green: 78, blue: 86, alpha: 1)
    var headName = "" {
        didSet {
           if headName == "turnover" || headName == "volume_rate"  {
                setLabelState1()
            }
        }
    }
    var code = "" {
        didSet {
           self.codeLabel.text = (code as NSString).substringFromIndex(2)
        }
    }
    var name = "" {
        didSet {
           self.nameLabel.text = name
        }
    }
    
    var change : Double = 0 {
        didSet {
                setLabelState()
                if self.change > 0 {
                    self.changeLabel.text = "+" + String(change) + "%"
                }else {
                    self.changeLabel.text = String(change) + "%"
                }
        }
    }
    
    var price  : Double = 0 {
        didSet {
            self.priceLabel.text = String(price)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        if headName == "turnover" || headName == "volume_rate" {
            setLabelState1()
            self.changeLabel.text = String(change) + "%"
        }else {
            
        }
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLabelState() {
        if self.change < 0 {
            self.changeLabel.textColor = downColor
        }else {
            self.changeLabel.textColor = upColor
        }
    }
    
    func setLabelState1() {
      self.changeLabel.textColor = UIColor.darkTextColor()
        if self.headName == "volume_rate" {
            if self.change < 0 {
                self.changeLabel.text = (String(change) as NSString).substringFromIndex(1)
            }else {
                self.changeLabel.text = String(change)
            }
        }else {
            if self.change < 0 {
                self.changeLabel.text = (String(change) as NSString).substringFromIndex(1) + "%"
            }else {
                self.changeLabel.text = String(change) + "%"
            }
        }
      
    }
    
    func set(stockName name: String){
        self.name = name
    }
    
    func set(stockCode code: String){
        self.code = code
    }
    
    func set(change change: Double){
        self.price = change
    }
    
    func set(percentage percentage: Double){
        self.change = percentage
    }
    
    func set(headName name: String){
        self.headName = name
    }
}
