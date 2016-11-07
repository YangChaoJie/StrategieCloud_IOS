//
//  MainTabBarViewController.swift
//  SwiftProject
//
//  Created by 杨超杰 on 16/3/19.
//  Copyright © 2016年 杨超杰. All rights reserved.
//

import UIKit
import Kingfisher

let StrategyCloudAvatarCache = ImageCache(name: "strategycloudavatar_cache")

class MainTabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAllChildViewController()
    }

    //初始化控制器
    private func setUpAllChildViewController() {
		tabbarAddChildViewController(vc: (OptionalShareWireFrame.presentOptionalShareModule() as! OptionalShareView), title: "自选", imageName: "自选-未选中", selectedImageName: "自选-已选中")
        tabbarAddChildViewController(vc: PickStockView(), title: "选股", imageName: "选股-未选中", selectedImageName: "选股-已选中")
        tabbarAddChildViewController(vc: IncomeTopView(), title: "点兵", imageName: "点兵-未选中", selectedImageName: "点兵-已选中")
        tabbarAddChildViewController(vc: ConditionView(), title: "行情", imageName: "行情-未选中", selectedImageName: "行情-已选中")
        tabbarAddChildViewController(vc: MineWireFrame.presentMineModule(MineView()) as! UIViewController, title: "我的", imageName: "我的-未选中", selectedImageName: "我的-已选中")

		self.selectedIndex = 0
    }

    private func tabbarAddChildViewController(vc vc: UIViewController, title: String, imageName: String, selectedImageName: String){
        vc.tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName)?.imageWithRenderingMode(.AlwaysOriginal))
        vc.title = title
		let nav = MainNavigationController(rootViewController: vc)
        addChildViewController(nav)
    }

	override func shouldAutorotate() -> Bool {
		return (self.selectedViewController?.shouldAutorotate())!
	}

	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return (self.selectedViewController?.supportedInterfaceOrientations())!
	}
}
