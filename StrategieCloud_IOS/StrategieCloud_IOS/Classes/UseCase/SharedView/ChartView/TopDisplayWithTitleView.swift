//
//  TopDisplayWithTitleView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class TopDisplayWithTitleView: BaseTopInfoView {
	
	@IBOutlet weak var titleBtn: UIButton!
	@IBOutlet weak var textLabel: UILabel!

	override func setLabels(datas: [ExternalData]) {
		var totalLength = Int(0)
		var dataStr = ""
		let Prefix = "TOPBASIC-"

		for data in datas {
			if !data.name.containsString(Prefix) {
				let itemStr = data.name + ":" + data.value + " "
				dataStr += itemStr
			}
		}
		
		let attrStr = NSMutableAttributedString(string: dataStr)
		
		for data in datas {
			if !data.name.containsString(Prefix) {
				let itemStr = data.name + ":" + data.value + " "
				let itemLength = (itemStr as NSString).length
				attrStr.addAttributes([NSForegroundColorAttributeName: data.color], range: NSMakeRange(totalLength, itemLength))
				totalLength += itemLength
			}
		}
		textLabel.attributedText = attrStr
	}

	@IBOutlet var view: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		nibSetup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		nibSetup()
	}
	
	private func nibSetup() {
		view = loadViewFromNib()
		view.frame = bounds
		view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		view.translatesAutoresizingMaskIntoConstraints = true
		addSubview(view)
	}
	
	private func loadViewFromNib() -> UIView {
		let bundle = NSBundle(forClass: self.dynamicType)
		let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
		let nibView = nib.instantiateWithOwner(self, options: nil).first as! UIView
		
		return nibView
	}
}
