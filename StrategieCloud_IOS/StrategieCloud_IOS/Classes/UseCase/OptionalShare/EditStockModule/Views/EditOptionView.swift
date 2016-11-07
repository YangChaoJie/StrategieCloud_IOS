//
//  EditOptionView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/5.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
class EditOptionView: UIViewController , EditStockViewProtocol {

    var presenter: EditStockPresenterProtocol?
    var selectedCount: Int = 0
    let footView = EditFootView.init(frame: CGRectMake(0, AppHeight-40-NavigationH, AppWidth,40))
    
    
    //MARK: View Life
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
		footView.delegate = self
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        presenter?.savePosition()
    }
    //MARK: Private Mothod
    private func commonInit() {
        presenter = EditStockPresenter()
        presenter!.view = self
        self.title = "编辑自选"
        self.view.addSubview(self.tableView)
        self.view.addSubview(footView)
        self.view.backgroundColor = UIColor.whiteColor()
        self.presenter!.getStock()
    }

    func setSelcetedCount() {
		self.footView.deleteBtn.enabled = selectedCount > 0
		if selectedCount == presenter?.numberOfItems(shareView: 0) {
			self.footView.selectAllBtn.selected = true
			if selectedCount == 0 {
				self.footView.selectAllBtn.selected = false
                self.footView.deleteBtn.enabled = false
            }else {
                self.footView.deleteBtn.enabled = true
            }
		} else {
            print("选中的个数是\(selectedCount)")
			self.footView.selectAllBtn.selected = false
		}
    }

    //MAKR: setter gettter
    private lazy var tableView : UITableView = {
        let _tableView = UITableView.init( frame: CGRectMake(0, 0, AppWidth, AppHeight-40-NavigationH))
        _tableView.registerNib(UINib(nibName: "EditViewCell", bundle: nil), forCellReuseIdentifier: "EditCellID")
        _tableView.allowsMultipleSelectionDuringEditing = true
        _tableView.editing = true
        _tableView.dataSource = self
        _tableView.delegate = self
		_tableView.tintColor = UIColor.colorWith(254, green: 75, blue: 74, alpha: 1.0)
        _tableView.tableFooterView = UIView.init()
        return _tableView
    }()

    // MARK: - EditStockViewProtocol
    
    func notifyFetchSuccess() {
        self.tableView.reloadData()
    }
    
    func notifyFetchFailure() {
        hudView.noticeOnlyText2("网络不给力啊")
    }
	
	func notifyMove(fromIndex index1: NSIndexPath, toIndex index2: NSIndexPath) {
		tableView.moveRowAtIndexPath(index1, toIndexPath: index2)
	}
    
    func deleteRowsAtIndexPaths(indexPath: [NSIndexPath]) {
        self.selectedCount = 0
        setSelcetedCount()
        tableView.deleteRowsAtIndexPaths(indexPath, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
  
}
//MARK: UITableViewDelegate
extension EditOptionView : UITableViewDelegate,UITableViewDataSource {
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter!.numberOfItems(shareView: section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditCellID")! as! EditViewCell
        presenter!.setContentToView(shareView: cell, indexPath: indexPath)
		cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = OptionEditHeadView.init(frame: CGRectMake(0, 0, AppWidth, 30));
        return headView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //在编辑状态，可以拖动设置cell位置
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    //移动cell事件
    func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath,
                   toIndexPath: NSIndexPath) {
        self.presenter!.moveItem(fromIndex: fromIndexPath, toIndex: toIndexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		selectedCount += 1
        setSelcetedCount()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
		selectedCount -= 1
        setSelcetedCount()
    }

}
//MARK: EditViewDelegate ManagerTableViewCellDelegate
extension EditOptionView : EditViewDelegate,ManagerTableViewCellDelegate {
	
	func editViewBoxSelectAll(editViewBox: EditFootView, selectAll: Bool) {
		for row in 0 ..< self.tableView.numberOfRowsInSection(0) {
			let indexPath = NSIndexPath(forRow: row, inSection: 0)
			if selectAll {
                selectedCount = self.tableView.numberOfRowsInSection(0)
				tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Top)
			} else {
                selectedCount  = 0
				tableView.deselectRowAtIndexPath(indexPath, animated: true)
			}
		}
        
        if self.tableView.numberOfRowsInSection(0) > 0 {
		  self.footView.deleteBtn.enabled = selectAll
        }
	}
	
	func editViewBoxDelete(editViewBox: EditFootView) {
		let selectedRows = tableView.indexPathsForSelectedRows!
		self.presenter!.delete(selectedRows)
	}

    func topClick(managerTableViewCell: EditViewCell,coding: String){
        let index = presenter?.findIndexPathByCode(coding)
        let path : NSIndexPath = NSIndexPath.init(forRow: index!, inSection: 0)
		presenter?.moveItem(fromIndex: path, toIndex: NSIndexPath(forRow: 0, inSection: 0))
    }
    
}

