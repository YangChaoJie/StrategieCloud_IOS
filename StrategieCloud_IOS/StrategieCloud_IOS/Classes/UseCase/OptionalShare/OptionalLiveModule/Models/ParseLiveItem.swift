//
//  ParseLiveItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
public struct ParseLiveItem {
	
	public enum MsgColorType: Int {
		case Normal = 20
		case Rise = 21
		case Fall = 22
		case Stock = 23
		
		func color() -> UIColor {
			switch self {
			case .Normal:	return UIColor.TabBarNormalColor()
			case .Rise:		return UIColor.colorWith(253, green: 37, blue: 0, alpha: 100)
			case .Fall:		return UIColor.colorWith(15, green: 199, blue: 15, alpha: 100)
			case .Stock:	return UIColor.NavBarColor()
			}
		}
	}
	
	var showMsg: String = ""
	var msgTextList = [MsgTextBean]()
	
	public init(msg: String) {
		var spaceArray = [String]()
		let itemStr = msg.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		for item in itemStr {
			let range1 = (item as NSString).rangeOfString("{")
			let range2 = (item as NSString).rangeOfString("}")
			
			if (range1.location != NSNotFound) {
				let loc = range1.location
				let length = range2.location - range1.location
				
				let range = NSRange(location: loc, length: length + 1)
				let message = (item as NSString).stringByReplacingCharactersInRange(range, withString: "")
				spaceArray.append(message)
				
				
				let beforeBraceText = (item as NSString).substringToIndex(loc)
				let inBraceRange = NSRange(location: loc + 1, length: length - 1)
				let inBraceText = (item as NSString).substringWithRange(inBraceRange)
				
				
				let colorNum = (inBraceText as NSString).integerValue
				if colorNum != 0 {
					// color
					if let colorType = MsgColorType(rawValue: colorNum) {
						let bean = MsgTextBean(text: beforeBraceText, ticker: nil, color: colorType.color(), clickable: false)
						msgTextList.append(bean)
					}
				} else {
					// ticker
					let bean = MsgTextBean(text: beforeBraceText, ticker: inBraceText, color: MsgColorType.Stock.color(), clickable: true)
					msgTextList.append(bean)
				}
			}
		}
		showMsg = spaceArray.joinWithSeparator("")
	}
}