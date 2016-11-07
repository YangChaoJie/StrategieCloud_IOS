//
//  RoughStock.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/18.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

struct RoughStock {
	
	let name: String
	let code: String
	var aowID: Int? = nil
	
	init(name: String, code: String, aowID: Int? = nil) {
		self.name = name
		self.code = code
		self.aowID = aowID
	}
}