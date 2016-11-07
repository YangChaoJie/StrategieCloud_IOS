//
//  DiagnoseItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct  DiagnoseItem{
    var profit10: Float
    var profit60: Float
    var profit250: Float
    var dataform: String
    var profit: Double
    var star: Float
    var strategyName : String
    init(data:AnyObject){
        self.profit10 = data.valueForKeyPath("profit_10") as? Float ?? 0
        self.profit60 = data.valueForKeyPath("profit_60") as? Float ?? 0
        self.profit250 = data.valueForKeyPath("profit_250") as? Float ?? 0
        self.dataform = data.valueForKeyPath("dataform") as? String ?? ""
        self.profit = data.valueForKeyPath("total_profit") as? Double ?? 0
        self.star = data.valueForKeyPath("recommend_idx") as? Float ?? 0
        self.strategyName = data.valueForKeyPath("strategy_name") as? String ?? ""
    }
}