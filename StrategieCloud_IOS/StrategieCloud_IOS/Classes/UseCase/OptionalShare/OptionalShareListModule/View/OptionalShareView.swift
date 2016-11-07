//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation
import UIKit
import MJRefresh
class OptionalShareView: BaseVC, OptionalShareViewProtocol
{
    var presenter: OptionalSharePresenterProtocol?
    var checkNetWorkAvailable: Bool = true
    // 顶部刷新
    let headerRefresh = MJRefreshNormalHeader()
	var headerView: OptionHeaderView!
	let gcdTimer: GCDTimer = GCDTimer(intervalInsecs: 10)
	
	let BottomLoginBGHeight = CGFloat(24)
	
	//MARK: View Life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
		presenter?.fetchStockDataFromRealm()
        getUserLoginState()
        presenter?.setDataToHeaderView(self.tableheaderView)
        
        addNotification()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
		stopTimer()
		presenter?.updateLocalRealm()
        removeNotification()
    }
    
	override func viewDidLoad() {
		super.viewDidLoad()
        self.pageName = "自选"
		self.title = "自选"
		initView()
        self.view.addSubview(tableView)
        self.view.addSubview(loginBtn)
        
       
	}
    
    //MARK: Method
    private func initView()  {
        let leftItem : UIBarButtonItem = UIBarButtonItem.init(customView: self.editBtn)
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView: self.searchBtn)
        let rightItem1 : UIBarButtonItem = UIBarButtonItem.init(customView: self.refreshBtn)
        self.navigationItem.rightBarButtonItems = [rightItem1, rightItem]
        self.navigationItem.leftBarButtonItem = leftItem
		
		headerRefresh.setRefreshingTarget(self, refreshingAction: #selector(OptionalShareView.headerRefresingAction))
		self.tableView.mj_header = headerRefresh
        helper.setHeaderRefresh(headerRefresh)
		gcdTimer.Event = {
			print("===自选股定时刷新===")
			self.presenter?.regularlyUpdateStockDataFromServer()
		}
		
		headerView = OptionHeaderView(frame: CGRectMake(0, 0, AppWidth, 30))
		headerView.delegate = self
    }
    
    private lazy var tableView : UITableView = {
        let _tableView = UITableView()
        _tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - NavigationH-TabH-self.BottomLoginBGHeight)
        _tableView.tableFooterView = UIView()
        _tableView.dataSource = self
        _tableView.delegate = self
		_tableView.rowHeight = 50
        _tableView.tableHeaderView = self.tableheaderView
		_tableView.tableFooterView = UIView()
		_tableView.registerNib(UINib(nibName: "OptionalShareCell", bundle: nil), forCellReuseIdentifier: "OptionalShareCellID")
        return _tableView
    }()
    
    private lazy var tableheaderView: OptionShareHeaderView = {
        let _view = OptionShareHeaderView.init(frame: CGRectMake(0, 0, AppWidth, 60))
        _view.delegate = self
        return _view
    }()
	
	@objc private func headerRefresingAction() {
		refreshBtn.startRefresh()
		presenter?.fetchStockDataFromRealm()
	}
    
    private func addNotification() {
        //监听是否触发home键挂起程序.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.applicationWillResignActive), name: UIApplicationWillResignActiveNotification, object: nil)
        
        ///监听是否重新进入程序程序.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    private func removeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    
    private func startTimer() {
		if !gcdTimer.isRunning {
			gcdTimer.start()
		}
    }
	
	private func stopTimer() {
		if gcdTimer.isRunning {
			gcdTimer.pause()
		}
	}
    
    @objc private func applicationWillResignActive(){
        stopTimer()
        print("监听是否触发home键挂起程序.")
    }
    
    @objc private func applicationDidBecomeActive() {
        startTimer()
    }
	
    func getUserLoginState() {
		if UserMannager.instance.getLoginStatues() {
			loginBtn.setTitle("已登录 兵法云账号：" + UserMannager.instance.getUserName(), forState: UIControlState.Disabled)
			loginBtn.enabled = false
		} else {
			loginBtn.setTitle("请登录兵法云账号", forState: UIControlState.Normal)
			loginBtn.enabled = true
		}
    }
	
    @objc private func search()  {
        let search = SearchStockView()
        self.navigationController?.pushViewController(search, animated: true)
    }
    
    @objc private func edit() {
		//headerView.restoreToNormalState()
		presenter?.setOptionOrderType(OrderType.Normal)
        let edit = EditOptionView()
        self.navigationController?.pushViewController(edit, animated: true)
    }
	
	@objc private func loginBtnClick() {
		MineWireFrame.enterLoginModule(self.navigationController!)
	}
    
    private lazy var emptyView : OptionShareEmptyView = {
        let view = OptionShareEmptyView.init(frame: CGRectMake(0, HeaderH, AppWidth, AppHeight-NavigationH-44))
        view.delegate = self
        return view
    }()

	private lazy var loginBtn: UIButton = {
		let btn = UIButton()
		btn.frame = CGRectMake(0, AppHeight-self.BottomLoginBGHeight-TabH-NavigationH, AppWidth, self.BottomLoginBGHeight)
		btn.setTitleColor(UIColor.colorWith(164, green: 174, blue: 184, alpha: 1.0), forState: UIControlState.Normal)
		btn.backgroundColor = UIColor.whiteColor()
		btn.titleLabel?.font = UIFont.systemFontOfSize(12)
		btn.addTarget(self, action: #selector(OptionalShareView.loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
		return btn
	}()
    
    private lazy var searchBtn : UIButton = {
        let btn = UIButton()
        let width = CGFloat(30)
        btn.frame = CGRectMake(0, 0, width, width)
        btn.setImage(UIImage.init(named: "iconfont-211"), forState: .Normal)
        btn.addTarget(self, action: #selector(search), forControlEvents: .TouchUpInside)
        return btn
    }()

	private lazy var refreshBtn: IndicatorRefreshButton = {
		let button = IndicatorRefreshButton(frame: CGRectMake(0, 0, 30, 30))
		button.delegate = self
		return button
	}()
	
    private lazy var editBtn : UIButton = {
        let btn = UIButton()
        let width = CGFloat(30)
        btn.frame = CGRectMake(0, 0, width, width)
        btn.setImage(UIImage.init(named: "iconfont-xitongwenzibianji"), forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(edit), forControlEvents: .TouchUpInside)
        return btn
    }()


	//MARK: OptionalShareViewProtocol
	func orderRefresh() {
		tableView.reloadData()
	}
	
	func startRefresh() {
		GCDTimer.delay(0, queue: dispatch_get_main_queue()) { 
			self.refreshBtn.startRefresh()
		}
	}
	
	func fetchServerStockFailure() {
		self.noticeOnlyText2("网络不给力")
		gcdTimer.pause()
		self.tableView.mj_header.endRefreshing()
		refreshBtn.stopRefresh()
	}
	
	func fetchLocalStockSuccess() {
		tableView.reloadData()
        presenter?.setDataToHeaderView(self.tableheaderView)
	}
	
	func fetchServerStockSuccess(regularlyRefresh regular: Bool) {
		tableView.reloadData()
		GCDTimer.delay(0.2) {
			self.refreshBtn.stopRefresh()
			self.tableView.mj_header.endRefreshing()
			if !regular {
				self.noticeTop("自选更新成功 "+helper.getCurrentTime())
			}
		}
		
//		if presenter?.numberOfItems(shareView: 0) == 0 {
//			stopTimer()
//		} else {
			startTimer()
	//	}
        self.presenter?.setDataToHeaderView(self.tableheaderView)
	}
}

// MARK: -IndicatorRefreshBtnDelegate
extension OptionalShareView: IndicatorRefreshBtnDelegate {
	func indicatorBtnClickRefresh(btn: IndicatorRefreshButton) {
		presenter?.fetchStockDataFromRealm()
	}
}

extension OptionalShareView: OptionHeaderViewDelegate {
	func optionHeaderViewOrderType(type: OrderType) {
		presenter?.setOptionOrderType(type)
	}
}

// MARK: - UITableViewDelegate
extension OptionalShareView: UITableViewDelegate,UITableViewDataSource {
	 func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numbers = presenter!.numberOfItems(shareView: section)
		if numbers > 0 {
			self.tableView.backgroundView = nil
			
		} else {
			let emptyView = OptionShareEmptyView(frame: tableView.frame)
			emptyView.delegate = self
			self.tableView.backgroundView = emptyView
		}
		return numbers
	}

	 func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("OptionalShareCellID")! as! OptionalShareCell
		presenter?.setContentToView(shareView: cell, indexPath: indexPath)
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.delagete = self
		return cell
	}
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		presenter?.didSelectOptionalShareItem(atIndexPath: indexPath, controller: self.navigationController!)
	}
}

// MARK:SearchStockDelegate
extension OptionalShareView : SearchStockDelegate {
    func SearchStock(){
        let search = SearchStockView()
        search.viewTag = 1
        self.navigationController?.pushViewController(search, animated: true)
    }
}

//MARK: OptionShareHeaderViewDelegate
extension OptionalShareView: OptionShareHeaderViewDelegate {
    func goToChangeView() {
        let view = OptionalLiveView()
        presenter?.setHeaderState("message")
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func skipToDetailView(index:Int) {
        presenter?.didTapOptionalHeaderView(index, controller: self.navigationController!)
    }
    
    func goToBsView() {
        presenter?.setHeaderState("Bs")
        let view = OptionalBsView()
        self.navigationController?.pushViewController(view, animated: true)
    }
}

//MARK: OptionShareCellDelegate
extension OptionalShareView: OptionShareCellDelegate {
    func skipToStartegyView(stockCode: String,name:String) {
		let strategyListVC = StrategyListViewController()
		strategyListVC.stockCode = stockCode
		strategyListVC.title = "“" + name + "”" + "适用策略"
		let nav = MainNavigationController(rootViewController: strategyListVC)
		self.navigationController?.presentViewController(nav, animated: true, completion: nil)
    }
}
