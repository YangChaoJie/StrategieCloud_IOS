//
//  SetterItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct SetterItem {
    var buySell : Bool
    var glamour : Bool
    var liveInfo :Bool
//    var chosenalert : Bool
//    var chosenbuysell: Bool
    init(buySell: Bool,glamour: Bool,liveInfo :Bool) {
        self.buySell = buySell
        self.glamour = glamour
        self.liveInfo = liveInfo
    }
}