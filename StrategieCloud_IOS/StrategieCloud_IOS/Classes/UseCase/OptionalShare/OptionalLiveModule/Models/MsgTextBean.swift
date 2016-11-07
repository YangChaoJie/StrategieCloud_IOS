//
//  MsgTextBean.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/10/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

struct MsgTextBean {
	
	var ticker: String?
	var text: String
	var color: UIColor
	var clickable: Bool
	
	init(text: String, ticker: String?, color: UIColor, clickable: Bool) {
		self.text = text
		self.ticker = ticker
		self.color = color
		self.clickable = clickable
	}
}