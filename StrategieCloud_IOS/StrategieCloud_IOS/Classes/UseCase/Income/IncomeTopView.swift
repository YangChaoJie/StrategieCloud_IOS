//
//  MessageViewController.swift
//  ArtOfWarCloud_IOS
//
//  Created by 杨超杰 on 16/4/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import MJRefresh
class IncomeTopView: BaseVC,IncomeTopViewProtocol {
    var presenter: IncomeTopPresenterProtocol?
    var leftText: String = "both"
    var rightText: String = "10"
    let header = MJRefreshNormalHeader()
    //let footer = MJRefreshAutoNormalFooter()
    let footHeight = CGFloat(10)
    var index = 0
    struct Nib {
    
        static let CellName = "ProfitCell"
    }
    
    struct Cell {
        static let CellID = "ProfitCellID"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.refreshBtn.loadingMore(self.refreshBtn, auto: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageName = "点兵-收益榜"
        view.addSubview(tableView)
        initCommmit()
        initNavTitileView()
        pushRefresh()
        tableView.tableHeaderView = self.tableHeaderView
    }
    
    // MARK: - IncomeStockViewProtocol
    func notifyFetchSuccess() {
        print(#function)
        self.refreshBtn.lodingNot()
        self.tableView.reloadData()
        hudView.noticeTop("收益榜更新成功 "+helper.getCurrentTime())
        // 结束刷新
        self.tableView.mj_header.endRefreshing()
    }
    
    func notifyFetchFailure() {
        hudView.noticeOnlyText2("网络不给力啊")
        self.tableView.mj_header.endRefreshing()
        self.refreshBtn.lodingNot()
        print(#function)
    }
    
    //MARK: 调转到详情页面
    func skipToDetailView(roughStocks: [RoughStock],index: Int) {
		let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
		vc.currentRoughStockPos = index
		vc.roughStocks = roughStocks
		StockDetailsView.FromProfitRank = true
		self.navigationController?.pushViewController(vc, animated: true)
    }
	
    //MARK: private Method
    private func initCommmit() {
        presenter = IncomeTopPresenter()
        presenter?.view = self
    }
    
    
    
    private func pushRefresh(){
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        /*上拉刷新 To Do
        * footer.setRefreshingTarget(self, refreshingAction: #selector(footerRefresh))
        * tableView.mj_footer = footer
        */
        tableView.mj_header = header
        
        helper.setHeaderRefresh(header)
    }
    
    func headerRefresh() {
        hudView.clearAllNotice()
        self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
    }
    
   /* To DO
    *
     func footerRefresh() {
        //按页数刷新
        self.tableView.mj_footer.endRefreshing()
        // 2次后模拟没有更多数据
        index = index + 1
        if index > 3 {
            footer.endRefreshingWithNoMoreData()
        }
    }
    */
    private func initNavTitileView()  {
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView:  refreshBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    //MARK: setter and getter
    private lazy var tableView : UITableView = {
        let _tableView = UITableView.init(frame: CGRectMake(0, 0, AppWidth, AppHeight-NavigationH-TabH))
        _tableView.rowHeight = 50
        _tableView.registerNib(UINib(nibName: Nib.CellName, bundle: nil), forCellReuseIdentifier: Cell.CellID)
        _tableView.dataSource = self
        _tableView.delegate = self
        return _tableView
    }()
    
    private lazy var headView: ProfitHeaderView = {
        let _view = ProfitHeaderView.init(frame: CGRectMake(0, 0, AppWidth, HeaderH))
        _view.delegate = self
        return _view
    }()
    
    private lazy var refreshBtn : LoadingButton = {
        let width = CGFloat(30)
        let btn = LoadingButton.init(frame: CGRectMake(0, 0, width, width))
        btn.block = {
            auto in
           self.presenter?.getStrategyRank(self.leftText, period: self.rightText)
        }
        btn.setImage(UIImage.init(named: "iconfont-shuaxin")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return btn
    }()
    
    private lazy var tableHeaderView : ProfitTableHeaderView = {
        let _view = ProfitTableHeaderView.init(frame: CGRectMake(0, 0, AppWidth, 44))
        _view.delegate = self
        return _view
    }()
    
}
//MARK:  UITableViewDelegate,UITableViewDataSource
extension IncomeTopView: UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (presenter?.numberOfRow(section))!
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier(Cell.CellID) as! ProfitCell
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        presenter?.setContentToView(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        presenter?.didSelectProfitItem(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
			return CGFloat.min
    }
}
//MARK: ProfitHeaderViewDelegate 
extension IncomeTopView: ProfitHeaderViewDelegate {
    func initSuperView(left: ZHDropDownMenu, right: ZHDropDownMenu) {
        left.superVV = self.view
        right.superVV = self.view
    }
    
    func transmitMenuItem(leftText: String, RightText: String) {
        self.leftText = leftText
        self.rightText = RightText
        presenter?.getStrategyRank(leftText, period: RightText)
    }
    
}
//MARK: ProfitTableHeaderViewDelegate
extension IncomeTopView:ProfitTableHeaderViewDelegate {
    func skipSearchStockView() {
        let view = HotSearchView()
        self.navigationController?.pushViewController(view, animated: true)
    }
}
