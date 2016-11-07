//
//  ConditionButton.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/24.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class ConditionButton: UIButton ,IndustrynDataSource{
    let companyColor = UIColor.colorWith(146, green: 160, blue: 173, alpha: 1)
    var option = ""
    var percentage :Double = 0 {
        didSet {
            if percentage >= 0 {
              changeLabel.text =  String(format: "%.2f",self.change)  + "  +" + String(format: "%.2f",percentage) + "%"
            }else {
              changeLabel.text =  String(format: "%.2f",self.change)  + "  " + String(format: "%.2f",percentage) + "%"
            }
        }
    }
    var status : Int = 0 {
        didSet {
            
        }
    }
    
    var change : Double = 0 {
        didSet {
          
        }
    }
    
    var newPrice :Double = 0 {
        didSet {
            if newPrice >= 0 {
               newPricelabel.text = "+" + String(format: "%.2f",newPrice) + "%"
            }else if newPrice < 0 {
               newPricelabel.textColor = UIColor.TextDownColor()
               newPricelabel.text = String(format: "%.2f",newPrice) + "%"
            }
        }
    }
    
    var partName: String = "" {
        didSet {
            partNamelabel.text = name
        }
    }
    
    var name: String = "" {
        didSet {
            nameLabel.text = partName
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(partNamelabel)
        self.addSubview(nameLabel)
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
        
        nameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(newPricelabel.snp_bottom).offset(3)
        }
        
        changeLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(nameLabel.snp_bottom).offset(3)
        }
        
    }
    //MARK: - 懒加载控价
    //名字标签
    private lazy var nameLabel:UILabel = {
        let label =   self.createlabel("--")
        label.font = UIFont.systemFontOfSize(11)
        label.textColor = self.companyColor
        return label
    }()
    
    private lazy var newPricelabel:UILabel = {
        let label =   self.createlabel("--")
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textColor = UIColor.TextUpColor()
        return label
    }()
    
    private lazy var changeLabel:UILabel = {
        let label =   self.createlabel("--  --")
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
        partName = name
    }
    
    func set(change change: Double) {
        self.newPrice = change
    }
    
    func set(industryName name: String){
         self.name = name
    }
    
    func set(changePct changePct: Double){
        self.change = changePct
    }
    
    func set(percentage percentage: Double){
        self.percentage = percentage
    }
    
    func set(number number:String){
        self.option = number
    }
}
