//
//  MineSetterContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol MineSetterViewProtocol:class{
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func pushToMineView()
}

protocol MineSetterPresenterProtocol: class {
    var view : MineSetterViewProtocol?{get set}
    
    func getNoticSwitch()
    func setContentToView(cell:SetterDataSource,indexPath: NSIndexPath)
    func setNoticSwitch(noticeType : String,notice: String)
}

protocol MineSetterRepositoryProtocol:class {
    //API
    func loginOut(completion: (success: Bool,data: AnyObject)->())
    func getNoticeSwitch(completion: (success: Bool,data: AnyObject)->())
    func setNoticeSwitch(noticeType : String,notice: String,completion: (success: Bool,data: AnyObject)->())
    
    //Local
    func invalidToken(userToken : String)
    func savePushInfo(Info : SetterItem)
}

protocol SetterDataSource {
    func set(notice notice:Bool)
    func set(name name: String,indexPath: NSIndexPath)
}