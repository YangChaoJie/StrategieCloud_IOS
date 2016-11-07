//
//  UserLoginRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class UserLoginRepository: UserLoginDataSourceProtocol {
    /*
     *手机号登录
     */
    func loginbyphone(phoneNumber : String, password : String, completion: (success: Bool,userToken :String,name: String)->()) {
        Alamofire.request(Router.userLogin(phone_number: phoneNumber, password: password)).responseJSON{response in
            switch response.result {
            case .Success(let value):
                print("\(value)")
                let status = value.valueForKey("status") as! String
                if status == "error" {
                    let data = value.valueForKey("data") as! String
                    let errorMessage = helper.cutOffErrorMessage(data)
                    hudView.noticeOnlyText2(errorMessage)
                }else if status == "success" {
                    let data = value.valueForKey("data")
                    let s = data?.valueForKey("user_token") as! String
                    let nickName  = data?.valueForKey("nick_name") as! String
                    print("\(s)")
                    completion(success: true, userToken: s,name: nickName)
                }
            case .Failure( let value):
                print("\(value)")
                completion(success: false, userToken: "",name: "")
            }
        }
    }
    
    /*
     * 获取第三方的登录的Sercet
     */
    func getThirdPartySecret(completion:(success: Bool, data: AnyObject)->()) {
        Alamofire.request(Router.getThirdPartySecret("301")).responseJSON{response in
            switch response.result {
            case .Success(let value):
                print("第三方====\(value)")
                completion(success: true, data: value)
            case .Failure(let error):
                completion(success: false, data: "")
                print("error: \(error)")
            }
        }
    }
    /*
     * 第三方登录
     */
    func loginbyopenid(thirdItem: ThirdInfoItem,completion:(success: Bool, data: AnyObject)->()) {
        let parameters: [String: AnyObject] = [
            "nick_name": thirdItem.nickName,
            "avatar_url": thirdItem.avatarUrl,
            "open_id": thirdItem.openId,
            "platform": thirdItem.platform,
            "platform_info": thirdItem.platform_info
        ]
        print("参数是===\(parameters)")
        Alamofire.request(Router.loginByOpenId(parameters)).responseJSON{response in
            switch response.result {
            case .Success(let value):
                print("请求的数据===\(value)")
                completion(success: true, data: value)
            case .Failure(let error):
                completion(success: false, data: "")
                print("error: \(error)")
            }
        }
    }
   
    func QQLogin(OAuthInfo: NSDictionary?,completion:(data: AnyObject,openId: String)->()) {
        guard let token = OAuthInfo?["access_token"] as? String ,
            let openID = OAuthInfo?["openid"] as? String  else {
                return
        }
        let query = "get_simple_userinfo"
        let userInfoAPI = "https://graph.qq.com/user/\(query)"
    
        let parameters = [
            "openid": openID,
            "access_token": token,
            "oauth_consumer_key": Configs.QQ.appID
        ]
        
        SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters, completionHandler: { (userInfoDictionary, _, _) -> Void in
            print("userInfoDictionary \(userInfoDictionary)")
            if userInfoDictionary != nil {
                completion(data: userInfoDictionary!,openId: openID)
            }
        })
    }
    
    func WXLogin(OAuthInfo: NSDictionary?,completion:(data: AnyObject,mutableDictionary: NSMutableDictionary)->()) {
        guard let token = OAuthInfo?["access_token"] as? String,
            let openID = OAuthInfo?["openid"] as? String,
            let refreshToken = OAuthInfo?["refresh_token"] as? String,
            let expiresIn = OAuthInfo?["expires_in"] as? Int else {
                return
        }
        
        let userInfoAPI = "https://api.weixin.qq.com/sns/userinfo"
        
        let parameters = [
            "openid": openID,
            "access_token": token
        ]
        
        SimpleNetworking.sharedInstance.request(userInfoAPI, method: .GET, parameters: parameters, completionHandler: { (userInfoDictionary, _, _) -> Void in
            
            guard let mutableDictionary = userInfoDictionary?.mutableCopy() as? NSMutableDictionary else {
                return
            }
            
            mutableDictionary["access_token"] = token
            mutableDictionary["openid"] = openID
            mutableDictionary["refresh_token"] = refreshToken
            mutableDictionary["expires_in"] = expiresIn
            completion(data: userInfoDictionary!,mutableDictionary:mutableDictionary)
            print("userInfoDictionary====== \(userInfoDictionary)")
            
        })
    }
    
    
    
    //local
    func persist(userToken : String, nickName : String){
        let user = UserMannager.instance
        if userToken != "" {
            user.setUserToken(userToken)
        }
        user.setUserName(nickName)
        user.setLoginStatues(true)
    }
    
    func deleteDataSource() {
        RealmHelper.instance.deleteAllStock()
    }
    
    
}