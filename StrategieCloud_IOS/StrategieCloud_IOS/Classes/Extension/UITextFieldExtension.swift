//
//  UITextFieldExtension.swift
//  hangge_1096
//
//  Created by hangge on 16/3/23.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit
extension UITextView {

	func handleStyle(msgTextList: [MsgTextBean]) {
		let attrString = NSMutableAttributedString(string: self.text, attributes: [NSFontAttributeName: self.font!,NSForegroundColorAttributeName: UIColor.TabBarNormalColor()])
		for bean in msgTextList {
			if bean.clickable {
				if let ticker = bean.ticker {
					attrString.addAttribute(NSLinkAttributeName, value: "ticker:\(ticker)", range: (self.text as NSString).rangeOfString(bean.text))
				}
			} else {
				let addedAttrs = [NSForegroundColorAttributeName: bean.color, NSUnderlineStyleAttributeName: 0]
				attrString.addAttributes(addedAttrs, range: (self.text as NSString).rangeOfString(bean.text))
			}
		}
		self.linkTextAttributes = [NSForegroundColorAttributeName: ParseLiveItem.MsgColorType.Stock.color(), NSBackgroundColorAttributeName: UIColor.clearColor(), NSUnderlineStyleAttributeName: 0]
		self.attributedText = attrString
	}
}