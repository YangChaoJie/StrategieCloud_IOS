//
//  OptionBsHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol  OptionBsHeaderViewDataSource{
    func setDataToView(date: String)
}
class OptionBsHeaderView: UIView,OptionBsHeaderViewDataSource{
    let defalutColor = UIColor.colorWith(70, green: 136, blue: 241, alpha: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(timeButton)
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        timeButton.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(35)
            make.top.equalTo(0)
            make.height.equalTo(self)
            make.width.equalTo(60)
        }
    }
    
    private lazy var timeButton: UIButton = {
        let _timeButton = UIButton()
        _timeButton.backgroundColor = UIColor.whiteColor()
        _timeButton.userInteractionEnabled = false
        _timeButton.titleLabel?.textColor = self.defalutColor
        _timeButton.titleLabel?.textAlignment = .Center
        _timeButton.layer.borderColor = self.defalutColor.CGColor
        _timeButton.layer.cornerRadius = 6.0
        _timeButton.layer.borderWidth = 1.0
        _timeButton.setTitleColor(self.defalutColor, forState: .Normal)
        _timeButton.setTitle("今天", forState: .Normal)
        _timeButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        return _timeButton
    }()
    
    func setDataToView(date: String) {
        let day = (date as NSString).substringFromIndex(5)
        if day == helper.getCurrentDay() {
            self.timeButton.setTitle("今日", forState: .Normal)
        }else {
            self.timeButton.setTitle((date as NSString).substringFromIndex(5), forState: .Normal)
        }
    }
}