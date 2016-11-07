//
//  StockQuotationItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/19.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
final class StockQuotationItem {
    let concept : [[AnyObject]]
    let equ_aes : [[AnyObject]]
    let five_min : [[AnyObject]]
    let volume_rate : [[AnyObject]]
    let industry : [[AnyObject]]
    let turnover : [[AnyObject]]
    let equ_desc :  [[AnyObject]]
    init?(representation: AnyObject) {
        self.concept = representation.valueForKeyPath("concept") as! [[AnyObject]]
        self.equ_aes = representation.valueForKeyPath("equ_aes") as! [[AnyObject]]
        self.five_min = representation.valueForKeyPath("five_min") as! [[AnyObject]]
        self.volume_rate = representation.valueForKeyPath("volume_rate") as! [[AnyObject]]
        self.industry = representation.valueForKeyPath("industry") as! [[AnyObject]]
        self.turnover = representation.valueForKeyPath("turnover") as! [[AnyObject]]
        self.equ_desc = representation.valueForKeyPath("equ_desc") as! [[AnyObject]]
    }
}