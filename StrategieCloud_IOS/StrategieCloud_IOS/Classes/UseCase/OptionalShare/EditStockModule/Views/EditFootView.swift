//
//  EditFootView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol EditViewDelegate:NSObjectProtocol {
	func editViewBoxSelectAll(editViewBox: EditFootView, selectAll: Bool)
	func editViewBoxDelete(editViewBox: EditFootView)
}
class EditFootView: UIView {
    
    weak var delegate : EditViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.whiteColor()
		addSubview(selectAllBtn)
		addSubview(deleteBtn)
		addSubview(splitLine)
		addConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func addConstraints() {
		splitLine.snp_makeConstraints { (make) in
			make.leading.top.trailing.equalTo(self)
			make.height.equalTo(1)
		}
		
		let Padding = CGFloat(40)
		selectAllBtn.snp_makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.left.equalTo(self.snp_left).offset(Padding)
			make.height.equalTo(self)
			make.width.equalTo(80)
		}
		
		deleteBtn.snp_makeConstraints { (make) in
			make.centerY.equalTo(self)
			make.right.equalTo(self.snp_right).offset(-Padding)
			make.height.equalTo(self)
			make.width.equalTo(80)
		}
	}
	
	func selectAllBtnClick(sender: UIButton) {
		sender.selected = !sender.selected
		delegate?.editViewBoxSelectAll(self, selectAll: sender.selected)
	}
	
	func deleteBtnClick(sender: UIButton) {
		delegate?.editViewBoxDelete(self)
	}
	
	
	lazy var selectAllBtn: UIButton = {
		let button: UIButton = self.createButton("全选")
		button.setImage(UIImage(named: "未选中"), forState: UIControlState.Normal)
		button.setImage(UIImage(named: "未选中"), forState: UIControlState.Highlighted)
		button.setImage(UIImage(named: "选中"), forState: UIControlState.Selected)
		button.setTitle("取消", forState: UIControlState.Selected)
		button.setTitleColor(UIColor.colorWith(128, green: 130, blue: 142, alpha: 1.0), forState: UIControlState.Normal)
		button.setTitleColor(UIColor.colorWith(254, green: 75, blue: 74, alpha: 1.0), forState: UIControlState.Selected)
		button.addTarget(self, action: #selector(EditFootView.selectAllBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		return button
	}()
	
	lazy var deleteBtn: UIButton = {
		let button: UIButton = self.createButton("删除")
		button.enabled = false
		button.setImage(UIImage(named: "删除"), forState: UIControlState.Disabled)
		button.setImage(UIImage(named: "删除－高亮"), forState: UIControlState.Normal)
		button.setTitleColor(UIColor.colorWith(128, green: 130, blue: 142, alpha: 1.0), forState: UIControlState.Disabled)
		button.setTitleColor(UIColor.colorWith(254, green: 75, blue: 74, alpha: 1.0), forState: UIControlState.Normal)
		button.addTarget(self, action: #selector(EditFootView.deleteBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		return button
	}()
	
	private lazy var splitLine: UILabel = {
		let label = UILabel()
		label.backgroundColor = UIColor.colorWith(238, green: 238, blue: 238, alpha: 1.0)
		return label
	}()
	
	private func createButton(title:String) -> UIButton{
		let btn = UIButton()
		btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
		btn.titleLabel?.font = UIFont.systemFontOfSize(14)
		btn.titleLabel?.textAlignment = .Center
		btn.setTitle(title, forState: .Normal)
		return btn
	}
}
