//
//  BSPointCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol BSPointDataSources {
    func set(stockName name: String)
    func set(stockCode code: String)
    func set(coordinate coordinate: String)
    func set(feature feature: Int)
    func setAddBtnEnable(enable: Bool)
}
protocol BSPointCellDelegate: class {
    func pickViewAddStock(name name: String, code: String)
}
class BSPointCell: UITableViewCell,BSPointDataSources {
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var BSImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: BSPointCellDelegate?
    let buyNumber = 1
    var bs :Int = 0 {
        didSet {
            if let type = Strategy(rawValue: bs) {
                self.BSImage.image = type.image()
            }
        }
    }

    enum StockState : String{
        case buy = "icon_b"
        case sell = "icon_s"
    }
    var code: String = "" {
        didSet {
            codeLabel.text = (code as NSString).substringFromIndex(2)                //
        }
    }
    
    private enum Strategy: Int {
        case waitB = 3
        case waitS = 4
        case alreadyB = 1
        case alreadyS = 2
        
        func image()-> UIImage? {
            switch self {
            case .waitB : return UIImage(named:"未确认B")
            case .waitS : return UIImage(named:"未确认S")
            case .alreadyB : return UIImage(named:"icon_b")
            case .alreadyS : return UIImage(named:"icon_s")
            }
        }
    }
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func addStockAction(sender: AnyObject) {
        delegate?.pickViewAddStock(name: self.name, code: self.code)
        
    }
    func set(feature feature: Int) {
        bs = feature
    }
    
    func set(coordinate coordinate: String) {
        timeLabel.text = coordinate
    }
    
    func set(stockName name: String) {
        self.name = name
    }
    
    func set(stockCode code: String) {
        self.code = code
    }
    
    func setAddBtnEnable(enable: Bool){
        self.addButton.enabled = enable
    }
    
}
