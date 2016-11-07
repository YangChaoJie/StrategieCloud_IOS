//
//  HeaderTitleView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class HeaderTitleView: UITableViewHeaderFooterView {

	@IBOutlet weak var titleLabel: UILabel!
	
	override func awakeFromNib() {
		contentView.backgroundColor = UIColor.whiteColor()
	}

	func setTitle(title: String) {
		titleLabel.text = title
	}
}
