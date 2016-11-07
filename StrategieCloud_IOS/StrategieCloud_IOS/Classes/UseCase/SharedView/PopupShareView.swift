//
//  PopupShareView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/8/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol PopupShareViewDelegate: class {
	func popupShareViewShare(platformType: PopupShareView.PlatformType)
}

class PopupShareView: UIView {
    
    @IBOutlet weak var zoneBtn: UIButton!
    @IBOutlet weak var qqBtn: UIButton!
    @IBOutlet weak var wxFriendBtn: UIButton!
    
    @IBOutlet weak var friendsBtn: UIButton!
	enum ShareContentType {
		case App
		case StockDetail
	}
	
	enum PlatformType: Int {
		case WXfriend = 0
		case WXCircleFriend = 1
		case QQfriend = 2
		case QQZone = 3
	}
	
	weak var delegate: PopupShareViewDelegate?
	private var mShareType: ShareContentType
	
	@IBAction func btnClick(sender: UIButton) {
		if let type = PlatformType(rawValue: sender.tag) {
			switch type {
			case .QQfriend, .QQZone:
				if !UIApplication.sharedApplication().canOpenURL(NSURL(string: "mqqapi://")!) {
					return
				}
			case .WXCircleFriend, .WXfriend:
				if !UIApplication.sharedApplication().canOpenURL(NSURL(string: "weixin://")!) {
					return
				}
			}
			delegate?.popupShareViewShare(type)
		}
		if sender.tag == 4 {
			closeView()
		}
	}
    
    func judgmentToInstallApp() {
        if !UIApplication.sharedApplication().canOpenURL(NSURL(string: "mqqapi://")!) {
            self.qqBtn.enabled = false
            self.zoneBtn.enabled = false
        }
        
        if !UIApplication.sharedApplication().canOpenURL(NSURL(string: "weixin://")!) {
            self.wxFriendBtn.enabled = false
            self.friendsBtn.enabled = false
        }
    }
	
	func show() {
		self.superview?.insertSubview(bgBtn, belowSubview: self)
		UIView.animateWithDuration(0.2, animations: { () -> Void in
			self.frame.origin.y -= self.frame.size.height
		})
	}
	
	private lazy var bgBtn: UIButton = {
		let _bgBtn = UIButton(frame: CGRectMake(0, 0, AppWidth, AppHeight))
		_bgBtn.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
		_bgBtn.addTarget(self, action: #selector(PopupShareView.closeView), forControlEvents: UIControlEvents.TouchUpInside)
		return _bgBtn
	}()
	
	
	@objc private func closeView() {
		bgBtn.removeFromSuperview()
		UIView.animateWithDuration(0.2, animations: {
			self.frame.origin.y = AppHeight
		}) { (_) in
			self.removeFromSuperview()
		}
	}
	

	@IBOutlet var view: UIView!
	
	init(frame: CGRect, shareType: ShareContentType = ShareContentType.App) {
		mShareType = shareType
		super.init(frame: frame)
		nibSetup()
        judgmentToInstallApp()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
