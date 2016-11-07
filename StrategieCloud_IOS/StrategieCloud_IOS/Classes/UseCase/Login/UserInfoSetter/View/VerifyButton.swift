//
//  VerifyButton.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/30.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol VerifyButtonDelegate: class {
	func verifyButtonClick(verifyBtn: VerifyButton)
}

class VerifyButton: UIButton {

	weak var delegate: VerifyButtonDelegate?
	
	private static let TotalCount = Int(60)
	
	private var timer: NSTimer?
	private var timeCount = TotalCount
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.cornerRadius = 4
		backgroundColor = UIColor.orangeColor()
		setTitle("获取验证码", forState: UIControlState.Normal)
		setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		setTitleColor(UIColor.whiteColor(), forState: UIControlState.Disabled)
		titleLabel?.font = UIFont.systemFontOfSize(14)
		addTarget(self, action: #selector(VerifyButton.buttonClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	
	
	func verifyButtonStartTimer() {
		print(#function)
		// 开启定时器
		self.enabled = false
		self.backgroundColor = UIColor.colorWith(189, green: 203, blue: 224, alpha: 1.0)
		self.timer = NSTimer.init(timeInterval: 1.0, target: self, selector: #selector(showLastTime), userInfo: nil, repeats: true)
		self.timer?.fireDate = NSDate.distantPast()
		NSRunLoop.mainRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
		
	}
	
	@objc private func buttonClick(sender: UIButton) {
		delegate?.verifyButtonClick(self)
	}
	
	@objc private func showLastTime()  {
		if timeCount <= 0 {
			if ((timer?.valid) != nil) {
				timer?.invalidate()
			}
			timer = nil
			timeCount = VerifyButton.TotalCount
			self.enabled = true
			backgroundColor = UIColor.orangeColor()
			setTitle("获取验证码", forState: UIControlState.Normal)
		  return
		}
		let str : String = String(timeCount) +  "S"
		self.setTitle(str, forState: .Disabled)
		timeCount = timeCount - 1
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
