//
//  SysUtils.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/8/3.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class SysUtils {
	
	class func appVersionNumber() -> String {
		let infoDictionary = NSBundle.mainBundle().infoDictionary
		let majorVersion: AnyObject? = infoDictionary!["CFBundleShortVersionString"]
		return majorVersion as! String
	}
}
