//
//  MainNavigationController.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/8/2.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

	override func pushViewController(viewController: UIViewController, animated: Bool) {
		if self.childViewControllers.count > 0 {
			viewController.hidesBottomBarWhenPushed = true
		}
		super.pushViewController(viewController, animated: animated)
	}

	override func shouldAutorotate() -> Bool {
		return (self.topViewController?.shouldAutorotate())!
	}

	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return (self.topViewController?.supportedInterfaceOrientations())!
	}
}
