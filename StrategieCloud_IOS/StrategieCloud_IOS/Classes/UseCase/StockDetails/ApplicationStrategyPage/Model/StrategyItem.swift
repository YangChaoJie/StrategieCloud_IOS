//
//  StrategyItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

final  class StrategyStockItem : ResponseObjectSerializable, ResponseCollectionSerializableData {
    var name: String
    var profit: Double
    var star: Int
    var isUsing: Bool
    var aowId: Int
	var isExpanded = false
    var strategyChartItem : StrategyChartItem?
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.name = representation.valueForKeyPath("strategy_name") as? String  ?? ""
        self.profit = representation.valueForKeyPath("total_profit") as! Double
        self.isUsing = representation.valueForKeyPath("is_using") as! Bool
        self.star = representation.valueForKeyPath("recommend_idx") as! Int
        self.aowId = representation.valueForKeyPath("aow_id") as! Int
    }
    
    init(name: String,profit:Double,star:Int,isUsing:Bool,aowId:Int,strategyChartItem : StrategyChartItem){
        self.name = name
        self.profit = profit
        self.star = star
        self.isUsing = isUsing
        self.aowId = aowId
        self.strategyChartItem = strategyChartItem
    }
}

class StrategyChartItem: ResponseObjectSerializable {
    var profit10: Float?
    var profit60: Float?
    var profit250: Float?
    var dataform: String?
    required init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.profit10 = representation.valueForKeyPath("data.profit_10") as? Float
        self.profit60 = representation.valueForKeyPath("data.profit_60") as? Float
        self.profit250 = representation.valueForKeyPath("data.profit_250") as? Float
        self.dataform = representation.valueForKeyPath("data.dataform") as? String
    }
    
    init(){}
}
