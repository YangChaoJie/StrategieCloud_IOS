//
//  AdaptiveOptionalCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol AdaptiveOptionalCellProtocol: class {
	func setSwithBtnState(on: Bool)
}

protocol AdaptiveOptionalCellDelegate: class {
	func adaptiveSwitchValueChanged(on: Bool)
}

class AdaptiveOptionalCell: UITableViewCell, AdaptiveOptionalCellProtocol {

	@IBOutlet weak var switchBtn: SevenSwitch!
	
	weak var delegate: AdaptiveOptionalCellDelegate?
	
	// MARK: -AdaptiveOptionalCellProtocol
	func setSwithBtnState(on: Bool) {
		switchBtn.on = on
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func switchValueChanged(sender: SevenSwitch) {
		delegate?.adaptiveSwitchValueChanged(sender.on)
	}
}
