//
//  BSPointView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import MJRefresh
class BSPointView: BaseVC,BSPointStockViewProtocol{
    var presenter: BSPointStockPresenterProtocol?
    let rowHeight: CGFloat = 50
    let buttonTextHeight:CGFloat = 35
    // 顶部刷新
    let header = MJRefreshNormalHeader()
    var block : RefreshType?
    var btn : LoadingButton?
    
    typealias RefreshType = (String)->()
    struct Nib {
        static let CellName = "BSPointCell"
    }
    
    struct Cell {
        static let CellID = "BSPointCellID"
    }
    //MARK: View Life
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        presenter?.glamourstock("bspoint")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.greenColor()
        self.pageName = "BS点"
        view.addSubview(tableView)
        pushRefresh()
        commonInit()
    }
    
    // MARK: - HotStockViewProtocol
    func notifyFetchSuccess() {
        print(#function)
        self.tableView.reloadData()
        self.noticeTop("BS点更新成功 "+helper.getCurrentTime())
        self.btn?.lodingNot()
        self.tableView.mj_header.endRefreshing()
    }
    
    func notifyFetchFailure() {
        //弹出框提示
        self.noticeOnlyText2("网络不给力啊")
        self.tableView.mj_header.endRefreshing()
        print(#function)
        self.btn?.lodingNot()
        // self.tableView.reloadData()
    }
    
    //MARK: 调转到详情页面
    func skipToDetailView(roughStocks: [RoughStock],index: Int) {
        let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
        vc.roughStocks = roughStocks
        vc.currentRoughStockPos = index
		vc.showSecondPage = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: Private Method
    private func commonInit() {
        presenter = BSPointStockPresenter()
        presenter?.view = self
    }
    
    func updateDataSource(button: LoadingButton) {
        self.btn = button
        presenter?.glamourstock("bspoint")
    }
    
    func pushRefresh(){
        header.setRefreshingTarget(self, refreshingAction: #selector(headerRefresh))
        // 现在的版本要用mj_header
        self.tableView.mj_header = header
        helper.setHeaderRefresh(header)
    }
    
    func headerRefresh() {
        block!("bspoint")
    }
    
    //MARK : setter and getter
    private lazy var tableView : UITableView = {
        let _tableView = UITableView.init(frame: CGRectMake(0, 0, AppWidth, AppHeight-NavigationH-TabH-self.buttonTextHeight), style: .Plain)
        _tableView.rowHeight = self.rowHeight
        _tableView.tableFooterView = UIView()
        _tableView.registerNib(UINib(nibName: Nib.CellName, bundle: nil), forCellReuseIdentifier: Cell.CellID)
        _tableView.dataSource = self
        _tableView.delegate = self
        return _tableView
    }()
    
    private lazy var Empty: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.frame = self.tableView.frame
        label.text = "云端策略服务器正在计算中......"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
}
extension BSPointView : UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numbers = presenter!.numberOfItems(inSection: section)
        if numbers > 0 {
            self.tableView.backgroundView = nil
        } else {
            self.tableView.backgroundView = Empty
        }
        
        return numbers
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.CellID)! as! BSPointCell
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0)
        presenter?.setContentToView(cell, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        presenter?.skipToDetailView(indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PickHeaderView.init(frame: CGRectMake(0, 0, tableView.frame.size.width, HeaderH))
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HeaderH
    }
    
}

//MARK: PickStockCellDelegate
extension BSPointView : BSPointCellDelegate {
    func pickViewAddStock(name name: String, code: String) {
        presenter?.addStock(withName: name, code: code)
    }
}
