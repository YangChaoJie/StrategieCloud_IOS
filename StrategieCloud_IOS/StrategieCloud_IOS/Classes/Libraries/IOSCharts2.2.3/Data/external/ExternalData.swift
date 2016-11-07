//
//  ExternalData.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/8.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

public class ExternalData: NSObject {
	var name: String = ""
	var value: String = ""
	var color: UIColor = UIColor.lightGrayColor()
	
	override init() {
		super.init()
	}
	
	convenience init(name: String, value: String, color: UIColor) {
		self.init()
		self.name = name
		self.value = value
		self.color = color
	}
}