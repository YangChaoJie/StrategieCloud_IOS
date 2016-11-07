//
//  UserLoginItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct AppKeyItem {
    var QQAppKey: String
    var WXAppkey: String
    init(QQAppKey: String,WXAppkey: String) {
        self.QQAppKey = QQAppKey
        self.WXAppkey = WXAppkey
    }
}

struct ThirdInfoItem {
    var nickName: String
    var avatarUrl:String
    var openId:String
    var platform: String
    var platform_info : [String]
    
    init(data:AnyObject,openId: String) {
        self.nickName = data.valueForKeyPath("nickname") as! String
        self.avatarUrl = data.valueForKeyPath("figureurl_qq_2") as! String
        self.platform = "qq"
        self.openId = openId
        self.platform_info = [data.valueForKeyPath("city") as! String,data.valueForKeyPath("gender") as! String]
    }
    
    init(result: AnyObject,mutableDictionary: NSMutableDictionary) {
        self.nickName = result.valueForKeyPath("nickname") as! String
        self.avatarUrl = result.valueForKeyPath("headimgurl") as! String
        self.platform = "weixin"
        self.openId = result.valueForKeyPath("openid") as! String
        self.platform_info = [mutableDictionary["access_token"] as! String,mutableDictionary["refresh_token"] as! String,result.valueForKeyPath("unionid") as! String]
    }
}