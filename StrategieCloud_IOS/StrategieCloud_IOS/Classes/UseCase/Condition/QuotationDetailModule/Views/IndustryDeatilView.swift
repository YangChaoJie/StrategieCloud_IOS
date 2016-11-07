//
//  IndustryDeatilView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import MJRefresh
class IndustryDeatilView: UIViewController ,QuotationDetailViewProtocol{
    var presenter : QuotationDetailPresenterProtocol?
    var option : String = ""
    let header = MJRefreshNormalHeader()
    var timer : NSTimer? = nil
    private let cellHeight = CGFloat(30)
    private let rowHeight = CGFloat(50)
    var checkNetWorkAvailable: Bool = true
    struct Nib {
        static let CellName = "IndustryDetailCell"
    }
    
    struct Cell {
        static let CellID = "IndustryDeatilCellID"
    }
    
    //MARK:  view Life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
//        presenter?.getMoreMarkInfo(option)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        timer?.fireDate = NSDate.distantFuture()
        ConditionTag.riseTag = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.brownColor()
        initNavTitleView()
        commonInit()
        view.addSubview(self.tableView)
        pushRefresh()
        initTimer()
    }
    //MARK: METHOD
    private func commonInit() {
        presenter = QuotationDetailPresenter()
        presenter?.view = self
    }
    
    func pushRefresh(){
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        helper.setHeaderRefresh(header)
    }
    
    func headerRefresh() {
        self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
    }
    
    func initTimer() {
        //定时器
        self.timer = NSTimer.scheduledTimerWithTimeInterval(10,
                                                            target:self,selector:#selector(updateData),
                                                            userInfo:nil,repeats:true)
    }
    
    func updateData() {
      if checkNetWorkAvailable == true {
         self.refreshBtn.loadingMore(self.refreshBtn,auto: true)
        }
    }

   
    private func initNavTitleView()  {
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView: self.searchBtn)
        let rightItem1 : UIBarButtonItem = UIBarButtonItem.init(customView: self.refreshBtn)
        self.navigationItem.rightBarButtonItems = [rightItem1, rightItem]
    }
    
    func search()  {
        let search = SearchStockView()
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    // MARK: - QuotationDetailProtocol
    func notifyFetchSuccess() {
        print(#function)
        checkNetWorkAvailable = true
        hudView.noticeTop(self.title!+"更新成功 "+helper.getCurrentTime())
        self.tableView.reloadData()
        self.tableView.mj_header.endRefreshing()
        self.refreshBtn.lodingNot()
    }
    
    func notifyFetchFailure() {
        checkNetWorkAvailable = false
        hudView.noticeOnlyText2("网络不给力啊")
        self.tableView.mj_header.endRefreshing()
        self.refreshBtn.lodingNot()
        print(#function)
    }
    
    func notifyTimeSucess() {
        self.tableView.reloadData()
        self.refreshBtn.lodingNot()
    }
    
    func notifyServerFailure() {
        self.tableView.mj_header.endRefreshing()
        checkNetWorkAvailable = false
        self.refreshBtn.lodingNot()
    }
    
    func skipToDetailView(roughStocks: [RoughStock],index: Int){
        //为空
    }
    //MARK: setter and getter
    private lazy var tableView : UITableView = {
        let _tableView = UITableView()
        _tableView.frame = CGRectMake(0, 0, AppWidth, AppHeight-NavigationH)
        _tableView.tableFooterView = UIView()
        _tableView.registerNib(UINib(nibName: Nib.CellName, bundle: nil), forCellReuseIdentifier: Cell.CellID)
        _tableView.dataSource = self
        _tableView.delegate = self
        return _tableView
    }()
    
    private lazy var searchBtn : UIButton = {
        let btn = UIButton()
        let width = CGFloat(30)
        btn.frame = CGRectMake(0, 0, width, width)
        btn.setImage(UIImage.init(named: "iconfont-211"), forState: .Normal)
        btn.addTarget(self, action: #selector(search), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    private lazy var refreshBtn : LoadingButton = {
        let width = CGFloat(30)
        let btn = LoadingButton.init(frame: CGRectMake(0, 0, width, width))
        btn.block = { auto in
            self.presenter?.getMoreMarkInfo(self.option,auto:auto)
        }
        btn.setImage(UIImage.init(named: "iconfont-shuaxin"), forState: .Normal)
        return btn
    }()
    
}
//MARK:  UITableViewDelegate, UITableViewDataSource
extension IndustryDeatilView: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (presenter?.numberOfItems(inSection: section))!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.CellID) as! IndustryDetailCell
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.delegate = self
        presenter?.setContentToIndustry(cell, indexPath: indexPath,headName: self.option)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headView = IndustryDeatilHeadView.init(frame: CGRectMake(0, 0, AppWidth, 30));
        headView.delegate = self
        return headView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderH
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }
}
//MARK: IndustryDeatilSortDelegate
extension IndustryDeatilView: IndustryDeatilSortDelegate {
    func sortByChange(state: Bool){
        self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
    }
}
extension IndustryDeatilView: IndustryCellDelegate {
    func skipToDetailView(option: String,name : String){
        let view = QuotationDetailView()
        view.option = option
        view.title = name
        self.navigationController?.pushViewController(view, animated: true)
    }
}
