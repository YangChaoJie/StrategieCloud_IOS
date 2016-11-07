//
//  OptionalBsView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class OptionalBsView: BaseVC,OptionBsViewProtocol {
    var presenter : OptionBsPresenterProtocol?
    var row: Int = 0
    var sec: Int = 0
    //MARK: View Life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        view.addSubview(lineView)
        view.addSubview(tableView)
        
        self.tableView.backgroundColor = UIColor.clearColor()
        //tableView.insertSubview(lineView, atIndex: 0)
        self.title = "自选BS点"
        initCommmit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        presenter?.getChangeDataSourceToServer()
        
    }
    
    func initCommmit() {
        presenter = OptionBsPresenter()
        presenter!.view = self
    }
    
    func judgeToEmpty() {
        if sec > 0 {
            //lineView.hidden = false
            self.tableView.backgroundView = nil
        } else {
            self.tableView.backgroundView = Empty
            lineView.hidden = true
        }
    }
    
    func judgeToLineView() {
        if sec > 0 {
            lineView.hidden = false
        } else {
            lineView.hidden = true
        }
    }
    
    
    // MARK: - IncomeStockViewProtocol
    func notifyFetchSuccess() {
        print(#function)
        self.tableView.reloadData()
        judgeToEmpty()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func notifyFetchFailure() {
        hudView.noticeOnlyText2("网络不给力啊")
        judgeToEmpty()
        print(#function)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    //MARK: 调转到详情页面
    func skipToDetailView(roughStocks: [RoughStock],index: Int) {
        let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
        vc.currentRoughStockPos = index
        vc.showSecondPage = true
        vc.roughStocks = roughStocks
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //MARK: setter and getter
    private lazy var tableView : UITableView = {
        let _tableView = UITableView(frame: CGRectMake(0, 10, AppWidth, AppHeight - NavigationH-10), style: .Plain)
        _tableView.backgroundColor = UIColor.whiteColor()
        _tableView.separatorStyle = .None
        _tableView.registerClass(OptionBsCell.self, forCellReuseIdentifier: "OptionBsCell")
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 80
        return _tableView
    }()
    
    private lazy var Empty: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.frame = self.tableView.frame
        label.text = "自选股本周暂无BS信息:)"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.frame = CGRectMake(64, 10, 1, AppHeight)
        _lineView.hidden = true
        print("lineview 的坐标 ==\(_lineView.frame)")
        _lineView.backgroundColor = UIColor.colorWith(70, green: 136, blue: 241, alpha: 1)
        return _lineView
    }()
    
}

//MARK: UITableViewDelegate,UITableViewDataSource
extension OptionalBsView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionBsCell") as! OptionBsCell
        presenter?.setDataToCell(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        sec = (presenter?.numberOfRow(section))!
        judgeToLineView()
        return sec
        //sec
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        row =  (presenter?.numberOfSection())!
        return row
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        presenter?.didSelectItem(indexPath)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = OptionBsHeaderView.init(frame: CGRectMake(0, 0, self.view.width, 20))
         presenter?.setDataToHeaderView(view, section: section)
        return view
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sec > 0 || row > 0{
            return 20
        }
        return 0
    }
    
}

