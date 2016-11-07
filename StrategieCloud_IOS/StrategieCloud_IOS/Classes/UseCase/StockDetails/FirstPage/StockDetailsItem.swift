//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation

class StockDetailsItem: ResponseObjectSerializable
{
	private enum Status: Int {
		case Stop = 401
		case Rise = 402
		case Fall = 403
		
		func color() -> UIColor {
			switch self {
			case .Stop:
				return UIColor.TextHintColor()
			case .Rise:
				return UIColor.TextUpColor()
			case .Fall:
				return UIColor.TextDownColor()
			}
		}
	}
	private let ShortLine = "--"
	
//	var openPrice: String = ""		//开盘价
//	var prevClosePrice: String = ""	//昨收价
	var shortNM: String 		//股票名称
	private var status: Int //状态, 401停牌, 402上涨，403下跌
	var ticker: String	//代码
	
	
	
	//最新价
	var revLastPrice: NSMutableAttributedString {
		get {
			let _lastPrice = Converts.strFromDecimalPlacesStr(lastPrice)
			let length = (_lastPrice as NSString).length
			let mutableAttrStr = NSMutableAttributedString(string: _lastPrice)
			mutableAttrStr.addAttributes([NSForegroundColorAttributeName: (Status.init(rawValue: self.status)?.color())!], range: NSMakeRange(0, length))
			return mutableAttrStr
		}
	}
	
	//涨跌 涨幅
	var revChange: NSMutableAttributedString {
		get {
			var str = String("")
			if status == Status.Stop.rawValue {
				str = "停牌"
			} else {
				let change = Converts.strFromDecimalPlacesStr(self.change)
				let changePct = Converts.percentStrFromDecimalPlacesStr(self.changePct)
				str = change + " " + changePct
			}

			let length = (str as NSString).length
			let mutableAttrStr = NSMutableAttributedString(string: str)
			mutableAttrStr.addAttributes([NSForegroundColorAttributeName: (Status.init(rawValue: self.status)?.color())!], range: NSMakeRange(0, length))
			return mutableAttrStr
		}
	}
	
	//成交量
	var revVolume: NSMutableAttributedString {
		get {
			var _volume = self.volume
			if let volume = self.volume {
				if self.ticker != "sh000001" {
					_volume = "\((volume as NSString).floatValue / 100)"
				}
			}

			let volumeStr = Converts.unitConvert(_volume)
			let length = (volumeStr as NSString).length
			let mutableAttrStr = NSMutableAttributedString(string: volumeStr)
			mutableAttrStr.addAttributes([NSForegroundColorAttributeName: Status.Stop.color()], range: NSMakeRange(0, length))
			return mutableAttrStr
		}
	}
	
	var revHighPrice: NSMutableAttributedString {
		get {
			let _highPrice = Converts.strFromDecimalPlacesStr(highPrice)
			let mutableAttrStr = NSMutableAttributedString(string: _highPrice)
			return mutableAttrStr
		}
	}

	var revLowPrice: NSMutableAttributedString {
		get {
			let _lowPrice = Converts.strFromDecimalPlacesStr(lowPrice)
			let mutableAttrStr = NSMutableAttributedString(string: _lowPrice)
			return mutableAttrStr
		}
	}
	
	var revTurnoverRate: NSMutableAttributedString {
		get {
			let _rate = Converts.percentStrFromDecimalPlacesStr(turnoverRate, withPlus: false)
			let mutableAttrStr = NSMutableAttributedString(string: _rate)
			return mutableAttrStr
		}
	}
	
	var revAmplitude: NSMutableAttributedString {
		get {
			let _amplitude = Converts.percentStrFromDecimalPlacesStr(amplitude, withPlus: false)
			let mutableAttrStr = NSMutableAttributedString(string: _amplitude)
			return mutableAttrStr
		}
	}
	
	var revStaticPE: NSMutableAttributedString {
		get {
			let _staticPE = Converts.strFromDecimalPlacesStr(staticPE)
			let mutableAttrStr = NSMutableAttributedString(string: _staticPE)
			return mutableAttrStr
		}
	}
	
	var revValue: NSMutableAttributedString {
		get {
			let _value = Converts.unitConvert(value)
			let mutableAttrStr = NSMutableAttributedString(string: _value)
			return mutableAttrStr
		}
	}
	
	var revNegMarketValue: NSMutableAttributedString {
		get {
			let _negmarketvalue = Converts.unitConvert(negMarketValue)
			let mutableAttrStr = NSMutableAttributedString(string: _negmarketvalue)
			return mutableAttrStr
		}
	}
	
	private var lastPrice: String?
	private var change: String?
	private var changePct: String?
	private var volume: String?		//成交量
	private var highPrice: String?	//最高价
	private var lowPrice: String?	//最低价
	private var turnoverRate: String?	//换手率
	private var amplitude: String? 	//振幅
	private var staticPE: String?		//静态市盈率
	private var value: String?			//成交额
	private var negMarketValue: String?	//流通市值
	
	required init?(response: NSHTTPURLResponse, representation: AnyObject) {
		self.shortNM = representation.valueForKeyPath("data.shortNM") as? String ?? ""
		self.ticker = representation.valueForKeyPath("data.ticker") as? String ?? ""
		self.status = representation.valueForKeyPath("data.status") as? Int ?? 402
		self.lastPrice = representation.valueForKeyPath("data.lastPrice") as? String
		self.change = representation.valueForKeyPath("data.change") as? String
		self.changePct = representation.valueForKeyPath("data.changePct") as? String
		self.volume = representation.valueForKeyPath("data.volume") as? String
		self.highPrice = representation.valueForKeyPath("data.highPrice") as? String
		self.lowPrice = representation.valueForKeyPath("data.lowPrice") as? String
		self.turnoverRate = representation.valueForKeyPath("data.turnoverRate") as? String
		self.amplitude = representation.valueForKeyPath("data.amplitude") as? String
		self.staticPE = representation.valueForKeyPath("data.staticPE") as? String
		self.value = representation.valueForKeyPath("data.value") as? String
		self.negMarketValue = representation.valueForKeyPath("data.negMarketValue") as? String
	}
}