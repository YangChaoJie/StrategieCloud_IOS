//
//  ConditionPartsCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/24.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol ConditionPartsCellDelegate : NSObjectProtocol{
    func skipToDetailView(index: Int)
}
class ConditionPartsCell: UITableViewCell {
    let lineColor = UIColor.colorWith(232, green: 238, blue: 243, alpha: 1)
    var btns : [ConditionHeaderButton]? = []
    var delegate : ConditionPartsCellDelegate?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.grayColor()
        setBtnView()
        self.contentView.addSubview(VLabel)
        self.contentView.addSubview(VLabel1)
        self.contentView.addSubview(HLabel)
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
        
        let width : CGFloat = AppWidth/2
        let hight : CGFloat  = 75
        for i in 0  ..< 4  {
            let col = i%2
            let row = i/2
            let btn : ConditionHeaderButton =  ConditionHeaderButton.init(frame: CGRectMake((width + 0) * CGFloat(col), CGFloat(row)*(hight + 0), width, hight))
            btn.addTarget(self, action: #selector(buttonClick), forControlEvents: .TouchUpInside)
            btn.tag = i
            btns?.append(btn)
            self.contentView.addSubview(btn)
        }
    }
    
    func buttonClick(sender: ConditionHeaderButton) {
        self.delegate?.skipToDetailView(sender.tag)
    }
    
    func addmakeConstraints()  {
        let rowHeight = CGFloat(75)
        VLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
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
            make.centerX.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.height.equalTo(rowHeight - 20)
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
    
    //MARK: - 类方法加载cell
    class func conditionCellWithTableView(tableView: UITableView) ->ConditionPartsCell {
        let identifier = "ConditionCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? ConditionPartsCell
        if cell == nil {
            cell = ConditionPartsCell.init(style: .Default, reuseIdentifier: identifier)
        }
        return cell!
    }

}
