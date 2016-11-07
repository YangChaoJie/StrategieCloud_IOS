//
//  MineSetterRepsitory.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class MineSetterRepository: MineSetterRepositoryProtocol {
    //API
    /*
     *退出登录
     */
    func loginOut(completion: (success: Bool,data: AnyObject)->()){
        let parameters: [String: AnyObject] = [
            "device_id": UserMannager.instance.getUuid()
        ]
        Alamofire.request(Router.LoginOut(parameters)).responseJSON { (response: Response<AnyObject, NSError>) in
            print("---------<> \(response.result.value)")
            switch response.result {
            case .Success(let value):
                completion(success: true, data: value)
            case .Failure(let value):
                completion(success: false,data: value)
            }
        }
    }
    
    //获取推送状态
    func getNoticeSwitch(completion: (success: Bool,data: AnyObject)->()) {
        Alamofire.request(Router.getNoticeSwitch).responseJSON{ (response: Response<AnyObject, NSError>) in
            print("---------<> \(response.result.value)")
            switch response.result {
            case .Success(let value):
                completion(success: true, data: value)
            case .Failure(let value):
                completion(success: false,data: value)
            }
       }
    }
    //设置推送状态
    func setNoticeSwitch(noticeType : String,notice: String,completion: (success: Bool,data: AnyObject)->()) {
        let parameter: [String : AnyObject] =
            [
               "notice_switch": notice,
               "notice_type": noticeType
            ]
        print("parameter==\(parameter)")
        Alamofire.request(Router.setNoticeSwitch(parameter)).responseJSON { (response) in
                print("response : \(response)")
             switch response.result {
            case .Success(let value):
            completion(success: true, data: value)
            case .Failure(let value):
            completion(success: false,data: value)
          }
        }
    }
    
    //local
    func invalidToken(userToken : String)  {
        let user = UserMannager.instance
        user.setUserToken(userToken)
        user.setLoginStatues(false)
        user.loginOut()
    }
    
    func deleteDataSource() {
        RealmHelper.instance.deleteAllStock()
    }
    
    func savePushInfo(Info : SetterItem) {
        //UserMannager.instance.setPushBuySellInfo(Info.buySell)
    }
    
}