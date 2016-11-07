//
//  BsItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct OptionBsItem {
    var stockName: String
    var stockCode: String
    var strategyMessage: String
    var date : String
    var bs: Int
    
    init(data: [AnyObject]) {
        self.stockName = data[1] as? String ?? ""
        self.strategyMessage = data[2] as? String ?? ""
        self.date = data[0] as? String ?? ""
        self.stockCode = data[3] as? String ?? ""
        self.bs = data[4] as? Int ?? 0
    }
}

final  class BsItem: ResponseObjectSerializable, ResponseCollectionSerializableData {
    let date: String
    let message: [AnyObject]
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.date = representation.valueForKeyPath("date") as! String
        self.message = representation.valueForKeyPath("messages") as! [AnyObject]
    }
}