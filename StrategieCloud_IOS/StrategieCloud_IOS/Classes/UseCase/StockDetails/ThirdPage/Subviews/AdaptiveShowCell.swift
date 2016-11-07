//
//  AdaptiveShowCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol AdaptiveShowCellDataSource: class {
	func adaptiveShowCell(on: Bool)
}

class AdaptiveShowCell: UITableViewCell, AdaptiveShowCellDataSource {

	@IBOutlet weak var stateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func adaptiveShowCell(on: Bool) {
		if on {
			stateLabel.text = "已开启"
		} else {
			stateLabel.text = "已关闭"
		}
	}

}
