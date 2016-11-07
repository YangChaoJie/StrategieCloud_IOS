//
//  AppDelegateExtension.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension AppDelegate {

    class func updateUserInfo() {
		
        let parameters : [String: AnyObject] = [
            "device_token": UserMannager.instance.getdeviceToken(),
            "device_name": DeviceInfo.deviceName,
            "system_version": DeviceInfo.systemVersion,
            "device_type": "302",
            "device_id" : UserMannager.instance.getUuid()
        ]
        Alamofire.request(Router.AddUser(parameters )).responseJSON { (response: Response<AnyObject, NSError>) in
			print("\(#function):\(response)")
            switch response.result {
            case .Success(let value):
				let status = value["status"] as! String
				if status == "success" {
                    UserMannager.instance.setPopState(false)
					if let data = value["data"] as? NSDictionary {
						if let userToken = data["user_token"] as? String {
							UserMannager.instance.setUserToken(userToken)
						}
					}
				} else if status == "error" {
					let dataInfo = value["data"] as! String
					let errorCode = helper.cutOffErrorCode(dataInfo)
					let errorMessage = helper.cutOffErrorMessage(dataInfo)
					if errorCode == ErrorCode.loginOther.rawValue {
                        if UserMannager.instance.getPopState() == false {
						   helper.alertShow(errorMessage)
                           UserMannager.instance.setPopState(true)
                        }
						self.logout()
					}
				}
            case .Failure(let error):
                print("error: \(error)")
            }
        }
    }
	
	private class func logout() {
		let parameters = [
			"device_id": UserMannager.instance.getUuid()
		]
		
		Alamofire.request(Router.LoginOut(parameters)).responseJSON { (response: Response<AnyObject, NSError>) in
			switch response.result {
			case .Success(let value):
				if let status = value.valueForKey("status") as? String {
					if status == "success" {
						if let data = value.valueForKey("data") as? NSDictionary {
							let userToken = data.valueForKey("user_token") as! String
							UserMannager.instance.setUserToken(userToken)
							UserMannager.instance.setLoginStatues(false)
						}
					}
				}
			case .Failure(let error):
				print("\(#function) error: \(error)")
			}
		}
	}
}