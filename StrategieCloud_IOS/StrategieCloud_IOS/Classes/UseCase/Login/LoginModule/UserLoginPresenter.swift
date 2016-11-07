//
//  UserLoginPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import MonkeyKing
class UserLoginPresenter: UserLoginPresenterProtocol {
    weak var view : UserLoginViewProtocol?
    var repository: UserLoginDataSourceProtocol?
    var appKey : AppKeyItem?
    var QQItem: ThirdInfoItem?
    init() {
        repository = UserLoginRepository()
    }
    
    func loginByphone(phoneNumber : String, password : String) {
        repository?.loginbyphone(phoneNumber, password: password, completion: { (success, userToken,name) in
            if success {
                UserMannager.instance.setUserInfoRole("手机号 用户")
                self.repository?.persist(userToken, nickName: name)
                self.repository?.deleteDataSource()
                self.view?.viewBackToMineView()
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func getThirdPartySecret() {
        repository?.getThirdPartySecret({ (success, data) in
            if success {
               let status = data.valueForKey("status") as! String
                if status  == "success" {
                    let result = data.valueForKey("data")
                    let QQKey = result!.valueForKey("qq") as! String
                    let WXKey = result!.valueForKey("weixin") as! String
                    self.appKey = AppKeyItem.init(QQAppKey: QQKey, WXAppkey: WXKey)
                    self.view?.setAppAccount((self.appKey?.WXAppkey)!)
                }
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func QQLogin() {
        //judgmentToInstallApp(1)
        MonkeyKing.OAuth(.QQ, scope: "get_simple_userinfo") { (OAuthInfo, response, error) -> Void in
            self.repository?.QQLogin(OAuthInfo, completion: { (data,openId) in
                self.QQItem = ThirdInfoItem.init(data: data, openId: openId)
                UserMannager.instance.setUserInfoRole("qq 用户")
                //print("data=======\(self.QQItem)")
                self.loginByOpenid(self.QQItem!)
            })
        }
    }
    
    func WXLogin() {
        MonkeyKing.OAuth(.WeChat) { [weak self] (dictionary, response, error) -> Void in
            print("response: ===\(dictionary)==========\(response)")
            //print("error======\(error)")
            self?.repository?.WXLogin(dictionary, completion: { (data, mutableDictionary) in
                self?.QQItem = ThirdInfoItem.init(result: data,mutableDictionary: mutableDictionary)
                self?.loginByOpenid((self?.QQItem)!)
                UserMannager.instance.setUserInfoRole("微信 用户")
                print("返回的数据是=====\(data)")
            })
        }
    }
    
    func loginByOpenid(thirdItem: ThirdInfoItem) {
        repository?.loginbyopenid(thirdItem, completion: { (success, data) in
            if success {
                let status = data.valueForKey("status") as! String
                if status  == "success" {
                    let result = data.valueForKey("data")
                    let nickName = result!.valueForKey("nick_name") as! String
                    let userToken = result!.valueForKey("user_token") as! String
                    self.repository?.persist(userToken, nickName: nickName)
                    self.repository?.deleteDataSource()
                }
                self.view?.viewBackToMineView()
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func judgmentToInstallApp(index: Int) {
        switch index {
        case 0:
            if  openURL(URLString: "wechat://") == false {
                helper.alertShow("未安装微信客户端")
            }
        default:
            if  openURL(URLString: "mqqapi://") == false {
                helper.alertShow("未安装微信客户端")
            }
            
        }
    }
    
    private func openURL(URLString URLString: String) -> Bool {
        
        guard let URL = NSURL(string: URLString) else {
            return false
        }
        return UIApplication.sharedApplication().openURL(URL)
    }
    
}