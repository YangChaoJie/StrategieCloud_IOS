//
//  ConditionIndustryCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol ConditionIndustryCellDelegate : NSObjectProtocol{
    func skipToDetailView(option: String,name : String)
}
class ConditionIndustryCell: UITableViewCell {
    let lineColor = UIColor.colorWith(232, green: 238, blue: 243, alpha: 1)
    var btns : [ConditionButton!]? = []
    var delegete : ConditionIndustryCellDelegate?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.grayColor()
        setBtnView()
        self.contentView.addSubview(VLabel)
        self.contentView.addSubview(VLabel1)
        self.contentView.addSubview(HLabel)
        self.contentView.addSubview(VLabel2)
        self.contentView.addSubview(VLabel3)
        addmakeConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setBtnView() {
        let width : CGFloat = AppWidth/3
        let hight : CGFloat  = 95
        for i in 0  ..< 6  {
            let col = i%3
            let row = i/3
            let btn : ConditionButton =  ConditionButton.init(frame: CGRectMake((width + 0) * CGFloat(col), CGFloat(row)*(hight + 0), width, hight))
            btn.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
            btn.tag = i
            btns?.append(btn)
            self.contentView.addSubview(btn)
        }
    }
    
    func addmakeConstraints()  {
        let rowHeight = CGFloat(95)
        let width = AppWidth/3
        VLabel.snp_makeConstraints { (make) in
            make.left.equalTo(width)
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(rowHeight - 20)
            make.width.equalTo(1)
        }
        
        VLabel2.snp_makeConstraints { (make) in
            make.left.equalTo(width*2)
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(rowHeight - 20)
            make.width.equalTo(1)
        }
        
        HLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.contentView)
            make.left.equalTo(self.contentView).offset(10)
            make.width.equalTo(AppWidth - 20)
            make.height.equalTo(1)
        }
        
        VLabel1.snp_makeConstraints { (make) in
            make.left.equalTo(width)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.height.equalTo(rowHeight - 20)
            make.width.equalTo(1)
        }
        
        VLabel3.snp_makeConstraints { (make) in
            make.left.equalTo(width*2)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.height.equalTo(rowHeight - 20)
            make.width.equalTo(1)
        }
        
    }
    
    func buttonClick(sender: ConditionButton) {
        self.delegete?.skipToDetailView(sender.option,name : sender.name)
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
    
    private lazy var VLabel2:UILabel = {
        let label =   UILabel()
        label.backgroundColor = self.lineColor
        return label
    }()
    
    private lazy var VLabel3:UILabel = {
        let label =   UILabel()
        label.backgroundColor = self.lineColor
        return label
    }()
    
    private lazy var HLabel:UILabel = {
        let label =   UILabel()
        label.backgroundColor = self.lineColor
        return label
    }()
    
    //MARK: - 类方法加载cell
    class func conditionCellWithTableView(tableView: UITableView) ->ConditionIndustryCell {
        let identifier = "ConditionIndustryCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ConditionIndustryCell
        if cell == nil {
            cell = ConditionIndustryCell.init(style: .Default, reuseIdentifier: identifier)
        }
        return cell!
    }

}
