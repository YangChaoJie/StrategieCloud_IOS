//
//  Industry.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol  IndustryDeatilSortDelegate: class {
    func sortByChange(state: Bool)
}

enum RiseState : Int{
    case down = 0
    case up = 1
}

class IndustryDeatilHeadView: UIView {
    var state : Bool = false
    var delegate : IndustryDeatilSortDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(newPriceBtn)
        addSubview(riseBtn)
        self.backgroundColor = UIColor.colorWith(240, green: 244, blue: 255, alpha: 0.9)
        setButtonState()
        addmakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: private Methood
    func setButtonState() {
        if ConditionTag.riseTag == RiseState.down.rawValue {
            self.riseBtn.setImage(UIImage.init(named: "向下箭头"), forState: .Normal)
        }else if ConditionTag.riseTag == RiseState.up.rawValue {
            self.riseBtn.setImage(UIImage.init(named: "向上箭头"), forState: .Normal)
        }
    }
    
    func setHeadName(name: String) {
         self.nameLabel.text = name
    }
    
    func addmakeConstraints()  {
        nameLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
        }
        riseBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(10)
            // make.width.equalTo(120)
        }
        newPriceBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self.snp_right).offset(-30)
            // make.width.equalTo(120)
        }
        
    }
    //MARK: - 懒加载控件
    //名字标签
    private lazy var nameLabel:UILabel = {
        let label =  self.createlabel("行业名称")
        label.textColor = UIColor.colorWith(150, green: 166, blue: 178, alpha: 1.0)
        return label
    }()
    
    //涨跌幅按钮
    private lazy var riseBtn:UIButton = {
        let button =   self.createButton("涨幅")
        button.tag = ConditionTag.riseTag
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0,57,0.0,0.0)
        button.addTarget(self, action: #selector(sortByRise(_:)), forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.colorWith(67, green: 133, blue: 245, alpha: 1), forState: .Normal)
        return button
    }()
    
    private lazy var newPriceBtn:UIButton = {
        let button = self.createButton("领涨股")
        button.tag = Tag.changeTag
        button.imageEdgeInsets = UIEdgeInsetsMake(0.0,57,0.0,0.0)
        button.addTarget(self, action: #selector(sortByPrice(_:)), forControlEvents: .TouchUpInside)
        button.setTitleColor(UIColor.colorWith(150, green: 166, blue: 178, alpha: 1.0), forState: .Normal)
        return button
    }()
    
    func createButton(title:String)->UIButton{
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(12)
        btn.titleLabel?.textAlignment = .Center
        btn.imageView?.contentMode = .Center
        btn.imageView?.clipsToBounds = false
        btn.setTitle(title, forState: .Normal)
        //btn.setTitleColor(UIColor.colorWith(30, green: 144, blue: 255, alpha: 1), forState: .Normal)
        return btn
    }
    
    func sortByRise(sender: UIButton){
        if sender.tag == RiseState.down.rawValue {
            ConditionTag.riseTag += 1
        }else {
            ConditionTag.riseTag = 0
        }
        self.delegate?.sortByChange(self.state)
    }
    
    func sortByPrice(sender: UIButton){
        self.delegate?.sortByChange(state)
    }
    
    //MARK: - 协议方法
    func createlabel(title:String)->UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        label.text = title
        //label.textColor = UIColor.colorWith(30, green: 144, blue: 255, alpha: 1)
        return label
    }
}
