//
//  StockTitleView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol StockTitleViewDelegate: class {
	func stockTitleViewNext()
	func stockTitleViewPreviou()
}

class StockTitleView: UIView {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var codeLabel: UILabel!

	weak var delegate: StockTitleViewDelegate?
	@IBOutlet weak var prevBtn: UIButton!
	@IBOutlet weak var nextBtn: UIButton!
	
	@IBAction func previouBtnClick() {
		delegate?.stockTitleViewPreviou()
	}
	
	@IBAction func nextBtnClick() {
		delegate?.stockTitleViewNext()
	}
	
	func showPrevNextBtn(show: Bool) {
		prevBtn.hidden = !show
		nextBtn.hidden = !show
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