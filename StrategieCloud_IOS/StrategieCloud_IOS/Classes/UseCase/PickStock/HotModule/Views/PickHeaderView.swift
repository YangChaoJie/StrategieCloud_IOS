//
//  PickHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/15.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
class PickHeaderView: UIView {
    var timeLabel:UILabel?
    enum LabelName : String{
        case time = "信号时间"
        case feature = "特征"
        case option = "自选"
        case name = "名称代码"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addlayout()
        addSubview(stockNameLabel)
        addSubview(timeLabel!)
        addSubview(featureLabel)
        addSubview(optionLabel)
        addSubview(line)
        addmakeConstraints()
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addlayout() {
        self.timeLabel = self.createlabel(LabelName.time.rawValue)
    }
    func addmakeConstraints()  {
        let  width = 56
        let padding = 45
        
        stockNameLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
            make.width.equalTo(width)
        }
        
        timeLabel!.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.stockNameLabel.snp_right).offset(padding)
            make.width.equalTo(width)
        }
        
        optionLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp_right).offset(-padding+8)
            make.width.equalTo(width/2)
            
        }
        
        featureLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(optionLabel.snp_left).offset(-70)
            make.width.equalTo(width/2)
        }
        
        line.snp_makeConstraints { (make) in
            make.width.equalTo(self)
            make.top.equalTo(self.snp_bottom).offset(-1)
            make.height.equalTo(0.5)
        }
        
        
    }
    //MARK: - 懒加载控件
    //名字标签
    private lazy var stockNameLabel:UILabel = {
        let label =  self.createlabel(LabelName.name.rawValue)
        return label
    }()
    
    //涨跌幅标签
    private lazy var featureLabel:UILabel = {
        let label =  self.createlabel(LabelName.feature.rawValue)
        return label
    }()
    //预警标签
    private lazy var optionLabel:UILabel = {
        let label = self.createlabel(LabelName.option.rawValue)
        label.textAlignment = .Left
        return label
    }()
    
    private lazy var line:UILabel = {
        let line = UILabel()
        line.backgroundColor = UIColor.colorWith(229, green: 235, blue: 240, alpha: 1.0)
        return line
    }()
    
    //MARK: - 协议方法
    func createlabel(title:String)->UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
		label.textColor = UIColor.colorWith(53, green: 67, blue: 70, alpha: 1.0)
        label.text = title
        return label
    }
}
