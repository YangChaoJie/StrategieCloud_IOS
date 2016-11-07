//
//  SectionHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/9/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol SectionHeaderViewDataSource: class {
    func sectionHeaderView(name name: String, profit: Double, idx: Int, using: Bool, section: Int, isExpanded: Bool,time:String)
}

protocol SectionHeaderViewDelegate: class {
	func sectionHeaderView(sectionHeaderView: SectionHeaderView, section: Int)
	func switchApplyStrategy(sectionHeaderView: SectionHeaderView, section: Int, switchOn: Bool)
}

class SectionHeaderView: UITableViewHeaderFooterView, SectionHeaderViewDataSource {
	private let disableColor = UIColor.NavBarColor()
        //UIColor.colorWith(70, green: 136, blue: 241, alpha: 1)
	@IBOutlet weak var arrowBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var strategyNameLabel: UILabel!
	@IBOutlet weak var totalProfitLabel: UILabel!
    @IBOutlet weak var recommendIdxBar: RatingBar! {
        didSet{
            recommendIdxBar.userInteractionEnabled = false
        }
    }
    
	@IBOutlet weak var usingSwitch: UISwitch!
	private var section: Int = 0
	var delegate: SectionHeaderViewDelegate?

	override func awakeFromNib() {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSwitch))
		self.userInteractionEnabled = true
		self.addGestureRecognizer(tapGesture)
	}
    
	@IBAction func usingSwitchTap(sender: UISwitch) {
		if (delegate != nil) {
            delegate?.switchApplyStrategy(self, section: section, switchOn: sender.on)
        }
	}

	@objc private func tapSwitch() {
		handleTap()
	}

	@IBAction func tapSwitchBtn() {
		handleTap()
	}

	private func handleTap() {
		if delegate != nil {
			delegate?.sectionHeaderView(self, section: section)
		}
	}

	// MARK: - SectionHeaderViewDataSource
    func sectionHeaderView(name name: String, profit: Double, idx: Int, using: Bool, section: Int, isExpanded: Bool,time:String) {
        timeLabel.text = time
		strategyNameLabel.text = name
		recommendIdxBar.rating = CGFloat(idx * 2)
		totalProfitLabel.text = String(format: "%.2f", profit * 100) + "%"
		totalProfitLabel.textColor = (profit > 0) ? UIColor.TextUpColor() : UIColor.TextDownColor()
       
		usingSwitch.setOn(using, animated: false)
		self.section = section

		if isExpanded {
			self.arrowBtn.setImage(UIImage(named: "上箭头"), forState: UIControlState.Normal)
		} else {
			self.arrowBtn.setImage(UIImage(named: "下箭头"), forState: UIControlState.Normal)
		}
	}
}
