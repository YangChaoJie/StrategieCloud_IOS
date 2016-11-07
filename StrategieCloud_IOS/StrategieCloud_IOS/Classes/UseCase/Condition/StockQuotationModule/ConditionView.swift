//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh

class ConditionView: BaseVC,StockQuotationViewProtocol
{
 
    var presenter: StockQuotationPresenterProtocol?
    var isOpenArray:NSMutableArray?
    private var conditionTableView: UITableView!
    var headerView : ConditionHeaderView!
    let header = MJRefreshNormalHeader()
    var timer : NSTimer? = nil
    var checkNetWorkAvailable: Bool = true
    //MARK: view Life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
        initTimer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        timer?.fireDate = NSDate.distantFuture()
    }
    
    override func loadView(){
        setTableView()
        isOpenArray = NSMutableArray()
        for _ in 0...9 {
            let isOpen = true;
            isOpenArray?.addObject(NSNumber(bool: isOpen))
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavTitileView()
        commonInit()
        conditionTableView.tableFooterView = UIView.init()
        pushRefresh()
        self.pageName = "行情"
    }
    //MARK: METHOD
    func pushRefresh(){
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        conditionTableView.mj_header = header
        helper.setHeaderRefresh(header)
    }
    
    func headerRefresh() {
        hudView.clearAllNotice()
        self.refreshBtn.loadingMore(self.refreshBtn,auto: false)
    }
    
    func initTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(10,
                                                            target:self,selector:#selector(updateData),
                                                            userInfo:nil,repeats:true)
    }
    
    func updateData() {
        if checkNetWorkAvailable == true {
           self.refreshBtn.loadingMore(self.refreshBtn,auto: true)
        }
    }
    
    private func commonInit() {
        presenter = StockQuotationPresenter()
        presenter?.view = self
    }
    
    // MARK: - HotStockViewProtocol
    func notifyFetchSuccess() {
        print(#function)
        checkNetWorkAvailable = true
        self.refreshBtn.lodingNot()
        self.conditionTableView.reloadData()
        self.noticeTop("行情更新成功 "+helper.getCurrentTime())
        // 结束刷新
        self.conditionTableView.mj_header.endRefreshing()
    }
    
    func notifyFetchFailure() {
        self.noticeOnlyText2("网络不给力啊")
        checkNetWorkAvailable = false
        self.conditionTableView.mj_header.endRefreshing()
         self.refreshBtn.lodingNot()
        //self.clearAllNotice()
        print(#function)
    }
    
    func notifyTimeSucess() {
        self.conditionTableView.reloadData()
        self.conditionTableView.mj_header.endRefreshing()
        self.refreshBtn.lodingNot()
    }
    
    //MARK: 调转到详情页面
    func skipToDetailView(roughStocks: [RoughStock],index: Int) {
		let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
		vc.currentRoughStockPos = index
		vc.roughStocks = roughStocks
        
        guard   roughStocks.count > 0 else {
             return
        }
        
		if (roughStocks[0].code == "sh000001" ||
			roughStocks[0].code == "sz399006" ||
			roughStocks[0].code == "sz399001" ||
			roughStocks[0].code == "sh000300") {
			vc.marketIndex = true
		 }
        
		self.navigationController?.pushViewController(vc, animated: true)
    }
	
    private func setTableView() {
        conditionTableView = UITableView.init(frame: CGRectMake(0, 0, AppWidth, AppHeight))
        conditionTableView.delegate = self
        conditionTableView.dataSource = self
        let cellNib = UINib(nibName: "StockQuotationCell", bundle: nil)
        conditionTableView.registerNib(cellNib, forCellReuseIdentifier: "StockQuotationCellID")
        view = conditionTableView
        
    }
    
    func initNavTitileView()  {
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView:  refreshBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    private lazy var refreshBtn : LoadingButton = {
        let width = CGFloat(30)
        let btn = LoadingButton.init(frame: CGRectMake(0, 0, width, width))
        btn.block = {
            auto in
          self.presenter?.getMarketInfo(auto)
          self.presenter?.getHeaderStocks(auto)
        }
        btn.setImage(UIImage.init(named: "iconfont-shuaxin")?.imageWithRenderingMode(.AlwaysOriginal), forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        return btn
    }()
}

//MARK:- UITableViewDelegate和UITableViewDataSource
extension ConditionView : UITableViewDelegate,UITableViewDataSource, ConditionHeaderViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if presenter != nil {
          return   (presenter?.getDataList().count)! ?? 0
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let isOpen = isOpenArray![section] as! Bool;
        if isOpen == true{
            if (section >= 0 && section <= 2) {
                return 1
            }
            return presenter?.numberOfItems(inSection: section) ?? 0;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            var conditionCell : ConditionPartsCell?
            conditionCell = ConditionPartsCell.conditionCellWithTableView(tableView)
            conditionCell?.separatorInset = UIEdgeInsetsZero
            conditionCell?.delegate = self
            for i in 0..<4 {
               presenter?.setDataOfHeader(conditionCell!.btns![i], index: i)
            }
            return conditionCell!
        }
        
        if indexPath.section > 0 && indexPath.section <= 2 {
            var conditionCell : ConditionIndustryCell?
            conditionCell = ConditionIndustryCell.conditionCellWithTableView(tableView)
            conditionCell?.delegete = self
            conditionCell?.separatorInset = UIEdgeInsetsZero
            for i in 0..<6 {
                presenter?.setDataOfIndustry((conditionCell?.btns![i])!, index: i,section: indexPath.section)
            }
            return conditionCell!
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("StockQuotationCellID") as! StockQuotationCell
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        presenter?.setContentToView(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
        let headView = ConditionTableHeadView.init(frame: CGRectMake(0, 0, AppWidth, 30))
            headView.CreateView(CGRectMake(0, 0, AppWidth, 30), name: (self.presenter?.getDataList()[section][0])!,option: (self.presenter?.getDataList()[section][1])!)
        
        let g  = self.isOpenArray![section] as! Bool
            headView.delegete = self
            headView.isExpend = g
            headView.isOpen = self.isOpenArray
            headView.setBtnClick(g)
            headView.tag = section
         return headView
            
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return HeaderH
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        if indexPath.section >= 2 {
            presenter?.didSelectStockQuotationItem(indexPath)
        }
    }
    
    func ConditionHeaderViewDidClickBtn(headerView : ConditionTableHeadView, isOpen: Bool) {
        isOpenArray![headerView.tag] = NSNumber(bool: isOpen)
        let indexSet : NSIndexSet = NSIndexSet.init(index: headerView.tag)
        self.conditionTableView.reloadSections(indexSet, withRowAnimation: .None)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section > 0 && indexPath.section <= 2 {
            return 190
        }
        if indexPath.section == 0 {
           return 150
        }
        return 50
    }
    
    
    func skipToDetailView(title: String,option: String) {
        if option == "industry" || option == "concept" {
            let view = IndustryDeatilView()
            view.option = option
            view.title = title
            print("穿的值是 ==\(option)")
            self.navigationController?.pushViewController(view, animated: true)
        }else {
            let view = QuotationDetailView()
            view.title = title
            view.option = option
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
//MARK: ConditionIndustryCellDelegate
extension ConditionView : ConditionIndustryCellDelegate {
    func skipToDetailView(option: String,name:String) {
        let view = QuotationDetailView()
        view.option = option
        view.title = name
        
        self.navigationController?.pushViewController(view, animated: true)
    }
}
//MARK: 
extension ConditionView: ConditionPartsCellDelegate {
    func skipToDetailView(index: Int) {
        presenter?.didSelectStockQuotationHeader(index)
    }
}
