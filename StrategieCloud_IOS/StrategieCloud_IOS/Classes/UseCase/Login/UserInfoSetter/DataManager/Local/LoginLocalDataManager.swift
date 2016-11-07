//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

class LoginLocalDataManager: LoginLocalDataManagerInputProtocol
{
    init() {}
    func persist(userToken : String, phoneNumber : String){
        let user = UserMannager.instance
        if userToken != "" {
          user.setUserToken(userToken)
        }
        user.setUserID(phoneNumber)
        user.setLoginStatues(true)
    }
    
    func invalidToken(userToken : String)  {
        let user = UserMannager.instance
        user.setUserToken(userToken)
        user.setLoginStatues(false)
        user.loginOut()
    }
    
    func persistUserInfo(nickName : String , image : String)  {
        let user = UserMannager.instance
//        user.setHeadImageUrl(image)
        print("===\(nickName)")
        if nickName != "" {
          user.setUserName(nickName)
        }
    }
    
    func deleteDataSource() {
        RealmHelper.instance.deleteAllStock()
    }
}