//
//  PickItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/16.
//  Copyright © 2016年 JUNYI. All rights reserved.
//


import Foundation
final  class PickItem: ResponseObjectSerializable, ResponseCollectionSerializableData {
    let stockName: String
    let stockCode: String
    let coordinate: String
    let feature: [Int]
    var optionalShare = false
    
    init?(response: NSHTTPURLResponse, representation: AnyObject) {
        self.stockName = representation.valueForKeyPath("shortNM") as? String ?? ""
        self.stockCode = representation.valueForKeyPath("ticker") as? String ?? ""
        self.coordinate = representation.valueForKeyPath("coordinate") as? String ?? ""
        self.feature = representation.valueForKeyPath("feature") as? [Int] ?? [0]
    }
    
    func setOptionalShare(optionalShare: Bool) {
        self.optionalShare = optionalShare
    }
}