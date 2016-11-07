//
//  ConditionHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/24.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
class ConditionHeaderView: UIView {
    let lineColor = UIColor.colorWith(232, green: 238, blue: 243, alpha: 1)
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor()
        setBtnView()
        self.addSubview(VLabel)
        self.addSubview(HLabel)
        self.addSubview(VLabel1)
        addmakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setBtnView() {
        let width : CGFloat = AppWidth/2
        let hight : CGFloat  = 75
        
        for i in 0  ..< 4  {
            let col = i%2
            let row = i/2
            let btn : ConditionHeaderButton = ConditionHeaderButton.init(frame: CGRectMake((width + 0) * CGFloat(col), CGFloat(row)*(hight + 0), width, hight))
            
            btn.tag = i
            self.addSubview(btn)
        }
    }
    
    func addmakeConstraints()  {
       VLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(self.height/2 - 20)
            make.width.equalTo(1)
        }
        
        HLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(self.width - 20)
            make.height.equalTo(1)
        }
        
        VLabel1.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-10)
            make.height.equalTo(self.height/2 - 20)
            make.width.equalTo(1)
        }
    }
    
   
    //MARK: getter and setter
    private lazy var VLabel:UILabel = {
        let label =   UILabel()
        label.backgroundColor = self.lineColor
        return label
    }()
    
    private lazy var VLabel1:UILabel = {
        let label =   UILabel()
        label.backgroundColor = self.lineColor
        return label
    }()
    
    private lazy var HLabel:UILabel = {
        let label =   UILabel()
        label.backgroundColor = self.lineColor
        return label
    }()
}
