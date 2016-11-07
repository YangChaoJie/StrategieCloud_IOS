//
//  SegmentView.swift
//  test
//
//  Created by 杨超杰 on 2016/10/17.
//  Copyright © 2016年 ringeartech. All rights reserved.
//

import UIKit
enum CCZSegementStyle {
    case CCZSegementStyleDefault
    case CCZSegementStyleFlush
}
class SegmentView: UIView,UIScrollViewDelegate {
    typealias indexBlock = (Int)-> ()
    var segmentTintColor: UIColor?
    var type: CCZSegementStyle? {
        didSet {
            if type == CCZSegementStyle.CCZSegementStyleDefault {
                
            }else {
                self.indicateView.frame = CGRectMake(self.selectedButton.frame.origin.x, self.segementHeight - self.indicateHeight, self.widthAtIndex(0), self.indicateHeight)
            }
        }
    }
    //var segementView: UIScrollView?
    var titles: [String] = []
    var indicateHeight: CGFloat = 0  /**< 指示杆高度*/
    var duration:NSTimeInterval = 0      /**< 滑动时间*/
    var gSize: CGSize
    var segementHeight: CGFloat = 0 /**< 头部segementView的高度*/
    var buttonSpace: CGFloat = 0     /**< 按钮title到边的间距*/
    var minItemSpace: CGFloat = 0  /**< 最小Item之间的间距*/
    var font: UIFont?
    var resultBlock: indexBlock?
    var normalColor: UIColor?  /**< 标题未被选中时的颜色*/
    var widthArr: NSMutableArray? /**< 存放按钮的宽度*/
//    convenience init(frame:CGRect,titles: [String]) {
//      self.titles = titles
//    }
    init(frame: CGRect,titles: [String]) {
        self.gSize = frame.size
        super.init(frame: frame)
        self.frame = frame
        self.titles = titles
        self.segementBasicSetting()
        self.segementPageSetting()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //fuction
    func segementBasicSetting(){
        self.backgroundColor = UIColor.clearColor()
        self.widthArr = NSMutableArray()
        self.segementHeight = 44
        self.minItemSpace = 20
        self.segmentTintColor = UIColor.blackColor()
        self.font = UIFont.systemFontOfSize(16)
        self.indicateHeight = 3.0
        self.duration = 0.1
        self.normalColor = UIColor.lightGrayColor()
        self.buttonSpace = self.calculateSpace()
    }
    
    func segementPageSetting() {
        self.addSubview(segementView)
        var item_x: CGFloat = 0
        
        for i in 0...self.titles.count-1 {
            let title = self.titles[i]
            let titleSize : CGSize = (title as NSString).sizeWithAttributes([NSFontAttributeName: self.font!])
            let btn: UIButton = UIButton.init(type: .Custom)
            btn.frame = CGRectMake(item_x, 0, self.buttonSpace * 2 + titleSize.width, self.segementHeight)
            btn.tag = i
            btn.setTitle(title, forState: .Normal)
            btn.setTitleColor(self.normalColor, forState: .Normal)
            btn.setTitleColor(self.segmentTintColor, forState: .Selected)
            btn.addTarget(self, action: #selector(didClicked), forControlEvents: .TouchUpInside)
            self.segementView.addSubview(btn)
           
            self.widthArr?.addObject(NSNumber.init(double: Double(CGRectGetWidth(btn.frame))))
            item_x += self.buttonSpace * 2 + titleSize.width
            // 添加指示杆
            if i == 0 {
               // btn.selected = true
                self.indicateView.frame = CGRectMake(self.buttonSpace, self.segementHeight - self.indicateHeight, titleSize.width, self.indicateHeight)
                segementView.addSubview(self.indicateView)
            }
            self.segementView.contentSize = CGSizeMake(item_x, self.segementHeight)
        }
    }
    
    //按钮方法
    //MARK:按钮方法
    @objc func didClicked(button:UIButton) {
        print("我被点击了")
        if button != self.selectedButton {
            button.selected = true
            self.selectedButton.selected = !self.selectedButton.selected
            self.selectedButton = button
        }
        self.scrollIndicateView()
        self.scrollSegementView()
        if (self.resultBlock != nil) {
            self.resultBlock!(self.selectedButton.tag)
        }
        
    }
    
    //根据选中的按钮滑动指示杆
    
    func scrollIndicateView() {
        let index = self.selectedAtIndex()
        let titleSize : CGSize = (self.selectedButton.titleLabel!.text! as NSString).sizeWithAttributes([NSFontAttributeName: self.font!])
        UIView.animateWithDuration(self.duration, delay: 0, options: .CurveEaseInOut, animations: {
            if  self.type == CCZSegementStyle.CCZSegementStyleDefault {
                self.indicateView.frame = CGRectMake(CGRectGetMinX(self.selectedButton.frame) + self.buttonSpace, CGRectGetMinY(self.indicateView.frame), titleSize.width, self.indicateHeight)
            }else{
                self.indicateView.frame = CGRectMake(CGRectGetMinX(self.selectedButton.frame), CGRectGetMinY(self.indicateView.frame), self.widthAtIndex(index), self.indicateHeight)
            }
            }) { (finish) in
                
        }
    }
    /**
     根据选中调整segementView的offset
     */
    
    func scrollSegementView() {
        let selectedWidth = self.selectedButton.frame.size.width
        let offsetX  = (self.size.width - selectedWidth)/2
        if self.selectedButton.frame.origin.x <= self.size.width/2 {
             segementView.setContentOffset(CGPointMake(0,0), animated: true)
        }else if CGRectGetMaxX(self.selectedButton.frame) >= (self.segementView.contentSize.width - self.size.width / 2) {
             segementView.setContentOffset(CGPointMake(self.segementView.contentSize.width - self.size.width,0), animated: true)
        }else {
            segementView.setContentOffset(CGPointMake(CGRectGetMinX(self.selectedButton.frame) - offsetX,0), animated: true)
        }
    }
    
    //MARK: index
    func selectedAtIndex()->Int {
        return self.selectedButton.tag
    }
    
    func setSelectedItemAtIndex(index:Int) {
        for view in self.segementView.subviews {
            if view is UIButton && view.tag == index{
                let btn = view as! UIButton
                self.didClicked(btn)
            }
        }
    }
    
    func widthAtIndex(index:Int) -> CGFloat {
        if (index < 0 || index > self.titles.count - 1) {
            return 0
        }
        return CGFloat((self.widthArr?.objectAtIndex(index))! as! NSNumber)
    }
    
    private func calculateSpace()-> CGFloat {
        var space: CGFloat = 0
        var totalWidth: CGFloat = 0
        for title in self.titles {
            let titleSize : CGSize = (title as NSString).sizeWithAttributes([NSFontAttributeName: self.font!])
            totalWidth += titleSize.width
        }
        
        space = (self.size.width - totalWidth)
        let s = space/CGFloat(self.titles.count)/2
        if s > (self.minItemSpace/2) {
            return CGFloat(s);
        } else {
            return self.minItemSpace/2;
        }
    }
    
    func selectedAtIndex(indexBlock:(Index:Int)-> ()) {
            self.resultBlock = indexBlock
            self.resultBlock!(self.selectedAtIndex())
    }
    
    //MARK: Set
    func setedSegmentTintColor(segmentTintColor: UIColor) {
        self.segmentTintColor = segmentTintColor
        self.indicateView.backgroundColor = segmentTintColor
        for view in self.segementView.subviews {
            if view is UIButton {
            let btn = view as! UIButton
            btn.setTitleColor(segmentTintColor, forState: .Selected)
            }
        }
     }
    
    
    

    
    //setter and getter
    /**< 当前被选中的按钮*/
    private lazy var selectedButton: UIButton = {
        let btn = UIButton.init(type: .Custom)
        return btn
    }()
    /**< 指示杆*/
    private lazy var indicateView: UIView = {
        let view = UIView.init()
        view.backgroundColor = self.segmentTintColor
        return view
    }()
    
    lazy var segementView: UIScrollView = {
       let scrollerView = UIScrollView.init(frame: CGRectMake(0, 0, self.size.width, self.segementHeight))
        scrollerView.backgroundColor = UIColor.init(white: 1.0, alpha: 1)
        scrollerView.showsHorizontalScrollIndicator = false
        scrollerView.showsVerticalScrollIndicator = false
        return scrollerView
    }()
    
    

}
