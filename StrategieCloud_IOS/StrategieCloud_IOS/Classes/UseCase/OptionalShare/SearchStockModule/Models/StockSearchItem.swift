//
//  StockSearchItem.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

struct StockSearchItem {
	let name: String
	let code: String
	var optionalShare = false
	
	init(name: String, code: String) {
		self.name = name
		self.code = code
	}
	
	mutating func setOptionalShare(optionalShare: Bool) {
		self.optionalShare = optionalShare
	}
}
