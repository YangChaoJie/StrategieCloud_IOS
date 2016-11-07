//
//  LeadpageViewController.swift
//  SwiftProject
//
//  Created by 杨超杰 on 16/3/18.
//  Copyright © 2016年 杨超杰. All rights reserved.
//

import UIKit

class GuideViewController: BaseVC{
   
     var pageControl = UIPageControl()
     var startButton = UIButton()
     let numOfPages = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        addScrollView()
        addBtn()
    }
    
   private func addScrollView(){
        //let imagesFlatten = (0...3).flatMap{UIImage(named: "\($0)")}
        var scrollView: UIScrollView!
        let frame = self.view.bounds
        scrollView = UIScrollView(frame: frame)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.contentOffset = CGPointZero
        scrollView.userInteractionEnabled = true
        // 将 scrollView 的 contentSize 设为屏幕宽度的3倍(根据实际情况改变)
        scrollView.contentSize = CGSize(width: frame.size.width * CGFloat(numOfPages), height: frame.size.height)
        
        scrollView.delegate = self
        
        for index  in 0..<numOfPages {
            // 这里注意图片的命名
            let path = NSBundle.mainBundle().pathForResource("0\(index + 1)", ofType: "png")
            let imageView = UIImageView(image: UIImage(contentsOfFile: path!)!)
            imageView.userInteractionEnabled = true
            imageView.frame = CGRect(x: frame.size.width * CGFloat(index), y: 0, width: frame.size.width, height: frame.size.height)
            scrollView.addSubview(imageView)
        }
        
        self.view.insertSubview(scrollView, atIndex: 0)
    }
    
    private func addBtn() {
        startButton.frame = CGRectMake(AppWidth/3-20, AppHeight/3*2+100, AppWidth/3+40, 50)
        startButton.layer.cornerRadius = 7.0
        startButton.backgroundColor = UIColor.clearColor()     // 隐藏开始按钮
        startButton.alpha = 0.0
        startButton.layer.borderWidth = 1.0
        startButton.layer.borderColor = UIColor.colorWith(50, green: 134, blue: 241, alpha: 1).CGColor
        startButton.setTitle("立即体验", forState: UIControlState.Normal)
        startButton.setTitleColor(UIColor.colorWith(50, green: 134, blue: 241, alpha: 1), forState: .Normal)
        startButton.addTarget(self, action:#selector(GuideViewController.showMainTabbar), forControlEvents: UIControlEvents.TouchUpInside)
        pageControl.currentPageIndicatorTintColor = UIColor.NavBarColor()
        pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControl.frame = CGRectMake(20, AppHeight-44, AppWidth-40, 44)
        pageControl.numberOfPages = numOfPages
        pageControl.enabled = false
        // pageControl.hidden = true
        self.view.addSubview(startButton)
        self.view.addSubview(pageControl)
    }
    
    // 隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func showMainTabbar() {
		let mainTabBarVC = MainTabBarViewController()
		UIApplication.sharedApplication().keyWindow?.rootViewController = mainTabBarVC
	}
}
//MARK:  UIScrollViewDelegate
extension GuideViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageControl.currentPage == numOfPages-1 {
               UIView.animateWithDuration(0.5) {
               self.startButton.alpha = 1.0
            }
        } else {
                UIView.animateWithDuration(0.2) {
                self.startButton.alpha = 0
            }
        }
    }
}
