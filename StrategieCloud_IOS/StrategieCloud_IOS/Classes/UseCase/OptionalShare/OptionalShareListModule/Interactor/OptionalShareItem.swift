//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation

final  class OptionalItem: ResponseObjectSerializable, ResponseCollectionSerializableData {

	var stockName: String
	var stockCode: String
    var change: String
    var trend: Int
    var status: Int
    var changePct: String
    var lastPrice: String
	var position = Int(0)
    var isStrategy : Bool?
	
	init?(response: NSHTTPURLResponse, representation: AnyObject) {
       // print("解析的值是====\(representation)")
		self.stockName = representation.valueForKeyPath("shortNM") as? String ?? ""
		self.stockCode = representation.valueForKeyPath("ticker") as! String
        self.change = representation.valueForKeyPath("change") as! String
        self.trend = representation.valueForKeyPath("trend") as! Int
        self.status = representation.valueForKeyPath("status") as! Int
        self.changePct = representation.valueForKeyPath("changePct") as! String
        self.lastPrice = representation.valueForKeyPath("lastPrice") as! String
        self.isStrategy = representation.valueForKeyPath("is_strg") as? Bool
	}
    
    init(stockName: String, stockCode :String, change: String,changePct: String,trend: Int,lastPrice: String,status: Int,isStategy: Bool?) {
        self.stockName = stockName
        self.stockCode = stockCode
        self.change = change
        self.changePct = changePct
        self.trend = trend
        self.lastPrice = lastPrice
        self.status = status
        self.isStrategy = isStategy
    }
	
	init(stockName: String, stockCode :String, change: String,changePct: String,trend: Int,lastPrice: String,status: Int ,isStrategy: Bool?,position: Int) {
		self.stockName = stockName
		self.stockCode = stockCode
		self.change = change
		self.changePct = changePct
		self.trend = trend
		self.lastPrice = lastPrice
		self.status = status
        self.isStrategy = isStrategy
		self.position = position
	}
}

struct OptionalShareItem{
    var stocks: [AnyObject]
    var isMsg: Bool
    var head: [AnyObject]
    init?(representation: AnyObject) {
        self.stocks = representation.valueForKeyPath("stocks") as! [AnyObject]
        self.isMsg = representation.valueForKeyPath("is_msg_unread") as? Bool ?? false
        self.head = representation.valueForKeyPath("head") as! [AnyObject]
    }
}



struct OptionShareItem{
    var stockName: String
    var stockCode: String
    var change: String
    var trend: Int
    var status: Int
    var changePct: String
    var lastPrice: String
    var position = Int(0)
    var isStrategy : Bool?
    
    init?(representation: AnyObject) {
     //   print("解析的值是====\(representation)")
        self.stockName = representation.valueForKeyPath("shortNM") as? String ?? ""
        self.stockCode = representation.valueForKeyPath("ticker") as! String
        self.change = representation.valueForKeyPath("change") as! String
        self.trend = representation.valueForKeyPath("trend") as? Int ?? 0
        self.status = representation.valueForKeyPath("status") as! Int
        self.changePct = representation.valueForKeyPath("changePct") as! String
        self.lastPrice = representation.valueForKeyPath("lastPrice") as! String
        self.isStrategy = representation.valueForKeyPath("is_strg") as? Bool
    }
}
