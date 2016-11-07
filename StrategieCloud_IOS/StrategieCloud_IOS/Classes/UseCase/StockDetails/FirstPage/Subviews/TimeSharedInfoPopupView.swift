//
//  PopopView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class TimeSharedInfoPopupView: UIButton {
	
	let InfoViewHeight = CGFloat(48)
	
	var infoView: TimeSharedDetailView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	private func commonInit() {
		self.backgroundColor = UIColor(red: 127/255.0, green: 127/255.0, blue: 127/255.0, alpha: 100/255.0)
		self.alpha = 0
		infoView = TimeSharedDetailView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat(0)))
		self.addSubview(infoView)
	}

	func setDatas(attrStr1: NSMutableAttributedString, attrStr2: NSMutableAttributedString, attrStr3: NSMutableAttributedString, attrStr4: NSMutableAttributedString) {
		infoView.amplitudeLabel.attributedText = attrStr1
		infoView.staticPELabel.attributedText = attrStr2
		infoView.valueLabel.attributedText = attrStr3
		infoView.negMarketValueLabel.attributedText = attrStr4
	}
	
	func setShow(show: Bool) {
		if show {
			self.hidden = false
			UIView.animateWithDuration(0.25, animations: {
				self.alpha = 1.0
				self.infoView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.InfoViewHeight)
			})
		} else {
			UIView.animateWithDuration(0.25, animations: {
				self.alpha = 0
				self.infoView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat(0))
				}, completion: { (_) in
					self.hidden = true
			})
		}
	}
}

