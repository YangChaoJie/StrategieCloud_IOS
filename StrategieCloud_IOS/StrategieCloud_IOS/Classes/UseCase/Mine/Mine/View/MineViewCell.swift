//
//  MineViewCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol MineViewCellDataSource: class {
	func setTitle(title: String)
	func setImg(img: UIImage?)
	func setSubTitle(subTitle: String)
}

class MineViewCell: UITableViewCell, MineViewCellDataSource {
	@IBOutlet weak var setImg: UIImageView!
	@IBOutlet weak var setTitleLab: UILabel!
	@IBOutlet weak var rightArrowImg: UIImageView!
	@IBOutlet weak var rightDetailLab: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	func setTitle(title: String) {
		self.setTitleLab.text = title
	}

	func setImg(img: UIImage?) {
		self.setImg.image = img
	}
	
	func setSubTitle(subTitle: String) {
		self.rightArrowImg.hidden = true
		self.rightDetailLab.hidden = false
		self.rightDetailLab.text = subTitle
	}
}
