//
//  BackTestBean.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

public struct BackTestBean {

	public enum ColumnsName: String {
		case Asset = "ASSET"
		case Base = "BASE"
		case Signal = "SIGNAL"
		case Position = "POSITION"
	}
	
	public enum Signal: Double {
		case None
		case Buy
		case Sell
	}
	
	public var chartColumns: [String] {
		get {
			if let columns = self._columns {
				return columns
			}
			return []
		}
	}
	
	public var chartData: [[Double]] {
		get {
			if let chartData = self._chartData {
				return chartData
			}
			return [[]]
		}
	}
	
	public var chartIndex: [String] {
		get {
			if let chartIndex = self._indexs {
				return chartIndex
			}
			return []
		}
	}
	

	private var _columns: [String]?
	private var _chartData: [[Double]]?
	private var _indexs: [String]?

	init?(data: String?) {
		if let data = data {
            print("曲线图数据是\(data)")
			if !data.isEmpty {
				if let _data = data.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true) {
					do {
						if let json = try NSJSONSerialization.JSONObjectWithData(_data, options: []) as? NSDictionary {
							
							if let _columns = json["columns"] as? [String] {
								self._columns = _columns
							}
							
							if let _chartData = json["data"] as? [[Double]] {
								self._chartData = _chartData
							}
							
							if let _indexs = json["index"] as? [String] {
								self._indexs = _indexs
							}
						}
					} catch {
						print("数据转换失败")
						return nil
					}
				}
			}
		}
	}
	
	func getDataIndex(byName name: ColumnsName) -> Int {
		if let _columns = _columns {
			for i in 0 ..< _columns.count {
				if _columns[i] == name.rawValue {
					return i
				}
			}
		}
		return 0
	}
}