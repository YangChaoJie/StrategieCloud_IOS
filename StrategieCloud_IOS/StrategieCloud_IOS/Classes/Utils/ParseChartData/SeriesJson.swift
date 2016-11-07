//
//  SeriesJson.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/19.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

struct SeriesJson {

	var name: String?
	var index: [String]?
	var data: [Double]?
	var valid: [Bool]?

	init(dic: NSDictionary) {
		if let name_ = dic["name"] as? String {
			self.name = name_
		}
		if let index_ = dic["index"] as? [String] {
			self.index = index_
		}

		if let tempData = dic["data"] as? [AnyObject] {
			valid = [Bool]()
			data = [Double]()
			
			var validIndex = Int(0)
			for item in tempData {
				if let value = item as? Double {
					valid!.append(true)
					data!.append(value)
				} else {
					valid!.append(false)
					data!.append(0)
					validIndex = valid!.count
				}
				
			}

			for index in 0 ..< validIndex {
				if validIndex < data?.count {
					data![index] = data![validIndex]
				}
			}
		}
	}
}

