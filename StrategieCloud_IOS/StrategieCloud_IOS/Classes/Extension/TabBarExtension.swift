//
//  TabBarExtension.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/12.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

extension UITabBar {
	
	class func setupStyle() {
		let tabBar = UITabBar.appearance()
		tabBar.barTintColor = UIColor.appBarColor()
		tabBar.tintColor = UIColor.appBarTintColor()
		tabBar.translucent = false
		/*
		* 设置tabbar 字体的颜色
		*/
		let itemAppearance = UITabBarItem.appearance()
		itemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.TabBarHighlightColor(), NSFontAttributeName : UIFont.systemFontOfSize(12)], forState: .Selected)
		itemAppearance.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.TabBarNormalColor(), NSFontAttributeName : UIFont.systemFontOfSize(12)], forState: .Normal)
	}
}