//
//  BaseVC.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/8/2.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class BaseVC: UIViewController {
	var pageName : String!
	//统计用户访问页面
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		MobClick.beginLogPageView(pageName)
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		MobClick.endLogPageView(pageName)
	}
	
	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.Portrait
	}
}