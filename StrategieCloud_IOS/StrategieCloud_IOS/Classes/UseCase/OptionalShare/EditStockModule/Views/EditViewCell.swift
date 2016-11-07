//
//  EditViewCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol ManagerTableViewCellDelegate:NSObjectProtocol {
    func topClick(managerTableViewCell: EditViewCell,coding:String)
}

class EditViewCell: UITableViewCell ,OptionalDataSources{
    @IBOutlet weak var goFirst: UIButton!
    @IBOutlet weak var stockName: UILabel!
    @IBOutlet weak var stockCode: UILabel!

    var delegate : ManagerTableViewCellDelegate?
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func goFirst(sender: AnyObject) {
      self.delegate?.topClick(self,coding: stockCode.text!)
    }
    
    // MARK: - OptionalShareDataSources
    func set(stockName name: String) {
        stockName.text = name
    }
    
    func set(stockCode code: String) {
        stockCode.text = (code as NSString).substringFromIndex(2)
    }
}
