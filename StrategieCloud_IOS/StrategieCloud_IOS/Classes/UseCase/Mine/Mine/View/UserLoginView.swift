//
//  UserLoginView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol UserLoginViewDelegate: class {
	func userLoginViewDelegateClick()
}

protocol UserLoginViewDataSource: class {
	func userLoginView(nickName nickName: String?)
	func userLoginView(avatarImg avatarImg: UIImage?)
}

class UserLoginView: UIView, UserLoginViewDataSource {
	
	@IBOutlet weak var avatarImg: UIImageView!
	@IBOutlet weak var nickNameLabel: UILabel!
	
	weak var delegate: UserLoginViewDelegate?
	
	private func commonInit() {
		avatarImg.layer.cornerRadius = avatarImg.size.width/2
		avatarImg.layer.borderWidth = CGFloat(2)
		avatarImg.layer.borderColor = UIColor.whiteColor().CGColor
		avatarImg.clipsToBounds = true
		avatarImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserLoginView.avatarClick)))
	}
	
	func avatarClick() {
		delegate?.userLoginViewDelegateClick()
	}
	
	// MARK: -UserLoginViewDataSource
	func userLoginView(nickName nickName: String?) {
		if let nickName = nickName {
			self.nickNameLabel.text = nickName
		} else {
			self.nickNameLabel.text = "未登录"
		}
	}
	
	func userLoginView(avatarImg avatarImg: UIImage?) {
		self.avatarImg.image = avatarImg
	}
	
	
	@IBOutlet var view: UIView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		nibSetup()
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		nibSetup()
		commonInit()
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
