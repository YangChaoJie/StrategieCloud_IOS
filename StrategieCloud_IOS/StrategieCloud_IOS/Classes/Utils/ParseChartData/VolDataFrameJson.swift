//
//  VolDataFrameJson.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/10/19.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

struct VolDataFrameJson {
	var columns: [String]?
	var index: [String]?
	var data: [[Double]]?

	init(dic: NSDictionary) {
		if let columns_ = dic["columns"] as? [String] {
			self.columns = columns_
		}

		if let index_ = dic["index"] as? [String] {
			self.index = index_
		}

		if let tempData = dic["data"] as? [[AnyObject]] {
			data = [[Double]]()
			for itemData in tempData {
				if let data_ = itemData as? [Double] {
					data?.append(data_)
				} else {
					data!.append([-1, 0])
				}
			}
		}
	}
}