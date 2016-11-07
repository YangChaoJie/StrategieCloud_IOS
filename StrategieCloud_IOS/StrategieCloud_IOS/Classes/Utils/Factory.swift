//
//  Factory.swift
//  SwiftProject
//
//  Created by 杨超杰 on 16/3/18.
//  Copyright © 2016年 杨超杰. All rights reserved.
//
//全局公用属性
import UIKit
import Foundation
public let NavigationH: CGFloat = 64
public let TabH : CGFloat = 49
public let HeaderH : CGFloat = 30
public let AppWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
public let AppHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
public let MainBounds: CGRect = UIScreen.mainScreen().bounds

struct Factory {
    ///  APP导航条barButtonItem文字大小
    static let SDNavItemFont: UIFont = UIFont.systemFontOfSize(16)
    ///  APP导航条titleFont文字大小
    static let SDNavTitleFont: UIFont = UIFont.systemFontOfSize(18)
    /// ViewController的背景颜色
    static let SDBackgroundColor: UIColor = UIColor.colorWith(255, green: 255, blue: 255, alpha: 1)
    /// webView的背景颜色
    static let SDWebViewBacagroundColor: UIColor = UIColor.colorWith(240, green: 244, blue: 255, alpha: 1.0)
}
struct Configs {
    
    struct Weibo {
        static let appID = "1772193724"
        static let appKey = "453283216b8c885dad2cdb430c74f62a"
        static let redirectURL = "http://www.limon.top"
    }
    
    struct Wechat {
        static let appID = "wx5113ebbe0654c8a4"
        static let appKey = "99629cb02adaba543ee6e22165d3c256"
    }
    
    struct QQ {
        static let appID = "1105485085"
    }
    
    struct Pocket {
        static let appID = "48363-344532f670a052acff492a25"
        static let redirectURL = "pocketapp48363:authorizationFinished" // pocketapp + $prefix + :authorizationFinished
    }
    
    struct Alipay {
        static let appID = "2016012101112529"
    }

}
struct DeviceInfo {
    //设备的UUId
    static let deviceUUID = helper.getRandomStringOfLength(20)
    //设备名称
    static let deviceName = UIDevice.currentDevice().name
    //获取设备的型号
    static let deviceModel = UIDevice.currentDevice().model
    //获取版本号
    static let systemVersion = UIDevice.currentDevice().systemVersion
}


