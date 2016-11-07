//
//  IconView.swift
//  SmallDay
//  项目GitHub地址:
//  项目思路和架构讲解博客:
//  Created by MacBook on 15/8/19.
//  Copyright (c) 2015年 令狐灵犀. All rights reserved.
//  用户头像的View

import UIKit

class IconView: UIImageView{
    var iconButton: UIButton!
    weak var delegate: IconViewDelegate?
    var block : InputClosureType?
  
    typealias InputClosureType = (String) -> String
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
        
    }
    
    private func setUp() {
        self.backgroundColor = UIColor.clearColor()
        iconButton = UIButton(type: .Custom) 
        //iconButton.setImage(UIImage(named: "默认头像"), forState: .Normal)
        iconButton.addTarget(self, action: #selector(IconView.iconBtnClick1(_:)), forControlEvents: .TouchUpInside)
        iconButton.clipsToBounds = true
        addSubview(iconButton)
        self.image = UIImage(named: "默认头像")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let mrgin: CGFloat = 0
        iconButton.frame = CGRectMake(mrgin, mrgin, 75 , 75)
        iconButton.setBackgroundImage(UIImage(named: "white")?.imageClipOvalImage(), forState: .Normal)
    }
    
    override func drawRect(rect: CGRect) {
        let circleWidth: CGFloat = 2
        // 圆角矩形
        let path = UIBezierPath(roundedRect: CGRectMake(circleWidth, circleWidth, rect.size.width - circleWidth * 2, rect.size.width - circleWidth * 2), cornerRadius: rect.size.width)
        path.lineWidth = circleWidth
        UIColor.whiteColor().set()
        path.stroke()
    }
    //可以用闭包试一下
    func iconBtnClick() {
        delegate?.iconView(self, didClick: self.iconButton)
    }
    
    func iconBtnClick1(button:UIButton) {
        self.block!("haha")
    }
}


protocol IconViewDelegate: NSObjectProtocol {
    func iconView(iconView: IconView, didClick iconButton: UIButton)
}

