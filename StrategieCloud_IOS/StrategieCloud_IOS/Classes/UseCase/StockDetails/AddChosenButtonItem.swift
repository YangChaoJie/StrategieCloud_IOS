//
//  AddChosenButtonItem.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/8/5.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol AddChosenButtonItemDelegate: class {
	func addChosenButtonItemClick(button: AddChosenButtonItem)
}

class AddChosenButtonItem: UIBarButtonItem {
	private var customBtn: UIButton!
	weak var delegate: AddChosenButtonItemDelegate?
	override var enabled: Bool {
		didSet {
			if customBtn != nil {
				customBtn.enabled = enabled
			}
		}
	}

	init(frame: CGRect) {
		super.init()
		customBtn = createCustomBtn(frame)
		customView = customBtn
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func createCustomBtn(frame: CGRect) -> UIButton {
		let btn = UIButton()
		btn.frame = frame
		btn.setTitle("加自选", forState: UIControlState.Normal)
		btn.setTitle("已添加", forState: UIControlState.Disabled)
		btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		btn.setTitleColor(UIColor.appBarTintColor(), forState: UIControlState.Disabled)
		btn.setBackgroundImage(UIImage(named: "add_chosen_enable")!, forState: UIControlState.Normal)
		btn.setBackgroundImage(UIImage(named: "add_chosen_enable")!, forState: UIControlState.Highlighted)
		btn.setBackgroundImage(UIImage(named: "add_chosen_disable")!, forState: UIControlState.Disabled)
		btn.titleLabel?.font = UIFont.systemFontOfSize(13)
		btn.addTarget(self, action: #selector(AddChosenButtonItem.addChosenBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		return btn
	}

	@objc private func addChosenBtnClick(sender: UIButton) {
		delegate?.addChosenButtonItemClick(self)
	}
}
