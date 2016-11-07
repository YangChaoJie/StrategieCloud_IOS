//
//  ConditionHeaderButton.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/19.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class ConditionHeaderButton: UIButton, QuotationHeaderDataSource {
	
    var status : Int = 0
    
    var change : String = "" {
        didSet {
           changeLabel.text = self.change
            //String(format: "%.2f",(change as NSString).floatValue*100) + "%"
        }
    }
    
    var newPrice :String = "" {
        didSet {
           setLabelState()
           newPricelabel.text = String(format: "%.2f",(newPrice as NSString).floatValue)
        }
    }
    
    var partName: String = "" {
        didSet {
            partNamelabel.text = partName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(partNamelabel)
        self.addSubview(newPricelabel)
        self.addSubview(changeLabel)
        addmakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addmakeConstraints()  {
        partNamelabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(10)
        }
        
        newPricelabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(partNamelabel.snp_bottom).offset(3)
        }
        
        changeLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(newPricelabel.snp_bottom).offset(3)
        }
        
    }
    
    func setLabelState() {
        if status == 402 {
            self.newPricelabel.textColor = UIColor.TextUpColor()
        }else {
            self.newPricelabel.textColor = UIColor.TextDownColor()
        }
    }
    //MARK: - 懒加载控价
    private lazy var newPricelabel:UILabel = {
        let label =   self.createlabel("--")
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textColor = UIColor.TextUpColor()
        return label
    }()

    private lazy var changeLabel:UILabel = {
        let label =   self.createlabel("-- --")
        label.font = UIFont.systemFontOfSize(11)
        label.textColor = UIColor.TopHintTextColor()
        return label
    }()
    
    private lazy var partNamelabel:UILabel = {
        let label =   self.createlabel("--")
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.TopHintTextColor()
        return label
    }()
    
    func createlabel(title:String)->UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textAlignment = .Center
        label.text = title
        return label
    }
    
    func set(stockName name: String) {
        self.partName = name
    }
    
    func set(change change: String){
        self.change = change
    }
    
    func set(trend trend: Int){
        
    }
    
    func set(status status: Int){
        self.status = status
    }
   
    func set(changePct changePct: String){
        if self.status == 402 {
           self.change = "+" + String(format: "%.2f",(change as NSString).floatValue)  + "  +" + String(format: "%.2f",(changePct as NSString).floatValue*100) + "%"
        }else{
        self.change = String(format: "%.2f",(change as NSString).floatValue)  + "  " + String(format: "%.2f",(changePct as NSString).floatValue*100) + "%"
        }
    }
    
    func set(lastPrice price: String){
        self.newPrice = price
    }
    
}
