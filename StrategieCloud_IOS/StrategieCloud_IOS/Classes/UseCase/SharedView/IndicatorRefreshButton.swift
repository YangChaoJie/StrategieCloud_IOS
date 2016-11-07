//
//  IndicatorButton.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/8/4.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit


protocol IndicatorRefreshBtnDelegate: class {
	func indicatorBtnClickRefresh(btn: IndicatorRefreshButton)
}

class IndicatorRefreshButton: UIButton {
	
	weak var delegate: IndicatorRefreshBtnDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(indicator)
		indicator.hidesWhenStopped = true
		setImage(UIImage(named: "iconfont-shuaxin"), forState: .Normal)
		setImage(UIImage(named: "iconfont-shuaxin"), forState: .Highlighted)
		addTarget(self, action: #selector(IndicatorRefreshButton.indicatorBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	@objc private func indicatorBtnClick(sender: UIButton) {
		startRefresh()
		delegate?.indicatorBtnClickRefresh(self)
	}
	
	func startRefresh() {
		setImage(nil, forState: UIControlState.Normal)
		indicator.startAnimating()
	}
	
	func stopRefresh() {
		indicator.stopAnimating()
		setImage(UIImage(named: "iconfont-shuaxin"), forState: .Normal)
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var indicator: UIActivityIndicatorView = {
		let _indicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, self.bounds.width, self.bounds.height))
		return _indicator
	}()
}
