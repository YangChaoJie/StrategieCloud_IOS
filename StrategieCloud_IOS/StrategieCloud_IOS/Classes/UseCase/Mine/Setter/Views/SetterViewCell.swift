//
//  SetterViewCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol SetterCellDelegate: NSObjectProtocol {
    func setNotice(type: String,notice: Bool)
}
class SetterViewCell: UITableViewCell,SetterDataSource{
    let nameColor = UIColor.colorWith(53, green: 67, blue: 70, alpha: 1)
    
    @IBOutlet weak var mySwitch: UISwitch!
    @IBOutlet weak var nameLabel: UILabel!
    var delegate : SetterCellDelegate?
    var indexPath: NSIndexPath?
    var name: String = "" {
        didSet{
           nameLabel.text = name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.textColor = nameColor
        mySwitch.onTintColor = UIColor.NavBarColor()
        nameLabel.font = UIFont.systemFontOfSize(15)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(notice notice: Bool) {
        print("notice ===\(notice)")
        self.mySwitch.on = notice
    }
    
    func set(name name: String,indexPath: NSIndexPath) {
         self.indexPath = indexPath
         self.name = name
    }
 
    @IBAction func setSwitchNotice(sender: UISwitch) {
        switch indexPath!.section {
        case 0:
            if self.name == "异动信息" {
              self.delegate?.setNotice("glamour", notice: sender.on)
            }else if self.name == "BS点" {
              self.delegate?.setNotice("buysell", notice: sender.on)
            }
        default:
            self.delegate?.setNotice("liveinfo", notice: sender.on)
        }
     }
}
