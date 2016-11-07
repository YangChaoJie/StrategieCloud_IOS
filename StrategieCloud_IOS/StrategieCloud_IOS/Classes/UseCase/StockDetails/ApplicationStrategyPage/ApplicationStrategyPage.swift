//
//  ApplicationStrategyPage.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/24.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
class ApplicationStrategyPage: BaseVC ,ApplicationStrategyPageProtocol{
    var presenter :ApplicationStrategyPresenterProtocol?
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    let rowHeight: CGFloat = 60
    var number : Int = 2
    var isOpenArray:NSMutableArray?
    var sec: Int = 0
    
    struct Nib {
        static let CellName = "StrategyPageCell"
        static let StrategyIncomeCellName = "StrategyIncomeCell"
        static let StrategyChartCellName = "StrategyChartCell"
    }
    
    struct Cell {
        static let CellID = "StrategyPageCellID"
        static let StrategyIncomeCellID = "StrategyIncomeCellID"
        static let StrategyChartCellID = "StrategyChartCellID"
    }
    
    var stockCode: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initCommit()
        pushRefresh()
        initOpenArray()
        view.addSubview(tableView)
        initNavView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        getDataToServer()
    }
    // MARK: - ViewProtocol
    func notifyFetchSuccess() {
        print(#function)
        self.noticeTop("策略更新成功 "+helper.getCurrentTime())
        self.tableView.mj_header.endRefreshing()
        self.tableView.reloadData()
    }
    
    func notifyFetchFailure() {
        //弹出框提示
        self.noticeOnlyText2("网络不给力啊")
        self.tableView.mj_header.endRefreshing()
        print(#function)
        // self.tableView.reloadData()
    }
    
    func getDataToServer() {
         presenter?.getStrategyWinInfo(stockCode)
    }
    //MARK: METHOD
    func initOpenArray() {
        isOpenArray = NSMutableArray()
        for _ in 0...9 {
            let isOpen = false
            isOpenArray?.addObject(NSNumber(bool: isOpen))
        }
    }
    
    func initCommit() {
        presenter = ApplicationStrategyPresenter()
        presenter?.view = self
    }
    
    func pushRefresh(){
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        helper.setHeaderRefresh(header)
    }
    
    func headerRefresh() {
        presenter?.getStrategyWinInfo(stockCode)
    }
    
    private func initNavView() {
        self.navigationItem.hidesBackButton = true
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView: self.backBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK : setter and getter
    private lazy var tableView : UITableView = {
        let _tableView = UITableView.init(frame: CGRectMake(0, 0, AppWidth, AppHeight-NavigationH), style: .Plain)
        _tableView.rowHeight = self.rowHeight
        _tableView.separatorStyle = .None
        _tableView.tableFooterView = UIView()
        _tableView.registerNib(UINib(nibName: Nib.CellName, bundle: nil), forCellReuseIdentifier: Cell.CellID)
        _tableView.registerNib(UINib(nibName: Nib.StrategyChartCellName, bundle: nil), forCellReuseIdentifier: Cell.StrategyChartCellID)
        _tableView.registerNib(UINib(nibName: Nib.StrategyIncomeCellName, bundle: nil), forCellReuseIdentifier: Cell.StrategyIncomeCellID)
        _tableView.dataSource = self
        _tableView.delegate = self
        return _tableView
    }()

    private lazy var tableheaderView: StrategyPageHeaderView = {
        let _view = StrategyPageHeaderView.init(frame: CGRectMake(0, 0, AppWidth, 60))
        //_view.delegate = self
        return _view
    }()
    
    private lazy var backBtn : UIButton = {
        let btn = UIButton()
        let width = CGFloat(30)
        btn.frame = CGRectMake(0, 0, width, width)
        btn.setTitle("关闭", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.addTarget(self, action: #selector(back), forControlEvents: .TouchUpInside)
        return btn
    }()
    
}
//MARK: UITableViewDelegate,UITableViewDataSource
extension ApplicationStrategyPage : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        sec = (presenter?.numberOfSection())!
        return sec
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isOpen = isOpenArray![section] as! Bool
        if isOpen == true{
            return number
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell.StrategyIncomeCellID) as! StrategyIncomeCell
            presenter?.setEachProfitContentToView(cell,indexPath: indexPath)
            return cell
        }else if  indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(Cell.StrategyChartCellID,forIndexPath: indexPath) as! StrategyChartCell
            presenter?.setBacktestChartContentToView(cell,index: indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let _view = StrategyPageHeaderView.init(frame: CGRectMake(0, 0, AppWidth, 60))
        presenter?.setDataToHeaderView(_view, section: section)
        let g  = self.isOpenArray![section] as! Bool
         _view.isExpend = g
         _view.tag =  section
         _view.setBtnClick(g)
         _view.delegate = self
        _view.isOpen = self.isOpenArray
        return _view
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == sec - 1 {
            return CGFloat.min
        }
        return 10
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 77
        }else {
            return 200
        }
    }
    
    
}
//取消悬停
extension ApplicationStrategyPage: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let sectionHeaderHeight: CGFloat = 60
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0)
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
           //self.tableView.reloadData()
        }
    }
}
//MARK:StrategyPageHeaderViewdelegate
extension ApplicationStrategyPage: StrategyPageHeaderViewDelegate {
    func strategyPageHeaderViewDidClickBtn(headerView: StrategyPageHeaderView, isOpen: Bool,aowId:Int) {
        isOpenArray![headerView.tag] = NSNumber(bool: isOpen)
        presenter?.getStrategyChartInfo(aowId)
        self.tableView.reloadData()
    }
    
    func changeDataSource(aowId:Int,code:String) {
        presenter?.settingUse(aowId, code: self.stockCode)
    }
}
