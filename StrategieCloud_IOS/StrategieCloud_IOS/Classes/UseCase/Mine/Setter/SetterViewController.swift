//
//  SetterViewController.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class SetterViewController: BaseVC,MineSetterViewProtocol {
    var presenter: MineSetterPresenterProtocol?
    struct Nib {
        static let CellName = "SetterViewCell"
    }
    
    struct Cell {
        static let CellID = "SetterViewCellID"
    }
    let nameColor = UIColor.colorWith(53, green: 67, blue: 70, alpha: 1)
    //MARK: View Life
    /*
     * 解决tabbar 隐藏不能解决的问题，Mine ShareView
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.colorWith(240, green: 244, blue: 255, alpha: 1.0)
        self.view.addSubview(tableView)
        commmonInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getNoticSwitch()
        judgeToSystemPush()
        self.tableView.reloadData()
    }
   
    // MARK: - HotStockViewProtocol
    func notifyFetchSuccess() {
        print(#function)
        self.tableView.reloadData()
//        hudView.noticeTop("行情更新成功 "+helper.getCurrentTime())
        // 结束刷新
    }
    
    func notifyFetchFailure() {
        hudView.noticeOnlyText2("网络不给力啊```")
        print(#function)
    }
    
    private func commmonInit() {
        presenter = MineSetterPresenter()
        presenter?.view = self
    }
    
    
    func judgeToSystemPush() {
        let notificationType = UIApplication.sharedApplication().currentUserNotificationSettings()!.types
        if notificationType == UIUserNotificationType.None {
          showAlert()
        } else {
          print("ON")
        }
    }
    
    func openSystemPush() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "标题", message: "系统检测到您的推送开关处于关闭状态，无法收到任何兵法云的推送信息，您是否打开推送开关", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        let okAction = UIAlertAction(title: "打开推送", style: UIAlertActionStyle.Default){
            (action: UIAlertAction!) -> Void in
            self.openSystemPush()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func pushToMineView() {
       self.navigationController?.popViewControllerAnimated(true)
		
		let tb = UITableView()
		tb.allowsSelection = false
    }
    
    // MARK: - Setter And Getter
    
    private lazy var tableView: UITableView = {
        let _tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .Grouped)
        _tableView.registerNib(UINib(nibName: Nib.CellName, bundle: nil), forCellReuseIdentifier: Cell.CellID)
        _tableView.dataSource = self
        _tableView.delegate = self
		_tableView.allowsSelection = false
        return _tableView
    }()
    
    private lazy var headerView: SetterHeaderView = {
        let _view = SetterHeaderView.init(frame: CGRectMake(0, 0, self.view.width, HeaderH))
        return _view
    }()
}
// MARK: - UITableViewDataSource UITableViewDelegate
extension SetterViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.CellID)! as! SetterViewCell
        cell.delegate = self
       // cell.mySwitch.tag = indexPath.row
        presenter?.setContentToView(cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "选股推送"
        }else{
            return "直播推送"
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

}

extension SetterViewController : SetterCellDelegate {
    func setNotice(type: String,notice: Bool) {
        if notice == true {
            presenter?.setNoticSwitch(type, notice: "true")
        }else {
            presenter?.setNoticSwitch(type, notice: "false")
        }
      
    }
}