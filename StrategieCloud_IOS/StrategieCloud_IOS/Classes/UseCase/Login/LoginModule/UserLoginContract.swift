//
//  UserLoginContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol UserLoginViewProtocol: class {
   func viewBackToMineView()
   func notifyFetchFailure()
   func setAppAccount(appKey: String)  
}

protocol UserLoginPresenterProtocol: class {
    var view: UserLoginViewProtocol? {get set}
    func loginByphone(phoneNumber : String, password : String)
    func getThirdPartySecret() 
    func QQLogin()
    func WXLogin()
}

protocol UserLoginDataSourceProtocol: class {
    func loginbyphone(phoneNumber : String, password : String, completion: (success: Bool,userToken :String,name: String)->())
    func getThirdPartySecret(completion:(success: Bool, data: AnyObject)->())
    func loginbyopenid(thirdItem: ThirdInfoItem,completion:(success: Bool, data: AnyObject)->())
    func QQLogin(OAuthInfo: NSDictionary?,completion:(data: AnyObject,openId: String)->())
    func WXLogin(OAuthInfo: NSDictionary?,completion:(data: AnyObject,mutableDictionary: NSMutableDictionary)->())
    //local
    func persist(userToken : String, nickName : String)
    func deleteDataSource()

}