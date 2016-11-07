//
//  BsPointItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/24.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct BsPointItem {
    let stockName: String
    let stockCode: String
    let coordinate: String
    let feature: Int
    var optionalShare = false
    
    init(data: [AnyObject]) {
      self.stockName = data[0] as? String  ?? ""
      self.stockCode = data[1] as? String ?? ""
      self.coordinate = data[2] as? String ?? ""
      self.feature = data[3] as?  Int ?? 0
    }
    
    mutating func setOptionalShare(optionalShare: Bool) {
        self.optionalShare = optionalShare
    }
}
