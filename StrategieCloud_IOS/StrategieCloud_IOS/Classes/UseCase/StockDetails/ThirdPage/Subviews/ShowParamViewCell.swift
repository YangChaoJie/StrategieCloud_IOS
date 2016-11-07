//
//  ShowParamViewCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol ShowParamViewCellDataSource: class {
	func setTitleForStyle(style: StrategyBean.Style)
	func setTitleForPeriod(period: StrategyBean.Period)
}

class ShowParamViewCell: UITableViewCell, ShowParamViewCellDataSource {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var firstLabel: UILabel!
	@IBOutlet weak var secondLabel: UILabel!
	@IBOutlet weak var thirdLabel: UILabel!
	
	func setTitleForStyle(style: StrategyBean.Style) {
		titleLabel.text = "风格选择"
		thirdLabel.hidden = true
		
		firstLabel.text = style.desc()
		
		switch style {
		case .Conservative:
			secondLabel.text = StrategyBean.Style.Radicalness.desc()
		case .Radicalness:
			secondLabel.text = StrategyBean.Style.Conservative.desc()
		}
	}
	
	func setTitleForPeriod(period: StrategyBean.Period) {
		titleLabel.text = "周期选择"
		thirdLabel.hidden = false
		
		firstLabel.text = period.desc()
		switch period {
		case .Long:
			secondLabel.text = StrategyBean.Period.Middle.desc()
			thirdLabel.text = StrategyBean.Period.Short.desc()
		case .Middle:
			secondLabel.text = StrategyBean.Period.Long.desc()
			thirdLabel.text = StrategyBean.Period.Short.desc()
		case .Short:
			secondLabel.text = StrategyBean.Period.Long.desc()
			thirdLabel.text = StrategyBean.Period.Middle.desc()
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
