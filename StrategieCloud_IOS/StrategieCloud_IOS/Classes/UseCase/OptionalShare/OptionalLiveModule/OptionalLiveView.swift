//
//  OPtionalLiveView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import MJRefresh
class OptionalLiveView: BaseVC {
    private var presenter : OptionalLivePresenterProtocol!
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    var row: Int = 0
    //MARK: View Life cycle
    override func viewDidLoad() {
        presenter = OptionalLivePresenter(view: self)
        super.viewDidLoad()
        self.pageName = "股票直播"
        self.title = self.pageName
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(tableView)
        pushRefresh()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getInventorymessage()
    }
    
    func pushRefresh(){
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        helper.setHeaderRefresh(header)
    }
    
    func headerRefresh(){
        presenter.getInventorymessage()
    }
    
    func judgeToEmpty() {
        if row > 0 {
            headerView.hidden = false
            self.tableView.backgroundView = nil
        } else {
            headerView.hidden = true
            self.tableView.backgroundView = Empty
        }
    }
    //MARK: Private Control
    private lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRectMake(0, 0, AppWidth, AppHeight-64), style: UITableViewStyle.Plain)
        _tableView.backgroundColor = UIColor.whiteColor()
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.separatorStyle = .None
        _tableView.registerNib(UINib.init(nibName: "OptionLiveCell", bundle: nil), forCellReuseIdentifier: "OptionLiveCellID")
        _tableView.rowHeight = UITableViewAutomaticDimension
        _tableView.estimatedRowHeight = 300
		_tableView.allowsSelection = false
        return _tableView
    }()
    
    private lazy var headerView:OptionalLiveHeaderView = {
        let _view = OptionalLiveHeaderView.init(frame: CGRectMake(0, 0, AppWidth, 40))
        return _view
    }()
    
    private lazy var Empty: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.frame = self.tableView.frame
        label.text = "暂无直播信息"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension OptionalLiveView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        row = presenter.numberOfRow()
        return row
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionLiveCellID") as! OptionLiveCell
        presenter.setContentView(cell, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter.setContentToHeaderView(headerView)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}
//MARK: TextViewCellDelegate
extension OptionalLiveView: TextViewCellDelegate{
    func textClicked(title:String,code: String,type:Int) {
        //let view = PresentViewController()
        var roughStocks: [RoughStock] = []
        roughStocks.append(RoughStock(name: title, code: code))
        let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
        if type == 802 {
            vc.showSecondPage = true
        }else if type == 801{
            vc.showSecondPage = false
        }
        vc.roughStocks = roughStocks
        self.navigationController!.pushViewController(vc, animated: true)
    }
}
//MARK: - OptionalLiveViewProtocol
extension OptionalLiveView: OptionalLiveViewProtocol{
    func notifyFetchSuccess() {
        self.tableView.mj_header.endRefreshing()
        tableView.reloadData()
        judgeToEmpty()
    }
    
    func notifyFetchFailure() {
        self.noticeOnlyText2("网络不给力啊")
        self.tableView.mj_header.endRefreshing()
        judgeToEmpty()
    }
}
