//
//  TimeSharingTopInfoView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol TimeSharingTopInfoViewDelegate: class {
	func timeSharingTopInfoViewShowOrHide(show: Bool)
}

@IBDesignable
class TimeSharingTopInfoView: UIView {
	
	@IBOutlet weak var arrowBtn: UIButton!
	weak var delegate: TimeSharingTopInfoViewDelegate?
	
	
	@IBOutlet weak var latestPriceLabel: UILabel!
	@IBOutlet weak var changeAndChangepctLabel: UILabel!
	@IBOutlet weak var volumeLabel: UILabel!
	@IBOutlet weak var turnoverRateLabel: UILabel!
	@IBOutlet weak var highPriceLabel: UILabel!
	@IBOutlet weak var lowPriceLabel: UILabel!
	
	
	@IBAction func arrowBtnClick() {
		UIView.beginAnimations("rotate", context: nil)
		UIView.setAnimationDuration(0.25)
		if CGAffineTransformEqualToTransform((arrowBtn.imageView?.transform)!, CGAffineTransformIdentity) {
			arrowBtn.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
			delegate?.timeSharingTopInfoViewShowOrHide(true)
			
		} else {
			arrowBtn.imageView?.transform = CGAffineTransformIdentity
			
			delegate?.timeSharingTopInfoViewShowOrHide(false)
		}
		UIView.commitAnimations()
	}
	
	func returnToTransformIdentity() {
		UIView.beginAnimations("rotate", context: nil)
		UIView.setAnimationDuration(0.25)
		delegate?.timeSharingTopInfoViewShowOrHide(false)
		arrowBtn.imageView?.transform = CGAffineTransformIdentity
		UIView.commitAnimations()
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
