//
//  EachProfitViewCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol EachProfitDataSource {
	func eachProfitValue(profit10: Float?, profit60: Float?, profit250: Float?)
}

class EachProfitViewCell: UITableViewCell, EachProfitDataSource {

	@IBOutlet weak var profit10Label: UILabel!
	@IBOutlet weak var profit60Label: UILabel!
	@IBOutlet weak var profit250Label: UILabel!
	
	let profitInvalidVal = Float(-10000)
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func eachProfitValue(profit10: Float?, profit60: Float?, profit250: Float?) {
		if let _profit10 = profit10 {
			if _profit10 == profitInvalidVal {
				profit10Label.textColor = UIColor.colorWith(187, green: 187, blue: 187, alpha: 1.0)
				profit10Label.text = "0.0"
			} else {
				profit10Label.textColor = (_profit10 >= 0) ? UIColor.TextUpColor() : UIColor.TextDownColor()
				profit10Label.text = Converts.percentStrFromDecimalPlacesFloat(_profit10)
			}
		}
		if let _profit60 = profit60 {
			if _profit60 == profitInvalidVal {
				profit60Label.textColor = UIColor.colorWith(187, green: 187, blue: 187, alpha: 1.0)
				profit60Label.text = "0.0"
			} else {
				profit60Label.textColor = (_profit60 >= 0) ? UIColor.TextUpColor() : UIColor.TextDownColor()
				profit60Label.text = Converts.percentStrFromDecimalPlacesFloat(_profit60)
			}
		}
		if let _profit250 = profit250 {
			if _profit250 == profitInvalidVal {
				profit250Label.textColor = UIColor.colorWith(187, green: 187, blue: 187, alpha: 1.0)
				profit250Label.text = "0.0"
			} else {
				profit250Label.textColor = (_profit250 >= 0) ? UIColor.TextUpColor() : UIColor.TextDownColor()
				profit250Label.text = Converts.percentStrFromDecimalPlacesFloat(_profit250)
			}
		}
	}
}
