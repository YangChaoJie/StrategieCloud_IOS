//
//  OptionBsCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol OptionBsCellDataSource {
    func set(time time:String)
    func set(name name: String)
    func set(message message: String)
    func set(bs bs: Int)
}

class OptionBsCell: UITableViewCell,OptionBsCellDataSource {
    let customTextColor = UIColor.colorWith(146, green: 146, blue: 146, alpha: 1)
    let defalutColor = UIColor.colorWith(70, green: 136, blue: 241, alpha: 1)
    let subTitleColor = UIColor.colorWith(20, green: 20, blue: 20, alpha: 1)
    var name: String = "haha" {
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
            self.subTitleLabel.sizeToFit()
        }
    }
    
    var mBs: Int = Strategy.waitB.rawValue {
        didSet {
            if let type = Strategy(rawValue: mBs) {
                self.bsImageView.image = type.image()
                //self.bsImageView.contentMode = UIViewContentMode.Center
            }
        }
    }
    
    private enum Strategy: Int {
        case waitB = 3
        case waitS = 4
        case nWaitB = 5
        case nWaitS = 6
        case alreadyB = 1
        case alreadyS = 2
        
        func image()-> UIImage? {
            switch self {
            case .waitB : return UIImage(named:"待确认b")
            case .waitS : return UIImage(named:"待确认s")
            case .alreadyB : return UIImage(named:"new_icon_b")
            case .alreadyS : return UIImage(named:"new_icon_s")
            case .nWaitB: return UIImage(named:"new_icon_b")
            case .nWaitS : return UIImage(named:"new_icon_s")
            }
        }
    }
    
    //MARK: initView
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = UITableViewCellSelectionStyle.None
        contentView.addSubview(timeLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomLineView)
        contentView.addSubview(topLineView)
        contentView.addSubview(circleButton)
        contentView.addSubview(bsImageView)
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static let identifier = "OptionBsCell"
    class func orderStatusCell(tableView: UITableView) -> OptionBsCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? OptionBsCell
        if cell == nil {
            cell = OptionBsCell(style: UITableViewCellStyle.Default, reuseIdentifier: identifier)
        }
        return cell!
    }
    
    func incisionString(string:String)->[String] {
        let array: [String] = string.componentsSeparatedByString(",")
        return array
    }
    
    func layoutView(){
        let margin: CGFloat = 15
        timeLabel.frame = CGRectMake(margin+5, margin+5, 35, 20)
        circleButton.frame = CGRectMake(CGRectGetMaxX(timeLabel.frame) + 5, margin+10, 10, 10)
        titleLabel.frame = CGRectMake(CGRectGetMaxX(circleButton.frame) + 5, margin+5, width - circleButton.frame.origin.x, 20)
        topLineView.frame = CGRectMake((circleButton.center.x) - 1, 0, 1, 80)
        lineView.frame = CGRectMake(titleLabel.x, height - 1, width - titleLabel.x, 1)
        subTitleLabel.frame = CGRectMake(titleLabel.x , CGRectGetMaxY(titleLabel.frame) , AppWidth - titleLabel.frame.origin.x - margin*2, 40)
        bsImageView.frame = CGRect(x: CGRectGetMaxX(subTitleLabel.frame)+5, y: CGRectGetMaxY(titleLabel.frame) , width: 15, height: 15)
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
    
    
    private lazy var bottomLineView: UIView = {
        let _bottomLineView = UIView()
        _bottomLineView.backgroundColor = self.defalutColor
        return _bottomLineView
    }()
    
    private lazy var titleLabel: UILabel = {
        let _titleLabel = UILabel()
        _titleLabel.textColor = self.customTextColor
        _titleLabel.font = UIFont.systemFontOfSize(13)
        return _titleLabel
    }()
    
    private lazy var subTitleLabel:UILabel = {
        let _subTitleLabel = UILabel()
        _subTitleLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        _subTitleLabel.numberOfLines = 2
      
        _subTitleLabel.textColor =  self.subTitleColor
        _subTitleLabel.font = UIFont.systemFontOfSize(13)
        return _subTitleLabel
    }()
    
    private lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.backgroundColor = self.defalutColor
        return _lineView
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(13)
        label.text = "价格： 0.86"
        return label
    }()
    
    
    private lazy var bsImageView: UIImageView = {
        let _image = UIImageView()
        _image.image = UIImage.init(named: "icon_s")
        return _image
    }()
    
    private lazy var topLineView: UIView = {
        let _topLineView = UIView()
        _topLineView.backgroundColor = self.defalutColor
        _topLineView.alpha = 1
        return _topLineView
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
    
    func set(bs bs: Int) {
        self.mBs = bs
    }
}
