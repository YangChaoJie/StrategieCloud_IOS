//
//  MineSetterPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class MineSetterPresenter: MineSetterPresenterProtocol {
    weak var view : MineSetterViewProtocol?
    var repsoitory: MineSetterRepositoryProtocol?
    var notices : SetterItem?
    let dataList : [[String]] = [["异动信息","BS点"],["直播信息"]]
    init() {
       repsoitory = MineSetterRepository()
    }
    
    func setContentToView(cell:SetterDataSource,indexPath: NSIndexPath) {
      if notices != nil {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.set(notice:(notices?.glamour)!)
                
            }else if indexPath.row == 1 {
                cell.set(notice: (notices?.buySell)!)
            }
        case 1:
            if indexPath.row == 0 {
                cell.set(notice: (notices?.liveInfo)!)
            }
        default: return
            }
        }
        cell.set(name: dataList[indexPath.section][indexPath.row],indexPath:indexPath)
    }
    
    
    func getNoticSwitch() {
        repsoitory?.getNoticeSwitch({ (success, data) in
            if success {
                //print("data====\(data)")
                let result = data.valueForKey("data")
                let status = data.valueForKey("status") as! String
                if status == "success" {
                    let buysell = result!.valueForKey("buysell") as! Bool
                    let glamour = result!.valueForKey("glamour") as! Bool
                    let v = result!.valueForKey("liveinfo") as! Bool
                 
                    self.notices = SetterItem.init(buySell: buysell, glamour: glamour, liveInfo:v)
                    self.repsoitory?.savePushInfo(self.notices!)
                }
                 print("data====\(self.notices)")
                self.view?.notifyFetchSuccess()
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func setNoticSwitch(noticeType : String,notice: String) {
        repsoitory?.setNoticeSwitch(noticeType, notice: notice, completion: { (success, data) in
            if success {
                if noticeType == "buysell" {
                    if notice == "true" {
                      self.notices?.buySell = true
                    }else {
                      self.notices?.buySell = false
                    }
                }else if noticeType == "glamour" {
                    if notice == "true" {
                        self.notices?.glamour = true
                    }else {
                        self.notices?.glamour = false
                    }
                }else if noticeType == "liveinfo" {
                    if notice == "true" {
                        self.notices?.liveInfo = true
                    }else {
                        self.notices?.liveInfo = false
                    }
                }
               self.repsoitory?.savePushInfo(self.notices!)
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
}