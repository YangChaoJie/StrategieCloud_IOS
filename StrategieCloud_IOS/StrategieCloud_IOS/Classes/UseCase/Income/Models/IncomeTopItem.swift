//
//  IncomeTopItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct IncomeTopItem {
    var rank_10 : [AnyObject]
    var rank_60 : [AnyObject]
    var rank_250: [AnyObject]
    
    init?(data: AnyObject){
       self.rank_10 = data.valueForKeyPath("rank_10") as! [AnyObject]
       self.rank_60 = data.valueForKeyPath("rank_60") as! [AnyObject]
       self.rank_250 = data.valueForKeyPath("rank_250") as! [AnyObject]
    }
}

struct  NewItem{
    var h333Conser : [AnyObject]
    var h333radic  : [AnyObject]
    init?(data:AnyObject) {
        self.h333Conser = data.valueForKeyPath("H333conser") as! [AnyObject]
        self.h333radic = data.valueForKeyPath("H333radic") as! [AnyObject]
    }
}

struct ProfitItem {
    var stockName: String
    var stockCode: String
    var position: Int
    var profit: Double
    var aowId: Int
    var strategy: String
    
    init(data: [AnyObject]) {
       self.stockName = data[0] as? String  ?? ""
       self.stockCode = data[1] as? String ?? ""
       self.position = data[2] as? Int ?? 0
       self.profit = data[3] as? Double ?? 0
       self.aowId = data[4] as? Int ?? 0
       self.strategy = data[5] as? String ?? ""
    }
    
    init(result: [AnyObject]) {
        self.stockName = result[0] as? String  ?? ""
        self.stockCode = result[1] as? String ?? ""
        self.position = result[2] as? Int ?? 0
        self.profit = result[3] as? Double ?? 0
        self.aowId = result[4] as? Int ??  0
        self.strategy = ""
    }
}