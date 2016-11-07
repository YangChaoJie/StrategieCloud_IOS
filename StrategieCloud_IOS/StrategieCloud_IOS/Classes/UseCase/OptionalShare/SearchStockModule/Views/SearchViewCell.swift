//
//  SearchViewCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/4.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit



protocol SearchViewCellDataSource: class {
	func set(stockName name: String)
	func set(stockCode code: String)
	func setAddBtnEnable(enable: Bool)
}

protocol SearchViewCellDelegate: class {
	func searchViewAddStock(name name: String, code: String)
}

class SearchViewCell: UITableViewCell, SearchViewCellDataSource  {
	
	var code: String = "" {
		didSet {
			stockCode.text = (code as NSString).substringFromIndex(2)
		}
	}
	
	var name: String = "" {
		didSet {
			stockName.text = name
		}
	}
	
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockCode: UILabel!
	@IBOutlet weak var addBtn: UIButton!
	
	weak var delegate: SearchViewCellDelegate?

	@IBAction func addStockClick() {
		delegate?.searchViewAddStock(name: self.name, code: self.code)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	// MARK: - SearchViewCellDataSource
    func set(stockName name: String) {
		self.name = name
    }
    
    func set(stockCode code: String) {
		self.code = code
    }
	
	func setAddBtnEnable(enable: Bool) {
		self.addBtn.enabled = enable
	}
}
