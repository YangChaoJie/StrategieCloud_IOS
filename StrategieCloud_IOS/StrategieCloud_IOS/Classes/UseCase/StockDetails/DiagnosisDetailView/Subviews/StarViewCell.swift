//
//  StarViewCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol StarBarDataSource {
    func set(star:Float)
    func set(stragety stragety:String)
}
class StarBarCell: UITableViewCell,StarBarDataSource {
    @IBOutlet weak var stragetyLabel: UILabel!

    @IBOutlet weak var starBar: RatingBar!
    override func awakeFromNib() {
        starBar.userInteractionEnabled = false
        starBar.rating = 4
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(star: Float) {
        self.starBar.rating = CGFloat(star)
    }
    
    func set(stragety stragety: String) {
        self.stragetyLabel.text = stragety
    }
    
}
