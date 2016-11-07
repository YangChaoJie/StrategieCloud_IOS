//
//  KLineTopInfoView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/12.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol KLineTopInfoViewDelegate: class {
	func bsSwitchOn(on: Bool)
}

class KLineTopInfoView: UIView {

	static let BSSwitchKey = "com.ringear.strategiescloud.bsswitchkey"

	weak var delegate: KLineTopInfoViewDelegate?

	@IBOutlet weak var bsSwitch: SevenSwitch! {
		didSet {
			bsSwitch.onLabel.text = "BS开"
			bsSwitch.offLabel.text = "BS关"
			bsSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(KLineTopInfoView.BSSwitchKey)
		}
	}

	func setBSSwitchEnable(enable: Bool) {
		bsSwitch.enabled = enable
	}

	@IBOutlet weak var firstChangeLabel: UILabel!
	@IBOutlet weak var highLabel: UILabel!
	@IBOutlet weak var lowLabel: UILabel!
	@IBOutlet weak var openLabel: UILabel!


	@IBAction func switchValueChanged(sender: SevenSwitch) {
		NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: KLineTopInfoView.BSSwitchKey)
		NSUserDefaults.standardUserDefaults().synchronize()
		delegate?.bsSwitchOn(sender.on)
	}

	func setFirstChange(data: ExternalData) {
		let changeStr = data.value.componentsSeparatedByString(",")
		let latest = Converts.strFromDecimalPlacesStr(changeStr[0])
		let item = latest + " " + changeStr[1]
		
		let attrStr = NSMutableAttributedString(string: item)
		let latestLength = (latest as NSString).length
		let changeLength = (changeStr[1] as NSString).length
		attrStr.addAttributes([NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: data.color], range: NSMakeRange(0, latestLength))
		attrStr.addAttributes([NSForegroundColorAttributeName: data.color], range: NSMakeRange(latestLength + 1, changeLength))
		firstChangeLabel.attributedText = attrStr
	}
	
	func setHigh(data: ExternalData) {
		let title = "高"
		let value = Converts.strFromDecimalPlacesStr(data.value)
		let item = title + " " + value
		
		let attrStr = NSMutableAttributedString(string: item)
		let titleLength = (title as NSString).length
		let highLength = (value as NSString).length
		attrStr.addAttributes([NSForegroundColorAttributeName: UIColor.TextHintColor()], range: NSMakeRange(0, titleLength))
		attrStr.addAttributes([NSForegroundColorAttributeName: data.color], range: NSMakeRange(titleLength + 1, highLength))
		highLabel.attributedText = attrStr
	}
	
	func setLow(data: ExternalData) {
		let title = "低"
		let value = Converts.strFromDecimalPlacesStr(data.value)
		let item = title + " " + value
		
		let attrStr = NSMutableAttributedString(string: item)
		let titleLength = (title as NSString).length
		let lowLength = (value as NSString).length
		attrStr.addAttributes([NSForegroundColorAttributeName: UIColor.TextHintColor()], range: NSMakeRange(0, titleLength))
		attrStr.addAttributes([NSForegroundColorAttributeName: data.color], range: NSMakeRange(titleLength + 1, lowLength))
		lowLabel.attributedText = attrStr
	}
	
	func setOpen(data: ExternalData) {
		let title = "开"
		let value = Converts.strFromDecimalPlacesStr(data.value)
		let item = title + " " + value
		
		let attrStr = NSMutableAttributedString(string: item)
		let titleLength = (title as NSString).length
		let openLength = (value as NSString).length
		attrStr.addAttributes([NSForegroundColorAttributeName: UIColor.TextHintColor()], range: NSMakeRange(0, titleLength))
		attrStr.addAttributes([NSForegroundColorAttributeName: data.color], range: NSMakeRange(titleLength + 1, openLength))
		openLabel.attributedText = attrStr
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
