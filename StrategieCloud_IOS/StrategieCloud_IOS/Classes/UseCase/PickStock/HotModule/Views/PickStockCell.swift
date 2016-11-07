//
//  PickStockCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol PickViewCellDelegate: class {
    func pickViewAddStock(name name: String, code: String)
}
class PickStockCell: UITableViewCell,HotDataSources {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var volumeImage: UIImageView!
    @IBOutlet weak var soaringImage: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: PickViewCellDelegate?
    let riseNumber = 24
    enum StockState : String{
        case soaring = "放量-拷贝-3"
        case volume = "急涨-拷贝-3"
    }
    var code: String = "" {
        didSet {
            codeLabel.text = (code as NSString).substringFromIndex(2)
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
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func addStockAction(sender: AnyObject) {
        print("name===\(self.code)")
        delegate?.pickViewAddStock(name: self.name, code: self.code)
    }
    func set(feature feature: [Int]) {
        if feature.count > 0 {
            if feature.count < 2 {
                setSoaringImageName(feature[0])
                volumeImage.image = nil
            }else if feature.count == 2 {
                setSoaringImageName(feature[0])
                setVolumeImageName(feature[1])
            }
        }
    }
    
    func setVolumeImageName(feature: Int) {
        if feature == riseNumber {
            volumeImage.image = UIImage.init(named: StockState.soaring.rawValue)
        }else {
            volumeImage.image = UIImage.init(named: StockState.volume.rawValue)
        }
    }
    
    func setSoaringImageName(feature: Int) {
        if feature == riseNumber {
            soaringImage.image = UIImage.init(named: StockState.soaring.rawValue)
        }else {
            soaringImage.image = UIImage.init(named: StockState.volume.rawValue)
        }
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
