//
//  RecommendIdxViewCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit


protocol RecommendIdxViewCellDataSource: class {
	func recommendIdxRatingBar(val: Int)
}

class RecommendIdxViewCell: UITableViewCell, RecommendIdxViewCellDataSource {

	@IBOutlet weak var ratingBar: RatingBar!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func recommendIdxRatingBar(val: Int) {
		ratingBar.rating = CGFloat(val * 2)
	}

}
