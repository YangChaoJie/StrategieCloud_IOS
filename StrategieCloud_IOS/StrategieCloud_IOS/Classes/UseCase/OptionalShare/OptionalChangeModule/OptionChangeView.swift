//
//  OptionChangeView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class OptionChangeView: BaseVC ,OptionChangeViewProtocol{
    var presenter : OptionChangePresenterProtocol?
    let defalutColor = UIColor.colorWith(70, green: 136, blue: 241, alpha: 1)
    var row: Int = 0
    var sec: Int = 0
     override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "自选异动"
        view.addSubview(lineView)
        view.addSubview(tableView)
      
        self.tableView.backgroundColor = UIColor.clearColor()
        initCommmit()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        presenter?.getChangeDataSourceToServer()
        
    }
    
    func initCommmit() {
        presenter = OptionChangePresenter()
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
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        hudView.noticeOnlyText2("网络不给力啊")
        judgeToEmpty()
        print(#function)
    }
    
    //MARK: 调转到详情页面
    func skipToDetailView(roughStocks: [RoughStock],index: Int) {
        let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
        vc.currentRoughStockPos = index
        vc.roughStocks = roughStocks
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: setter and getter
    private lazy var tableView : UITableView = {
       let _tableView = UITableView(frame: CGRectMake(0, 10, AppWidth, AppHeight - NavigationH), style: .Plain)
        _tableView.backgroundColor = UIColor.whiteColor()
        _tableView.separatorStyle = .None
        _tableView.registerClass(OptionChangeCell.self, forCellReuseIdentifier: "OptionChangeCell")
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.rowHeight = 80
        return _tableView
    }()
    
    private lazy var Empty: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGrayColor()
        label.frame = self.tableView.frame
        label.text = "自选股本周暂无异动信息:)"
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    private lazy var lineView: UIView = {
        let _lineView = UIView()
        _lineView.frame = CGRectMake(64, 10, 1, AppHeight)
        _lineView.backgroundColor = self.defalutColor
        _lineView.hidden = true
        return _lineView
    }()
        
}

//MARK: UITableViewDelegate,UItableViewDataSource
extension OptionChangeView: UITableViewDelegate,UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionChangeCell") as! OptionChangeCell
        
        if indexPath.row == 0 {
            if indexPath.section == 0{
             cell.orderStateType = .Top
            }else {
               cell.orderStateType = .Section
            }
        } else if indexPath.row == row && indexPath.section == sec{
            cell.orderStateType = .Bottom
        } else {
            cell.orderStateType = .Middle
        }
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let view = OptionChangeHeaderView.init(frame: CGRectMake(0, 0, self.view.width, 20))
          presenter?.setDataToHeaderView(view, section: section)
          return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sec > 0 || row > 0{
         return 20
        }
        return 0
    }
}