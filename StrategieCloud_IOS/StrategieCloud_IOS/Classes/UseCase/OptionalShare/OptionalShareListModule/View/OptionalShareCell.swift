//
//  OptionalShareCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol OptionShareCellDelegate: class {
    func skipToStartegyView(stockCode:String,name:String)
}
class OptionalShareCell: UITableViewCell, OptionalShareListDataSources {

    @IBOutlet weak var stategyBtn: UIButton!
    @IBOutlet weak var trendImage: UIImageView!
    @IBOutlet weak var lastPrice: UILabel!
    @IBOutlet weak var stockCode: UILabel!
    @IBOutlet weak var stockName: UILabel!
	@IBOutlet weak var changePctLabel: UILabel!
	@IBOutlet weak var statusImg: UIImageView!
    weak var delagete: OptionShareCellDelegate?
    var code: String =  "" {
        didSet{
            stockCode.text = (code as NSString).substringFromIndex(2)
        }
    }
    var name: String = "" {
        didSet{
            stockName.text = name
        }
    }
	private enum Trend: Int {
		case Empty = 501
		case Up = 502
		case LitteUp = 503
		case LitteDown = 504
		case Down = 505
		
		func image() -> UIImage? {
			switch self {
			case .Empty:	return nil
			case .Up:		return UIImage(named: "箭头1")
			case .LitteUp:	return UIImage(named: "箭头2")
			case .LitteDown:return UIImage(named: "箭头3")
			case .Down:		return UIImage(named: "箭头4")
			}
		}
	}
	
    private enum Strategy: Int {
        case real = 1
        case fake = 0
        
        func image() -> UIImage? {
            switch self {
            case .real: return UIImage(named: "icon_stock_strategy")
            case .fake:
            return nil
            }
        }
        
    }
    
	private enum Status: Int {
		case Stop = 401
		case Rise = 402
		case Fall = 403
		
		func image() -> UIImage? {
			switch self {
			case .Stop:	return UIImage(named: "圆角矩形-灰")
			case .Rise:	return UIImage(named: "圆角矩形-红")
			case .Fall:	return UIImage(named: "圆角矩形-绿")
			}
		}
	}
	
	
	private var mTrend: Int = Trend.Empty.rawValue {
		didSet {
			if let trendType = Trend(rawValue: mTrend) {
				self.trendImage.image = trendType.image()
			}
		}
	}
    
    private var mStrategy: Int = Strategy.real.rawValue {
        didSet{
            if let type  = Strategy(rawValue: mStrategy) {
                    self.stategyBtn.setImage(type.image(), forState: .Normal)
                
            }
        }
    }
	
	private var mStatus: Int = Status.Rise.rawValue {
		didSet {
			if let statusType = Status(rawValue: mStatus) {
				self.statusImg.image = statusType.image()
			}
		}
	}
    
    private lazy var backView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    @IBAction func strategtyAction(sender: UIButton) {
        print(#function)
        delagete?.skipToStartegyView(self.code,name: name)
    }
    
	// MARK: - OptionalShareDataSources
    func set(stockName name: String) {
        self.name = name
    }
    
    func set(stockCode code: String) {
        self.code = code
    }
    
    func set(change change: String){
    }
    
    func set(trend trend: Int){
		self.mTrend = trend
    }
	
	func set(changePct changePct: String, status: Int) {
		mStatus = status
		if changePct.isEmpty {
			self.changePctLabel.text = "--"
			self.statusImg.image = Status.Stop.image()
		} else {
			if ((changePct as NSString).floatValue == 0) {
				self.statusImg.image = Status.Stop.image()
			}
			
			if mStatus == Status.Stop.rawValue {
				self.changePctLabel.text = "停牌"
			} else {
				self.changePctLabel.text = Converts.percentStrFromDecimalPlacesStr(changePct)
			}
		}
	}
    
    func set(lastPrice price: String){
		if price.isEmpty {
			self.lastPrice.text = "--"
		} else {
			self.lastPrice.text = String(format: "%.2f",(price as NSString).floatValue)
		}
    }
    
    func set(strategy isStategy: Bool) {
        self.mStrategy = isStategy.hashValue
        self.stategyBtn.enabled = isStategy
    }
    
}
