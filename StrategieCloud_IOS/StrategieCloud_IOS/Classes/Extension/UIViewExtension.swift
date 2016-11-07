//
//  UIColor+JerryColor.swift
//  SwiftProject
//
//  Created by 杨超杰 on 16/3/18.
//  Copyright © 2016年 杨超杰. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
/// 对UIView的扩展
extension UIView {
    /// X值
    var x: CGFloat {
        return self.frame.origin.x
    }
    /// Y值
    var y: CGFloat {
        return self.frame.origin.y
    }
    /// 宽度
    var width: CGFloat {
        return self.frame.size.width
    }
    ///高度
    var height: CGFloat {
        return self.frame.size.height
    }
    var size: CGSize {
        return self.frame.size
    }
    var point: CGPoint {
        return self.frame.origin
    }
}

