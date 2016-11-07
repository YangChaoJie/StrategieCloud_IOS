//
//  StrategyListViewController.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/9/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class StrategyListViewController: BaseVC {

	private struct Nib {
		static let Section = "SectionHeaderView"
		static let Profit = "ProfitTableViewCell"
		static let Chart = "StrategyChartTableViewCell"
	}
	
	private struct NibID {
		static let Section = "SectionHeaderViewID"
		static let Profit = "ProfitTableViewCellID"
		static let Chart = "StrategyChartTableViewCellID"
	}
	private let EachSectionCellCount = Int(2)
	
    

	var stockCode: String?
	var requestSuccess = false
	
	private var presenter: StrategyListPresenterProtocol!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = StrategyListPresenter(view: self)
        view.backgroundColor = UIColor.colorWith(240, green: 244, blue: 255, alpha: 1.0)
		self.view.addSubview(tableView)
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		if let code = stockCode {
			presenter.gainStrategyListFromServer(withCode: code)
		}
	}
    

	override func viewWillLayoutSubviews() {
		tableView.snp_makeConstraints { (make) in
			make.leading.trailing.bottom.equalTo(self.view)
			make.top.equalTo((self.navigationController?.navigationBar.snp_bottom)!)
		}
	}
	
	@objc private func close() {
		dismissViewControllerAnimated(true, completion: nil)
		
	}
    
    func showToEmptyView() {
		if requestSuccess {
			let number = presenter.numberOfSection()
			if number <= 0 {
				self.tableView.backgroundView = Empty
			} else {
				self.tableView.backgroundView = nil
			}
		}
    }
	
	private lazy var tableView: UITableView = {
		let _tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
		_tableView.registerNib(UINib(nibName: Nib.Section, bundle: nil), forHeaderFooterViewReuseIdentifier: NibID.Section)
		_tableView.registerNib(UINib(nibName: Nib.Profit, bundle: nil), forCellReuseIdentifier: NibID.Profit)
		_tableView.registerNib(UINib(nibName: Nib.Chart, bundle: nil), forCellReuseIdentifier: NibID.Chart)
		//_tableView.backgroundColor = UIColor.colorWith(240, green: 244, blue: 255, alpha: 1.0)
		_tableView.dataSource = self
		_tableView.delegate = self
        _tableView.tableHeaderView = self.headerView
		return _tableView
	}()
    
    private lazy var headerView : StragegyListHeaderView = {
       let view = StragegyListHeaderView.init(frame: CGRectMake(0, 0, self.view.frame.width, 30))
        return view
    }()
    
    private lazy var Empty: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.frame = self.tableView.frame
        label.text = "此股票不建议使用h333策略"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
}

// MARK: - StrategyListViewProtocol
extension StrategyListViewController: StrategyListViewProtocol {
	func notifyFetchSuccess() {
		requestSuccess = true
		tableView.reloadData()
		self.noticeTop("策略更新成功 "+helper.getCurrentTime())
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
	}
	
	func notifyFetchFailure() {
		requestSuccess = false
		self.noticeOnlyText2("网络不给力啊")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
	}

	func reloadSection(section: Int) {
		let sections = NSIndexSet(index: section)
		tableView.reloadSections(sections, withRowAnimation: UITableViewRowAnimation.Automatic)
	}

	func reloadSections(sectionCount: Int) {
		let set = NSIndexSet(indexesInRange: NSRange(location: 0, length: sectionCount))
		tableView.reloadSections(set, withRowAnimation: UITableViewRowAnimation.None)
	}
    
    func notifyUsingFailure() {
        self.noticeOnlyText2("网络不给力，应用失败")
    }

	func reloadCells(withSection section: Int) {
		let indexPaths = [
			NSIndexPath(forRow: 0, inSection: section),
			NSIndexPath(forRow: 1, inSection: section)
		]
		tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
	}
}

// MARK: - SectionHeaderViewDelegate
extension StrategyListViewController: SectionHeaderViewDelegate {
	func sectionHeaderView(sectionHeaderView: SectionHeaderView, section: Int) {
		presenter.switchExpandSection(section)
	}

	func switchApplyStrategy(sectionHeaderView: SectionHeaderView, section: Int, switchOn: Bool) {
        if presenter.isOptionalShare(stockCode: stockCode!){
            presenter.switchApplyStrategy(section, code: stockCode!, switchOn: switchOn)
        }else{
            if !switchOn {
              helper.alertShow("添加自选后可关闭策略")
              self.reloadSection(section)
            }else{
              presenter.switchApplyStrategy(section, code: stockCode!, switchOn: switchOn)
            }
        }
	}
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension StrategyListViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        showToEmptyView()
		return presenter.numberOfSection()
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if presenter.expanededOfSection(section) {
			return EachSectionCellCount
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCellWithIdentifier(NibID.Profit, forIndexPath: indexPath) as! ProfitTableViewCell
			cell.selectionStyle = UITableViewCellSelectionStyle.None
			presenter.setContentOfProfit(indexPath.section, dataSource: cell)
			return cell
		} else {
			let cell = tableView.dequeueReusableCellWithIdentifier(NibID.Chart, forIndexPath: indexPath) as! StrategyChartTableViewCell
			cell.selectionStyle = UITableViewCellSelectionStyle.None
			presenter.setContentOfChart(indexPath.section, dataSource: cell)
			return cell
		}
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier(NibID.Section) as! SectionHeaderView
		headerView.delegate = self
        presenter.setContentOfSection(section, dataSource: headerView)
		return headerView
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat(78)
	}

	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat(10)
	}

	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if (indexPath.row == 0) {
			return CGFloat(77)
		} else {
			return CGFloat(200)
		}
	}
}
