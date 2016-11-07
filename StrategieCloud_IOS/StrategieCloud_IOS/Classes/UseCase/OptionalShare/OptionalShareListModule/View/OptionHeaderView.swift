//
//  OptionHeaderView.swift
//  ArtOfWarCloud_IOS
//
//  Created by 杨超杰 on 16/4/12.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

enum OrderType {
	case Normal
	case PriceDescending
	case PriceAscending
	case RiseDescending
	case RiseAscending
}

protocol OptionHeaderViewDelegate: class {
	func optionHeaderViewOrderType(type: OrderType)
}

class OptionHeaderView: UIView {
	private enum ButtonState: Int {
		case Normal = 0
		case DescendingOrder = 1
		case AscendingOrder = 2
		
		func image() -> UIImage? {
			switch self {
			case .Normal:			return UIImage(named: "Artboard 1")
			case .DescendingOrder:	return UIImage(named: "向下箭头")
			case .AscendingOrder:	return UIImage(named: "向上箭头")
			}
		}
	}
	
	weak var delegate: OptionHeaderViewDelegate?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.colorWith(240, green: 244, blue: 250, alpha: 1)
		addSubview(strategyLabel)
		addSubview(nameLabel)
		addSubview(priceBtn)
		addSubview(riseBtn)
		addConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func restoreToNormalState() {
		priceBtn.tag = ButtonState.Normal.rawValue
		priceBtn.setImage(ButtonState.Normal.image(), forState: UIControlState.Normal)
		riseBtn.tag = ButtonState.Normal.rawValue
		riseBtn.setImage(ButtonState.Normal.image(), forState: UIControlState.Normal)
	}
	
	private func addConstraints() {
        
        strategyLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(10)
        }
        
		nameLabel.snp_makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.left.equalTo(self.strategyLabel.snp_right).offset(20)
		}
		
		riseBtn.snp_makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.right.equalTo(self.snp_right).offset(-15)
			make.width.equalTo(70)
		}
        
        priceBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self.riseBtn.snp_left).offset(-35)
            make.width.equalTo(80)
        }
	}
	
	private func changeButtonState(sender: UIButton) {
		if let state = ButtonState(rawValue: sender.tag) {
			switch state {
			case .Normal:
				sender.tag = ButtonState.DescendingOrder.rawValue
			case .DescendingOrder:
				sender.tag = ButtonState.AscendingOrder.rawValue
			case .AscendingOrder:
				
				sender.tag = ButtonState.Normal.rawValue
			}
			
			
			if let newState = ButtonState(rawValue: sender.tag) {
				sender.setImage(newState.image(), forState: UIControlState.Normal)
			}
		}
	}
	
	@objc private func priceBtnClick(sender: UIButton) {
		changeButtonState(sender)
		riseBtn.tag = ButtonState.Normal.rawValue
		riseBtn.setImage(ButtonState.Normal.image(), forState: UIControlState.Normal)
		
		if sender.tag == ButtonState.AscendingOrder.rawValue {
			delegate?.optionHeaderViewOrderType(OrderType.PriceAscending)
		} else if sender.tag == ButtonState.DescendingOrder.rawValue {
			delegate?.optionHeaderViewOrderType(OrderType.PriceDescending)
		} else {
			delegate?.optionHeaderViewOrderType(OrderType.Normal)
		}
	}
	
	@objc private func riseBtnClick(sender: UIButton) {
		changeButtonState(sender)
		priceBtn.tag = ButtonState.Normal.rawValue
		priceBtn.setImage(ButtonState.Normal.image(), forState: UIControlState.Normal)
		
		if sender.tag == ButtonState.AscendingOrder.rawValue {
			delegate?.optionHeaderViewOrderType(OrderType.RiseAscending)
		} else if sender.tag == ButtonState.DescendingOrder.rawValue {
			delegate?.optionHeaderViewOrderType(OrderType.RiseDescending)
		} else {
			delegate?.optionHeaderViewOrderType(OrderType.Normal)
		}
	}
	
	private lazy var nameLabel: UILabel = {
		let label =  self.createlabel("股票代码")
		return label
	}()
    
    //TO Do
    private lazy var strategyLabel: UILabel = {
        let label = self.createlabel("策略")
        return label
    }()
	
	private lazy var priceBtn: UIButton = {
		let button = self.createButton("最新价")
		button.addTarget(self, action: #selector(OptionHeaderView.priceBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		button.setImage(ButtonState.Normal.image(), forState: UIControlState.Normal)
		button.tag = ButtonState.Normal.rawValue
		return button
	}()
	
	private lazy var riseBtn: UIButton = {
		let button = self.createButton("涨跌幅")
		button.addTarget(self, action: #selector(OptionHeaderView.riseBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		button.setImage(ButtonState.Normal.image(), forState: UIControlState.Normal)
		button.tag = ButtonState.Normal.rawValue
		return button
	}()
	
	private func createButton(title:String) -> UIButton{
        
		let btn = UIButton()
		btn.titleLabel?.font = UIFont.systemFontOfSize(12)
		btn.titleLabel?.textAlignment = .Center
		btn.imageView?.contentMode = .Center
		btn.imageView?.clipsToBounds = false
		btn.setTitle(title, forState: .Normal)
        btn.layoutButtonEdgeInsets(.MKButtonEdgeInsetsStyleRight, space: 8)
		btn.setTitleColor(UIColor.colorWith(30, green: 144, blue: 255, alpha: 1), forState: .Normal)
		return btn
	}
	
	private func createlabel(title:String) -> UILabel {
		let label = UILabel()
		label.font = UIFont.systemFontOfSize(12)
		label.textAlignment = .Center
		label.text = title
		label.textColor = UIColor.colorWith(30, green: 144, blue: 255, alpha: 1)
		return label
	}
}
