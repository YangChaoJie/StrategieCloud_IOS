//
//  TopDisplayInfoView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class TopDisplayInfoView: BaseTopInfoView {

	@IBOutlet weak var firstLabel: UILabel!
	@IBOutlet weak var secondLabel: UILabel!
	@IBOutlet weak var thirdLabel: UILabel!

	override func setLabels(datas: [ExternalData]) {
		if datas.count >= 3 {
			thirdLabel.attributedText = convertAttrString(withData: datas[0])
			secondLabel.attributedText = convertAttrString(withData: datas[1])
			firstLabel.attributedText = convertAttrString(withData: datas[2])
		}
	}
	
	private func convertAttrString(withData data: ExternalData) -> NSMutableAttributedString {
		let itemStr = data.name + ":" + data.value
		let str = NSMutableAttributedString(string: itemStr)
		let itemLength = (itemStr as NSString).length
		
		str.addAttribute(NSForegroundColorAttributeName, value: data.color, range: NSMakeRange(0, itemLength))
		return str
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
