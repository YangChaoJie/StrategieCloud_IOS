//
//  NavgationBarExtension.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

extension UINavigationBar {
	
	class func setupStyle() {
		let navBar = UINavigationBar.appearance()
		navBar.tintColor = UIColor.whiteColor()
		navBar.barTintColor = UIColor.NavBarColor()
		navBar.translucent = false
		let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
		navBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
		navBar.backIndicatorImage = UIImage(named: "ic_back")
		navBar.backIndicatorTransitionMaskImage = UIImage(named: "ic_back")
		
		let navBarItem = UIBarButtonItem.appearance()
		navBarItem.setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: UIBarMetrics.Default)
	}
}