//
//  PickStockView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/15.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import MJRefresh
class PickStockView: BaseVC {
    let buttonViewWith = CGFloat(35)
    let tabHeight  = CGFloat(35)
    var name : String = "hot"
    
    //MARK: View Life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setContainerView()
        view.addSubview(backgroundScrollView)
        view.addSubview(doubleTextView)
        initNavView()
        
    }
    
    //MARK: private Method
    private func setContainerView() {
        actualTimeView.block = { s in
            self.name = s
            self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
        }
      
        hotStockView.block = { s in
            self.name = s
            self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
        }
        
        bSPointView.block = { s in
            self.name = s
            self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
        }
        
        actualTimeView.view.frame.origin.x = AppWidth
        bSPointView.view.frame.origin.x = AppWidth*2
        self.addChildViewController(actualTimeView)
        self.addChildViewController(hotStockView)
        self.addChildViewController(bSPointView)
        self.backgroundScrollView.addSubview(actualTimeView.view)
        self.backgroundScrollView.addSubview(hotStockView.view)
        self.backgroundScrollView.addSubview(bSPointView.view)
    }
    
    func setButtonActionByIndex(index: Int) {
        if index == 0 {
            self.name = "hot"
            self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
            
        }else if index == 1 {
            self.name = "live"
            self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
        }else {
            //ToDo
            self.name = "bspoint"
            self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
        }
    }
    
    private func initNavView()  {
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView: self.refreshBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    //MARK: getter and setter
    private lazy var backgroundScrollView : UIScrollView = {
        let backgroundScrollView = UIScrollView.init(frame: CGRectMake(0, self.buttonViewWith, AppWidth, AppHeight - NavigationH-self.buttonViewWith-self.tabHeight))
        backgroundScrollView.backgroundColor = UIColor.whiteColor()
        backgroundScrollView.contentSize = CGSizeMake(AppWidth * 3.0, 0)
        backgroundScrollView.showsHorizontalScrollIndicator = false
        backgroundScrollView.showsVerticalScrollIndicator = false
        backgroundScrollView.pagingEnabled = true
        backgroundScrollView.delegate = self
        return backgroundScrollView
    }()
    
    private lazy var doubleTextView :DoubleTextView = {
       let textView = DoubleTextView(leftText: "热门", rigthText: "实时",middleText: "BS点")
       textView.delegate = self
       textView.frame = CGRectMake(0, 0, AppWidth, 35)
       return textView
    }()

    private lazy var actualTimeView : ActualTimeView = {
        let actualTimeView = ActualTimeView()
        return actualTimeView
    }()
    
    private lazy var hotStockView : HotStockView = {
        let hotStockView = HotStockView()
        return hotStockView
    }()
    
    private lazy var bSPointView: BSPointView = {
       let view = BSPointView()
        return view
    }()
    
    private lazy var refreshBtn : LoadingButton = {
        let width = CGFloat(30)
        let btn = LoadingButton.init(frame: CGRectMake(0, 0, width, width))
        btn.block = {auto in
            if self.name == "hot" {
              self.hotStockView.updateDataSource(btn)
            }else if self.name == "live" {
              self.actualTimeView.updateDataSource(btn)
            }else {
              self.bSPointView.updateDataSource(btn)
            }
        }
        btn.setImage(UIImage.init(named: "iconfont-shuaxin")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return btn
    }()
    
}
//MARK: - DoubleTextViewDelegate
extension PickStockView: DoubleTextViewDelegate{
    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int) {
        self.setButtonActionByIndex(index)
        backgroundScrollView.setContentOffset(CGPointMake(AppWidth * CGFloat(index), 0), animated: true)
    }
}

//MARK: UIScrollerViewDelegate
extension PickStockView: UIScrollViewDelegate {
    // MARK: - UIScrollViewDelegate 监听scrollView的滚动事件
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView === backgroundScrollView {
            let index = Int(scrollView.contentOffset.x / AppWidth)
           // self.setButtonActionByIndex(index)
            doubleTextView.clickBtnToIndex(index)
        }
    }
}