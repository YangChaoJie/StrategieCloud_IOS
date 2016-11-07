//
//  StartTestViewCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol StartTestViewCellDelegate: class {
	func startTestClick()
}

protocol StartTestViewCellProcotol: class {
	func startTestViewShow(show: Bool)
}

class StartTestViewCell: UITableViewCell, StartTestViewCellProcotol {

	weak var delegate: StartTestViewCellDelegate?
	
	@IBOutlet weak var hintImg: UIImageView!
	@IBOutlet weak var startTestBtn: UIButton!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	@IBAction func startTestClick(sender: AnyObject) {
		delegate?.startTestClick()
	}
	
	func startTestViewShow(show: Bool) {
		hintImg.hidden = !show
		startTestBtn.hidden = !show
	}
}
