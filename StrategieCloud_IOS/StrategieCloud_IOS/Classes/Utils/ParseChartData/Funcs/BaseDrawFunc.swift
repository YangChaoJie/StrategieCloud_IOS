//
//  BaseDrawFunc.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/23.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

protocol BaseDrawFunc {
	var chartData: CombinedChartData? { get }
	var indexs: [String]? { get }
	init(jsonDic: NSDictionary, withIndex index: Int)
	func color(colorStr: String?, index: Int) -> UIColor

	var maxTimeSharedDataCount: Int { get }
}

extension BaseDrawFunc {
	func color(colorStr: String?, index: Int) -> UIColor {
//		if let colorStr_ = colorStr {
//			let captureStr = self.stringCapture(colorStr_)
//			if self.isStringRGBHex(captureStr.second) {
//				//自定义rgb
//				return self.colorWithHexString(captureStr.second)
//			} else {
//				if let str = DrawFeatureEnum.DrawColor(rawValue: captureStr.second) {
//					return str.colorValue()
//				}
//			}
//		} else {
			if let colorIndex = DrawFeatureEnum.DrawColorIndex(rawValue: index) {
				return colorIndex.value()
			}
//		}
		return UIColor.lightGrayColor()
	}

	private func stringCapture(colorKey: String) -> (first: String, second: String) {
		let firstFiledCount = Int(5)
		let tempColorKey = colorKey as NSString
		let firstStr = tempColorKey.substringToIndex(firstFiledCount)
		let secondStr = tempColorKey.substringFromIndex(firstFiledCount)
		return (firstStr, secondStr)
	}

	private func isStringRGBHex(color: String) -> Bool {
		let regex = "^[0-9a-fA-F]{3,6}$"
		let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
		return predicate.evaluateWithObject(color)
	}

	private func colorWithHexString(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
		let hexInt = Int(self.intFromHexString(hexString))
		let red = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hexInt & 0xFF00) >> 8) / 255.0
		let blue = CGFloat((hexInt & 0xFF) >> 0) / 255.0
		return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
	}
	
	private func intFromHexString(hexStr: String) -> UInt32 {
		var hexInt: UInt32 = 0
		let scanner: NSScanner = NSScanner(string: hexStr)
		scanner.scanHexInt(&hexInt)
		return hexInt
	}
	

	var maxTimeSharedDataCount: Int {
		return 239
	}
}