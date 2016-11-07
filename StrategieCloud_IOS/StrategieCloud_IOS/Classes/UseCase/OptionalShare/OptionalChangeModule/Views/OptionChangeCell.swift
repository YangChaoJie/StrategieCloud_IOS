//
//  OptionChangeCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
enum OrderStateType: Int {
    case Top = 0
    case Middle = 1
    case Bottom = 2
    case Section = 3
}
protocol OptionChangeCellDataSource {
    func set(time time:String)
    func set(name name: String)
    func set(message message: String)
}
class OptionChangeCell: UITableViewCell ,OptionChangeCellDataSource{
    let customTextColor = UIColor.colorWith(146, green: 146, blue: 146, alpha: 1)
    let defalutColor = UIColor.colorWith(70, green: 136, blue: 241, alpha: 1)
    let subTitleColor = UIColor.colorWith(20, green: 20, blue: 20, alpha: 1)
    var name: String = "" {
        didSet{
           self.titleLabel.text = name
        }
    }
    
    var time: String = ""{
        didSet{
           self.timeLabel.text = time
        }
    }
    
    var message: String = "" {
        didSet{
           self.subTitleLabel.text = message
        }
    }
    
    var orderStateType: OrderStateType? {
        didSet {
            switch orderStateType!.hashValue {
            case OrderStateType.Top.hashValue:
                circleButton.selected = true
                bottomLineView.hidden = false
                topLineView.hidden = false
                lineView.hidden = true
                subTitleLabel.numberOfLines = 1
                break
            case OrderStateType.Middle.hashValue:
                circleButton.selected = false
                bottomLineView.hidden = false
                topLineView.hidden = false
                lineView.hidden = true
                timeButton.hidden = false
                subTitleLabel.numberOfLines = 1
                break
            case OrderStateType.Bottom.hashValue:
                bottomLineView.hidden = false
                topLineView.hidden = false
                lineView.hidden = true
                circleButton.selected = false
                subTitleLabel.numberOfLines = 0
                timeButton.hidden = true
                break
            case OrderStateType.Section.hashValue:
                circleButton.selected = true
                bottomLineView.hidden = false
                topLineView.hidden = false
                lineView.hidden = true
                subTitleLabel.numberOfLines = 1
                break
            default: break
            }
            
        }
    }
    //MARK: initView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //点击cell后，状态不会改变
        selectionStyle = UITableViewCellSelectionStyle.None
        contentView.addSubview(timeLabel)
        contentView.addSubview(topLineView)
        contentView.addSubview(subTitleLabel)
       // contentView.addSubview(lineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomLineView)
        contentView.addSubview(circleButton)
       
        layoutView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static let identifier = "OptionChangeCell"
    class func orderStatusCell(tableView: UITableView) -> OptionChangeCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? OptionChangeCell
        if cell == nil {
            cell = OptionChangeCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//     
//    }
    
    func layoutView(){
        let margin: CGFloat = 15
        timeLabel.frame = CGRectMake(margin + 5, margin+10, 35, 20)
        circleButton.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame) + 5, margin*2, 10, 10)
       
        topLineView.frame = CGRectMake((circleButton.center.x) - 1, 0, 1, AppHeight)
         //print("坐标是=====\(topLineView.x,topLineView.y)")
        titleLabel.frame = CGRectMake(CGRectGetMaxX(circleButton.frame) + 5, margin+10, width - CGRectGetMaxX(circleButton.frame) - 20, 20)
        subTitleLabel.frame = CGRectMake(titleLabel.x, CGRectGetMaxY(titleLabel.frame) , width - titleLabel.frame.origin.x, 30)
    }
    //MARK: setter and setter
    private lazy var timeLabel: UILabel = {
      let   _timeLabel = UILabel()
        _timeLabel.textColor = self.customTextColor
        _timeLabel.textAlignment = NSTextAlignment.Right
        _timeLabel.font = UIFont.systemFontOfSize(12)
        return _timeLabel
    }()
    
    private lazy var circleButton: UIButton = {
      let   _circleButton = UIButton()
        _circleButton.userInteractionEnabled = false
        _circleButton.backgroundColor = self.defalutColor
        _circleButton.layer.cornerRadius = 5
        return _circleButton
    }()
    
    private lazy var topLineView: UIView = {
       let _topLineView = UIView()
        _topLineView.backgroundColor = self.defalutColor
        _topLineView.alpha = 1
        return _topLineView
    }()
    
    private lazy var bottomLineView: UIView = {
        let _bottomLineView = UIView()
        _bottomLineView.backgroundColor = self.defalutColor
        return _bottomLineView
    }()
    
    private lazy var titleLabel: UILabel = {
       let _titleLabel = UILabel()
        _titleLabel.textColor = self.customTextColor
        _titleLabel.font = UIFont.systemFontOfSize(14)
        return _titleLabel
    }()
    
    private lazy var subTitleLabel:UILabel = {
       let _subTitleLabel = UILabel()
        _subTitleLabel.textColor =  self.subTitleColor
        _subTitleLabel.font = UIFont.systemFontOfSize(14)
        return _subTitleLabel
    }()
    
    private lazy var lineView: UIView = {
       let _lineView = UIView()
        _lineView.backgroundColor = self.defalutColor
        return _lineView
    }()
    
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
        _timeButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        return _timeButton
    }()
    //MARK: OptionChangeCellDataSource
    func set(name name: String) {
        self.name = name
    }
    
    func set(time time: String) {
        self.time = time
    }
    
    func set(message message: String) {
        self.message = message
    }
}
