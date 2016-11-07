//
//  DataFrameJson.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/19.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

struct DataFrameJson {

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

		if let data_ = dic["data"] as? [[Double]] {
			self.data = data_
		}
	}

	func indexCountEqualDataCount() -> Bool {
		if let _ = self.columns {
			if let index_ = index, data_ = data {
				if index_.count == data_.count {
					return true
				}
			}
		}

		return false
	}
}