//
//  TotalProfitViewCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol TotalProfitDataSource {
	func totalProfitValue(value: Float?, apply: Bool)
}

protocol TotalProfitDelegate: class {
	func totalProfitSwithValueChanged(on: Bool)
}

class TotalProfitViewCell: UITableViewCell, TotalProfitDataSource {
	
	@IBOutlet weak var splitView: UIView!
	@IBOutlet weak var applyHintLabel: UILabel!
	
	@IBOutlet weak var valueLabel: UILabel!
	@IBOutlet weak var applySwitch: SevenSwitch! {
		didSet {
			applySwitch.onLabel.text = "开"
			applySwitch.offLabel.text = "关"
		}
	}
	
	weak var delegate: TotalProfitDelegate?
	let profitInvalidVal = Float(-10000)
	
	func showTotalProfitRightLl(show: Bool) {
		splitView.hidden = !show
		applyHintLabel.hidden = !show
		applySwitch.hidden = !show
	}


	func totalProfitValue(value: Float?, apply: Bool) {
		applySwitch.on = apply
		if let val = value {
			if val == profitInvalidVal {
				valueLabel.textColor = UIColor.colorWith(187, green: 187, blue: 187, alpha: 1.0)
				valueLabel.text = "0.0"
				return
			}
			
			
			if val >= 0 {
				valueLabel.textColor = UIColor.TextUpColor()
			} else {
				valueLabel.textColor = UIColor.TextDownColor()
			}
			valueLabel.text = Converts.percentStrFromDecimalPlacesFloat(val)
		}
		
	}
	
	@IBAction func applySwitchValueChanged(sender: SevenSwitch) {
		delegate?.totalProfitSwithValueChanged(sender.on)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}
