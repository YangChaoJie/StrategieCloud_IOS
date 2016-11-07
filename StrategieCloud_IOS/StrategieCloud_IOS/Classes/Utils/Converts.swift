//
//  Converts.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class Converts {
	static func serializationStringToDics(str: String) -> [NSDictionary]? {
		let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
		do {
			if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [NSDictionary] {
				return json
			}
		} catch {}
		return nil
	}
	
	static func serializationStringToDic(str: String) -> NSDictionary? {
		let data = str.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
		do {
			if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
				return json
			}
		} catch {}
		return nil
	}
	
	static func strFromDecimalPlacesStr(str: String?) -> String {
		if let _str = str {
			if _str == "--" {
				return "--"
			}
			let val = (_str as NSString).floatValue
			return String(format: "%.2f", val)
		}
		return "--"
	}
	
	static func percentStrFromDecimalPlacesStr(str: String?, withPlus plus: Bool = true) -> String {
		if let _str = str {
			let val = (_str as NSString).floatValue * 100
			var retStr = String(format: "%.2f", val)
			if (val >= 0 && plus) {
				retStr = "+\(retStr)"
			}
			return retStr + "%"
		}
		return "--"
	}
	
	static func percentStrFromDecimalPlacesFloat(val: Float) -> String {
		let value = val * 100
		let retStr = (value >= 0) ? String(format: "+%.2f", value) : String(format: "%.2f", value)
		return retStr + "%"
	}
	
	static func strFromDecimalPlacesDouble(val: Double) -> String {
		return String(format: "%.2f", val)
	}
	
	static func unitConvert(str: String?) -> String {
		if let _str = str {
			let WAN = Double(10000)
			let QianWAN = Double(10000000)
			let YI = Double(100000000)
			
			let val = (_str as NSString).doubleValue
			
			if val >= YI {
				let retVal = Converts.strFromDecimalPlacesDouble(val/YI)
				return "\(retVal)亿"
			} else if val >= QianWAN {
				let retVal = Converts.strFromDecimalPlacesDouble(val/QianWAN)
				return "\(retVal)千万"
			} else if val >= WAN {
				let retVal = Converts.strFromDecimalPlacesDouble(val/WAN)
				return "\(retVal)万"
			} else {
				return "\(val)"
			}
		}
		return "--"
	}
}