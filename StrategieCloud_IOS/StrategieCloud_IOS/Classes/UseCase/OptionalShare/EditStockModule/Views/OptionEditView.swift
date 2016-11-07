//
//  OptionEditView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class OptionEditHeadView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
		self.backgroundColor = UIColor.whiteColor()
		
        addSubview(stockNameLabel)
        addSubview(stockCodeLabel)
        addSubview(stickLabel)
        addSubview(dragLabel)
        addSubview(self.line)
        addmakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addmakeConstraints()  {
        let  width = 50
        let padding = 40
        
        stockNameLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(width)
            make.width.equalTo(width)
        }
        
        stockCodeLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(-6)
            make.width.equalTo(width)
        }
        
        dragLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.snp_right).offset(-padding)
            make.width.equalTo(width/2)
            
        }
        
        stickLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(dragLabel.snp_left).offset(-60)
            make.width.equalTo(width/2)
        }
        
        
        
        line.snp_makeConstraints { (make) in
            make.width.equalTo(self)
            make.top.equalTo(self.snp_bottom).offset(-1)
            make.height.equalTo(1)
        }
        
        
    }
    //MARK: - 懒加载控件
    //名字标签
    private lazy var stockNameLabel:UILabel = {
        let label =  self.createlabel("股票名称")
        return label
    }()
    
    //最新价格标签
    private lazy var stockCodeLabel:UILabel = {
        let label =  self.createlabel("股票代码")
        return label
    }()
    //涨跌幅标签
    private lazy var stickLabel:UILabel = {
        let label =  self.createlabel("置顶")
        return label
    }()
    //预警标签
    private lazy var dragLabel:UILabel = {
        let label = self.createlabel("拖动")
        return label
    }()
    
    private lazy var line:UILabel = {
        let line = UILabel()
        line.backgroundColor = UIColor.TopSplitLineColor()
        return line
    }()
    
    //MARK: - 协议方法
    func createlabel(title:String)->UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
		label.textColor = UIColor.TopHintTextColor()
        label.textAlignment = .Center
        label.text = title
        return label
    }
}
