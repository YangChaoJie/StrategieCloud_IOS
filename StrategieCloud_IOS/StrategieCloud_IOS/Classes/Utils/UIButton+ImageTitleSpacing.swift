//
//  UIButton+ImageTitleSpacing.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
enum MKButtonEdgeInsetsStyle {
    case MKButtonEdgeInsetsStyleTop // image在上，label在下
    case MKButtonEdgeInsetsStyleLeft  // image在左，label在右
    case MKButtonEdgeInsetsStyleBottom  // image在下，label在上
    case MKButtonEdgeInsetsStyleRight // image在右，label在左
}


extension UIButton {
    func layoutButtonEdgeInsets(style:MKButtonEdgeInsetsStyle,space:CGFloat) {
        var labelWidth : CGFloat = 0.0
        var labelHeight : CGFloat = 0.0
        var imageEdgeInset = UIEdgeInsetsZero
        var labelEdgeInset = UIEdgeInsetsZero
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        if Double(UIDevice.currentDevice().systemVersion) >= 8.0 {
             labelWidth = (self.titleLabel?.intrinsicContentSize().width)!
             labelHeight = (self.titleLabel?.intrinsicContentSize().height)!
        }else {
            labelWidth = (self.titleLabel?.frame.size.width)!
            labelHeight = (self.titleLabel?.frame.size.height)!
        }
        labelWidth = CGFloat(36)
        switch style {
        case .MKButtonEdgeInsetsStyleTop:
            imageEdgeInset = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth)
            labelEdgeInset = UIEdgeInsetsMake(0, -imageWith!, -imageHeight!-space/2.0, 0)
        case .MKButtonEdgeInsetsStyleLeft:
            imageEdgeInset = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInset = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        case .MKButtonEdgeInsetsStyleBottom:
            imageEdgeInset = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth)
            labelEdgeInset = UIEdgeInsetsMake(-imageHeight!-space/2.0, -imageWith!, 0, 0)
        case .MKButtonEdgeInsetsStyleRight:
            // To Do print("坐标是====\(labelWidth)=====\(space)")
            imageEdgeInset = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0)
            labelEdgeInset = UIEdgeInsetsMake(0, -imageWith!-space/2.0, 0, imageWith!+space/2.0)
        }
        
        self.titleEdgeInsets = labelEdgeInset
        self.imageEdgeInsets = imageEdgeInset
       
    }
}