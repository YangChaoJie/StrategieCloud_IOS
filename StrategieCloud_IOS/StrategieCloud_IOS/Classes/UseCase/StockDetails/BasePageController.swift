//
//  BasePageController.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/18.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class BasePageController: UIViewController {

//	var pageCode = String("")
	var roughStock: RoughStock!
	var pageNum = Int(0)
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	func setPageInfo(viewPagerNum num: Int, roughStock: RoughStock) {}
	
	
	func getShareImage(view: UIView? = nil) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(view!.bounds.size, false, 0.0)
		view!.drawViewHierarchyInRect(view!.bounds, afterScreenUpdates: true)
		view!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
		let finalImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return finalImage
	}
	
	func viewWillTransitionToSizeWithLandscape(landscape: Bool) {
	
	}
}
