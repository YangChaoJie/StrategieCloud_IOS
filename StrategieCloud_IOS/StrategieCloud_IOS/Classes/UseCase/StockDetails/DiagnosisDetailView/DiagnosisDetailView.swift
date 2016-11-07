//
//  DiagnosisDetailView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class DiagnosisDetailView: BaseVC {
    private struct Nib {
        static let strategy = "DiagnosisStrategyCell"
        static let starRating = "StarViewCell"
        static let Profit = "ProfitTableViewCell"
        static let Chart = "StrategyChartTableViewCell"
    }
    
    private struct NibID {
        static let starRating = "StarViewCellID"
        static let strategy = "DiagnosisStrategyCellID"
        static let Section = "SectionHeaderViewID"
        static let Profit = "ProfitTableViewCellID"
        static let Chart = "StrategyChartTableViewCellID"
    }
    private let EachSectionCellCount = Int(2)
    
    var stockCode: String?
    var requestSuccess = false
    
    private var presenter: DiagnosisDetailPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DiagnosisDetailPresenter(view: self)
        view.backgroundColor = UIColor.darkGrayColor()
            //UIColor.colorWith(240, green: 244, blue: 255, alpha: 1.0)
        self.view.addSubview(tableView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(close))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if let code = stockCode {
            presenter.diagnosestock(code)
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
        let _tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        _tableView.registerNib(UINib(nibName: Nib.strategy, bundle: nil), forCellReuseIdentifier: NibID.strategy)
        _tableView.registerNib(UINib(nibName: Nib.starRating, bundle: nil), forCellReuseIdentifier: NibID.starRating)
        _tableView.registerNib(UINib(nibName: Nib.Profit, bundle: nil), forCellReuseIdentifier: NibID.Profit)
        _tableView.registerNib(UINib(nibName: Nib.Chart, bundle: nil), forCellReuseIdentifier: NibID.Chart)
        
        _tableView.backgroundColor = UIColor.colorWith(239, green: 238, blue: 244, alpha: 1.0)
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.tableFooterView = UIView.init()
        return _tableView
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
extension DiagnosisDetailView: DiagnosisDetailViewProtocol {
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
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension DiagnosisDetailView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        showToEmptyView()
        return presenter.numberOfSection()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(NibID.starRating, forIndexPath: indexPath) as! StarBarCell
            presenter.setContentToView(cell)
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(NibID.Profit, forIndexPath: indexPath) as! ProfitTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                presenter.setContentToProfitView(indexPath.section, dataSource: cell)
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(NibID.Chart, forIndexPath: indexPath) as! StrategyChartTableViewCell
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                presenter.setContentToChartView(indexPath.section, dataSource: cell)
                return cell
            }
        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < 2 {
            return CGFloat(10)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
         if indexPath.section == 0 {
            return CGFloat(44)
        }else{
            if (indexPath.row == 0) {
                return CGFloat(77)
            } else {
                return CGFloat(200)
            }
        }
    }
}
