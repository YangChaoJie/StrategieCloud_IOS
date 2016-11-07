//
//  ConditionTableHeadView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import SnapKit
protocol ConditionHeaderViewDelegate : NSObjectProtocol{
    func ConditionHeaderViewDidClickBtn(headerView : ConditionTableHeadView, isOpen: Bool)
    func skipToDetailView(title: String,option: String)
}

class ConditionTableHeadView: UIView {
    var isExpend : Bool?
    var name : String?
    var option : String?
    var delegete : ConditionHeaderViewDelegate?
    
    var isOpen:NSMutableArray!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func CreateView(frame: CGRect, name : String,option : String) {
        self.backgroundColor = UIColor.colorWith(240, green: 244, blue: 250, alpha: 1)
        
        addSubview(headerBtn)
        addSubview(moreBtn)
        addmakeConstraints()
        self.name = name
        self.option = option
        self.headerBtn.setTitle(name , forState: .Normal)
        let tap = UITapGestureRecognizer(target:self, action:#selector(ConditionTableHeadView.headerBtnClick(_:)))
        self.userInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 添加约束
    func addmakeConstraints()  {
        headerBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(5)
            make.width.equalTo(120)
        }
        
        moreBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(0)
            make.width.equalTo(40)
        }
    }
    
    //MARK: - 懒加载控件
    private lazy var headerBtn: UIButton = {
        let index = self.tag
        let btn = UIButton()
        btn.setTitle("" , forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(12)
        btn.setTitleColor(UIColor.colorWith(53, green: 67, blue: 70, alpha: 1.0), forState: .Normal)
        btn.setImage(UIImage.init(named: "ic_market_arrow_up"), forState: .Normal)
        
        btn.contentHorizontalAlignment = .Left
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
        
    
        btn.imageView?.contentMode = .Center
        btn.imageView?.clipsToBounds = false
        btn.addTarget(self, action: #selector(headerBtnClick(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    private lazy var moreBtn: UIButton = {
       let btn = UIButton ()
       btn.setImage(UIImage.init(named: "ic_more"), forState: .Normal)
       btn.addTarget(self, action: #selector(moreBtnClick(_:)), forControlEvents: .TouchUpInside)
       return btn
    }()
   
    func headerBtnClick(sender: UIButton)  {
        let index = self.tag
        isExpend = isOpen[index] as? Bool
        
        isExpend = !isExpend!
        if isExpend == false {
            self.moreBtn.hidden = true
            self.headerBtn.imageView?.transform = CGAffineTransformMakeRotation(0)
        } else {
            self.moreBtn.hidden = false
            self.headerBtn.imageView?.transform = CGAffineTransformMakeRotation(3.1415926)
        }
        
        if ((self.delegete?.respondsToSelector(#selector(headerBtnClick(_:)))) != nil) {
            self.delegete?.ConditionHeaderViewDidClickBtn(self , isOpen: isExpend!)
        }
    }
    
    func moreBtnClick(sender: UIButton) {
        delegete?.skipToDetailView(name!,option: self.option!)
    }
    
    func setBtnClick(isOpen : Bool) {
        if isOpen == false {
         self.moreBtn.hidden = true
         self.headerBtn.imageView?.transform = CGAffineTransformMakeRotation(0)
       } else {
         self.moreBtn.hidden = false
         self.headerBtn.imageView?.transform = CGAffineTransformMakeRotation(3.1415926)
      }
    
    }
}
