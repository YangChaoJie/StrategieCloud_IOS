//
//  OptionalShareModel.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import RealmSwift

class OptionalShareModel: Object {
	
	// v0
	dynamic var id = 0					// 当前行ID
	dynamic var name = ""
	dynamic var code = ""
	dynamic var uploaded = false		//已上传
	dynamic var increase = ""			//涨幅
	dynamic var change = ""				//涨跌
	dynamic var trend  = 501			// 501空；502上升；503轻微上升；504轻微下降；505下降
	dynamic var status = 402			// 402上涨；403下跌；401停牌
	dynamic var price = ""				//最新价
	dynamic var position = 0			//位置

	// v1
    dynamic var isStrategy = false      //策略
	
	override static func indexedProperties() -> [String] {
		return ["id"]
	}
}
