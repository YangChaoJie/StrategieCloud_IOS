//
//  MainNavigationViewController.swift
//  SmallDay
//  项目GitHub地址:         https://github.com/ZhongTaoTian/SmallDay
//  项目思路和架构讲解博客:    http://www.jianshu.com/p/bcc297e19a94
//  Created by MacBook on 15/8/14.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//  基类导航控制器

import UIKit

class MainNavigationController: UINavigationController {
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = UIColor.NavBarColor()
        self.navigationBar.translucent = false
        self.interactivePopGestureRecognizer!.delegate = self
        self.navigationItem.setHidesBackButton(true, animated: true)
        let navigationTitleAttribute : NSDictionary = NSDictionary(object: UIColor.whiteColor(),forKey: NSForegroundColorAttributeName)
        self.navigationBar.titleTextAttributes = navigationTitleAttribute as? [String : AnyObject]
    }

    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.Custom)
        backBtn.titleLabel?.font = UIFont.systemFontOfSize(0)
        backBtn.setImage(UIImage(named: "back_2.png"), forState: .Normal)
        backBtn.addTarget(self, action: #selector(MainNavigationController.backBtnClick), forControlEvents: .TouchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        let btnW: CGFloat = AppWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRectMake(0, 0, btnW, 40)
        return backBtn
        }()

    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.childViewControllers.count > 0 {
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func backBtnClick() {
        self.popViewControllerAnimated(true)
    }
}
/*
 *解决UINavigationController 拖动左边POP到上一个控制器不可用的问题
 */
extension MainNavigationController : UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        if self.viewControllers.count == 1 {
            return false
        }
        return true
    }
}
