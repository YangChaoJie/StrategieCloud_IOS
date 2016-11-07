//
//  OptionalParamViewCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol OptionalParamViewCellDataSource: class {
	func setTitleForStyle(style: StrategyBean.Style)
	func setTitleForPeriod(period: StrategyBean.Period)
}

protocol OptionalParamViewCellDelegate: class {
	func optionalParamStyleValueChanged(style: StrategyBean.Style)
	func optionalParamPeriodValueChanged(period: StrategyBean.Period)
}

class OptionalParamViewCell: UITableViewCell, OptionalParamViewCellDataSource {

	
	@IBOutlet weak var hintLabel: UILabel!
	@IBOutlet weak var firstBtn: UIButton!
	@IBOutlet weak var secondBtn: UIButton!
	@IBOutlet weak var thirdBtn: UIButton!
	
	weak var delegate: OptionalParamViewCellDelegate?
	
	var styleType = false
	var periodType = false
	
	func setTitleForStyle(style: StrategyBean.Style) {
		styleType = true
		periodType = false
		hintLabel.text = "风格选择"
		firstBtn.setTitle(StrategyBean.Style.Conservative.desc(), forState: UIControlState.Normal)
		secondBtn.setTitle(StrategyBean.Style.Radicalness.desc(), forState: UIControlState.Normal)
		toNormal()
		
		switch style {
		case .Conservative:	//保守
			firstBtn.enabled = false
		case .Radicalness:	//激进
			secondBtn.enabled = false
		}
		
		thirdBtn.hidden = true
	}
	
	private func toNormal() {
		self.firstBtn.enabled = true
		self.secondBtn.enabled = true
		self.thirdBtn.enabled = true
	}
	
	func setTitleForPeriod(period: StrategyBean.Period) {
		periodType = true
		styleType = false
		hintLabel.text = "周期选择"
		firstBtn.setTitle(StrategyBean.Period.Long.desc(), forState: UIControlState.Normal)
		secondBtn.setTitle(StrategyBean.Period.Middle.desc(), forState: UIControlState.Normal)
		thirdBtn.setTitle(StrategyBean.Period.Short.desc(), forState: UIControlState.Normal)
		toNormal()
		thirdBtn.hidden = false
		switch period {
		case .Long:
			firstBtn.enabled = false
		case .Middle:
			secondBtn.enabled = false
		case .Short:
			thirdBtn.enabled = false
		}
	}
	
	@IBAction func btnClick(sender: UIButton) {
		toNormal()
		switch sender.tag {
		case 0:
			self.firstBtn.enabled = false
			if styleType {
				delegate?.optionalParamStyleValueChanged(StrategyBean.Style.Conservative)
			}
			if periodType {
				delegate?.optionalParamPeriodValueChanged(StrategyBean.Period.Long)
			}
		case 1:
			self.secondBtn.enabled = false
			if styleType {
					delegate?.optionalParamStyleValueChanged(StrategyBean.Style.Radicalness)
			}
			if periodType {
				delegate?.optionalParamPeriodValueChanged(StrategyBean.Period.Middle)
			}
		case 2:
			self.thirdBtn.enabled = false
			if periodType {
				delegate?.optionalParamPeriodValueChanged(StrategyBean.Period.Short)
			}
		default:
			print("")
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

}
