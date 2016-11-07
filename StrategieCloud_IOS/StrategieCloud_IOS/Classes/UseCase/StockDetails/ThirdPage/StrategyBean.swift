//
//  StrategyBean.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class StrategyBean: ResponseObjectSerializable {
	
	enum Style: Int {
		case Conservative = 701	//保守
		case Radicalness = 702	//激进
		
		func desc() -> String {
			switch self {
			case .Conservative:	return "保守"
			case .Radicalness:	return "激进"
			}
		}
	}
	
	enum Period: Int {
		case Long = 721
		case Middle = 722
		case Short = 723
		
		func desc() -> String {
			switch self {
			case .Long:		return "长线"
			case .Middle:	return "中线"
			case .Short:	return "短线"
			}
		}
	}
	
	enum Adaptor: Int {
		case On = 741
		case Off = 742
	}
	
	var adaptor: Adaptor {
		get {
			if let _adaptor = self._adaptor {
				return Adaptor(rawValue: _adaptor)!
			} else {
				return Adaptor.Off
			}
		}
		set {
			_adaptor = newValue.rawValue
		}
	}
	
	var style: Style {
		get {
			if let _style = self._style {
				return Style(rawValue: _style)!
			} else {
				return Style.Conservative
			}
		}
		set {
			_style = newValue.rawValue
		}
	}
	
	var period: Period {
		get {
			if let _period = self._period {
				return Period(rawValue: _period)!
			} else {
				return Period.Long
			}
		}
		set {
			_period = newValue.rawValue
		}
	}
	
	var applySwitch: Bool {
		get {
			return _applySwitch ?? false
		}
		set {
			_applySwitch = newValue
		}
	}
	
	var recommendIdx: Int {
		get {
			if let _recommendIdx = self._recommendIdx {
				return _recommendIdx
			} else {
				return 0
			}
		}
		set {
			_recommendIdx = newValue
		}
	}
	
	var dataform: String? {
		get {
			if let _dataform = _dataform {
				if _dataform.isEmpty { return nil }
				return _dataform
			}
			return nil
		}
		set {
			_dataform = newValue
		}
	}
	
	
	var profit10: Float?
	var profit60: Float?
	var profit250: Float?
	var totalProfit: Float?
	private var _dataform: String?
	private var _recommendIdx: Int?
	private var _adaptor: Int?
	private var _style: Int?
	private var _period: Int?
	private var _applySwitch: Bool?
	
	required init?(response: NSHTTPURLResponse, representation: AnyObject) {
		self.profit10 = representation.valueForKeyPath("data.profit_10") as? Float
		self.profit60 = representation.valueForKeyPath("data.profit_60") as? Float
		self.profit250 = representation.valueForKeyPath("data.profit_250") as? Float
		self.totalProfit = representation.valueForKeyPath("data.total_profit") as? Float
		self.dataform = representation.valueForKeyPath("data.dataform") as? String
		self._adaptor = representation.valueForKeyPath("data.adaptor") as? Int
		self._style = representation.valueForKeyPath("data.style") as? Int
		self._period = representation.valueForKeyPath("data.period") as? Int
		self._recommendIdx = representation.valueForKeyPath("data.recommend_idx") as? Int
		self._applySwitch = representation.valueForKeyPath("data.aow_switch") as? Bool
		
	}
	
	init() {}
}