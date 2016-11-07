//
//  UserInfoCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/2.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class UserInfoCell: UITableViewCell {

    @IBOutlet weak var userType: UILabel!
    @IBOutlet weak var contentText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContentToCell(userName : String, context : String){
        self.contentText.text = context
        self.userType.text = userName
    }
    
}
