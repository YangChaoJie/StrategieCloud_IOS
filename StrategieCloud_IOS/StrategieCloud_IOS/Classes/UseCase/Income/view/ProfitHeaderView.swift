//
//  ProfitHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/9.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol  ProfitHeaderViewDelegate: class{
    func initSuperView(left:ZHDropDownMenu ,right: ZHDropDownMenu)
    func transmitMenuItem(leftText: String,RightText: String)
}
class ProfitHeaderView: UIView {
    weak var delegate: ProfitHeaderViewDelegate?
    let lineColor = UIColor.colorWith(232, green: 238, blue: 243, alpha: 1)
    var leftText: String = "both"
    var rightText: String = "10"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        addSubview(leftMenu)
        addSubview(rightMenu)
        addSubview(line)
        
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        delegate?.initSuperView(leftMenu, right: rightMenu)
       
    }
    
    
    private func addConstraints() {
        leftMenu.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(0)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
        
        rightMenu.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self.snp_right).offset(0)
            make.height.equalTo(40)
            make.width.equalTo(130)
        }
        
        line.snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.bottom.equalTo(rightMenu.snp_bottom).offset(-0.5)
            make.width.equalTo(AppWidth)
            make.height.equalTo(0.5)
        }
        
    }
    
    //MARK: setter and getter
    
    private lazy var leftMenu: ZHDropDownMenu = {
       let _menu =  ZHDropDownMenu.init(frame: CGRectMake(0, 0, 90, 40))
        _menu.options = ["全部策略","H333稳健策略","SH333激进策略"]//设置下拉列表项数据
        _menu.font = UIFont.systemFontOfSize(12)
        _menu.defaultValue = "全部策略" //设置默认值
        _menu.editable = false //禁止编辑
        _menu.showBorder = false //不显示边框
        _menu.buttonImage = UIImage.init(named: "default_down.png")
        _menu.delegate = self
        
        return _menu
    }()
    
    private lazy var rightMenu: ZHDropDownMenu = {
        let _menu =  ZHDropDownMenu.init(frame: CGRectMake(0, 0, 90, 40))
        _menu.options = ["10日收益榜","60日收益榜","250日收益榜"]//设置下拉列表项数据
        _menu.defaultValue = "10日收益榜" //设置默认值
        _menu.editable = false //禁止编辑
        _menu.showBorder = false //不显示边框
        _menu.font = UIFont.systemFontOfSize(12)
        _menu.buttonImage = UIImage.init(named: "default_down.png")
        _menu.delegate = self
        _menu.left = false
        return _menu
    }()
    
    private lazy var line: UILabel = {
        let label = UILabel()
        label.backgroundColor = self.lineColor
        return label
    }()
    

}

extension ProfitHeaderView: ZHDropDownMenuDelegate {
    //选择完后回调
    func dropDownMenu(menu: ZHDropDownMenu!, didChoose index: Int) {
        print("策略的名字是\(menu.contentText )")
        if menu.left == true {
            switch menu.contentText {
            case "全部策略":
                leftText = "both"
            case "H333稳健策略":
                leftText = "conser"
            default:
                leftText = "radic"
            }
        }else {
            rightText = (menu.contentText as NSString).substringToIndex(2)
            switch menu.contentText {
            case "10日收益榜":
                rightText = "10"
            case "60日收益榜":
                rightText = "60"
            default:
                rightText = "250"
            }
        }
       delegate?.transmitMenuItem(leftText, RightText: rightText)
    }
    
    //编辑完成后回调
    func dropDownMenu(menu: ZHDropDownMenu!, didInput text: String!) {
        print("\(menu.contentText) input text \(text)")
    }
    //点击判断点击状态
    func dropDownMenuShowState(left: Bool) {
        if left == true {
            if rightMenu.isShown == true {
              rightMenu.showOrHide()
            }
        }else {
            if leftMenu.isShown == true {
              leftMenu.showOrHide()
            }
        }
      
    }
}