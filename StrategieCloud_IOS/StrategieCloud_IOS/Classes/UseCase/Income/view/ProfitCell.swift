//
//  ProfitCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/9.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol ProfitCellDataSource {
    func set(stockName name: String)
    func set(stockCode code: String)
    func set(percentage percentage: Double)
    func set(position position: Int)
    func set(rowId rowId: Int)
    func set(strategy startegy: String)
}
class ProfitCell: UITableViewCell,ProfitCellDataSource {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var profitLabel: UILabel!
    
    @IBOutlet weak var strategyLabel: UILabel!
    
    
    let downColor = UIColor.colorWith(15, green: 199, blue: 15, alpha: 1)
    let upColor = UIColor.colorWith(255, green: 78, blue: 86, alpha: 1)
    var stockId: Int?
    
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
    
    var position : Int = 0 {
        didSet {
            
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
              //  self.positionLabel.font = UIFont.boldSystemFontOfSize(14)
                self.positionLabel.textColor = UIColor.TextUpColor()
            }
            //message
        }
    }
    
    var percentage : Double = 0 {
        didSet {
            if percentage >= 0 {
                self.profitLabel.text = String(format: "%.2f",percentage*100) + "%"
                self.profitLabel.textColor = upColor
            }else {
                self.profitLabel.text = String(format: "%.2f",percentage*100) + "%"
                self.profitLabel.textColor = downColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
    func set(strategy startegy: String){
        self.strategyLabel.text = startegy
    }
}
