//
//  DoubleTextView.swift
//
//
//
//  Created by MacBook on 15/8/16.
//  Copyright (c) 2015年 Jerry. All rights reserved.
//  探店的titleView

import UIKit

class DoubleTextView: UIView {
    private let leftTextButton: NoHighlightButton =  NoHighlightButton()
    private let rightTextButton: NoHighlightButton = NoHighlightButton()
    private let middleTextButton: NoHighlightButton = NoHighlightButton()
    private let textColorFroNormal: UIColor = UIColor(red: 155 / 255.0, green: 166 / 255.0, blue: 178 / 255.0, alpha: 1)
    private let textFont: UIFont = UIFont.systemFontOfSize(14)
    private let bottomLineView: UIView = UIView()
    private var selectedBtn: UIButton?
    weak var delegate: DoubleTextViewDelegate?
    var  dd: CGFloat = 20
    var  with : CGFloat = 0
    /// 便利构造方法
    convenience init(leftText: String, rigthText: String,middleText: String) {
        self.init()
        // 设置左边文字
        setButton(leftTextButton, title: leftText, tag: 100)
        // 设置右边文字
        setButton(rightTextButton, title: rigthText, tag: 101)
        //设置中间的文字
        setButton(middleTextButton, title: middleText, tag: 102)
        // 设置底部线条View
        setBottomLineView()
        
        titleButtonClick(leftTextButton)
    }
    
    private func setBottomLineView() {
        self.backgroundColor = UIColor.colorWith(241, green: 245, blue: 251, alpha: 1)
        bottomLineView.backgroundColor = UIColor.colorWith(66, green: 133, blue: 244, alpha: 1)
        addSubview(bottomLineView)
    }
    
    private func setButton(button: UIButton, title: String, tag: Int) {
        button.setTitleColor(UIColor.NavBarColor(), forState: .Selected)
        button.setTitleColor(textColorFroNormal, forState: .Normal)
        button.titleLabel?.font = textFont
        button.tag = tag
        button.addTarget(self, action: #selector(DoubleTextView.titleButtonClick(_:)), forControlEvents: .TouchUpInside)
        button.setTitle(title, forState: .Normal)
        addSubview(button)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let btnW = width/3
        leftTextButton.frame = CGRectMake(0, 0, btnW, height)
        rightTextButton.frame = CGRectMake(btnW, 0, btnW, height)
        middleTextButton.frame = CGRectMake(btnW*2, 0, btnW, height)
        
        bottomLineView.frame = CGRectMake(0, height - 2, btnW/4, 2)
        bottomLineView.center.x = leftTextButton.center.x
        dd = bottomLineView.center.x
        with = self.bottomLineView.frame.origin.x
    }
    
    func titleButtonClick(sender: UIButton) {
        selectedBtn?.selected = false
        sender.selected = true
        selectedBtn = sender
        bottomViewScrollTo(sender.tag - 100)
        delegate?.doubleTextView(self, didClickBtn: sender, forIndex: sender.tag - 100)
    }
    
    func bottomViewScrollTo(index: Int) {
        let width = rightTextButton.center.x - dd
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.bottomLineView.frame.origin.x = self.with + CGFloat(index) * width
        })
    }
    
    func clickBtnToIndex(index: Int) {
        let btn: NoHighlightButton = self.viewWithTag(index + 100) as! NoHighlightButton
        self.titleButtonClick(btn)
    }
}

/// DoubleTextViewDelegate协议
protocol DoubleTextViewDelegate: NSObjectProtocol{
    func doubleTextView(doubleTextView: DoubleTextView, didClickBtn btn: UIButton, forIndex index: Int)
    
}

/// 没有高亮状态的按钮
class NoHighlightButton: UIButton {
    /// 重写setFrame方法
    override var highlighted: Bool {
        didSet{
            super.highlighted = false
        }
    }
}
