//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation
import Alamofire
class LoginAPIDataManager: NSObject, LoginAPIDataManagerInputProtocol
{
    override init() {}
    
   /*
    *获取 手机验证码
    */
    func getAuthenticode(option : String , phoneNumber : String){
        Alamofire.request(Router.getAuthenticode(option, phoneNumber)).validate().responseJSON{response in
     print("response--> \(response), result-------------------------------------------------------> \(response.result)")
        }
    }
    /*
     *注册
     */
    func registerbyphone(phone_number: String, authenticode: String, password: String, completion: (success: Bool,
        userToken :String)->()) {
        Alamofire.request(Router.registerUser(phone_number: phone_number, authenticode: authenticode, password: password)).responseJSON{response in
            // TODO 是否已经注册，返回码是405, 验证码错误为501
            switch response.result {
            case .Success(let value):
                print("+++++++++++++++++++++++++++\(value)")
                let status = value.valueForKey("status") as! String
                if status == "error" {
                    let data = value.valueForKey("data") as! String
                    let errorMessage = helper.cutOffErrorMessage(data)
                    hudView.noticeOnlyText2(errorMessage)
                }else if status == "success" {
                    let data = value.valueForKey("data")
                    let s = data?.valueForKey("user_token") as! String
                    completion(success: true, userToken: s)
                }
            case .Failure(let value):
                print("++++++++++++\(value)")
                
            }
        }
    }
    
    /*
     *手机号登录
     */
    func loginbyphone(phoneNumber : String, password : String, completion: (success: Bool,userToken :String)->()) {
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
                    print("\(s)")
                    completion(success: true, userToken: s)
                  }
            case .Failure(let value):
                print("==========\(value)======")
                hudView.noticeOnlyText2("发生未知错误")
            }
        }
    }
    
    /*
     *退出登录
     */
    func loginOut(completion: (success: Bool,userToken :String)->()){
		let parameters: [String: AnyObject] = [
			"device_id": UserMannager.instance.getUuid()
		]
		Alamofire.request(Router.LoginOut(parameters)).responseJSON { (response: Response<AnyObject, NSError>) in
			print("---------<> \(response.result.value)")
            switch response.result {
                case .Success(let value):
                    let status = value.valueForKey("status") as! String
                    if status == "error" {
                        let data = value.valueForKey("data") as! String
                        let errorMessage = helper.cutOffErrorMessage(data)
                            hudView.noticeOnlyText2(errorMessage)
                    }else if status == "success" {
                        let data = value.valueForKey("data")
                        if data != nil {
                            let s = data?.valueForKey("user_token") as! String
                            completion(success: true, userToken: s)
                        }
                    }
                case .Failure(let value):
                print("\(value)")
                hudView.noticeOnlyText2("发生未知错误")
          }
            
        }
    }
    
    /*
     *重置密码
     */
    func resetPassword(phone_number: String, authenticode: String, password: String, completion: (success: Bool)->()) {
        Alamofire.request(Router.resetPassword(phone_number: phone_number, authenticode: authenticode, password: password)).responseJSON{response in
            switch response.result {
            case .Success(let value):
                let status = value.valueForKey("status") as! String
                if status == "error" {
                    let data = value.valueForKey("data") as! String
                    let errorMessage = helper.cutOffErrorMessage(data)
                    hudView.noticeOnlyText2(errorMessage)
                }else if status == "success" {
                    print("\(value)")
                    completion(success: true)
                }
            case .Failure(let value):
                print("\(value)")
            }
        }
    }
    /*
     *获取上传头像上传url
     */
    func getUploadUrl(completion: (success: Bool, url : String)->()) {
        Alamofire.request(Router.avatarUploadUrl).validate().responseJSON { response in
            switch response.result {
            case .Success(let value):
                print("获取上传头像 ----\(value)")
                if let data = value.valueForKey("data")  {
                    let urlString = data as! String
                    completion(success: true, url : urlString)
                }
            case .Failure(let value):
                print("获取上传头像 ----\(value)")
            }
       }
    }
    /*
     * 上传图片
     */
    func postImage(url : String , imageUrl : String, completion:(success: Bool)->()) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "PUT"
        let data = NSData(contentsOfFile: imageUrl)
        request.HTTPBody = data
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        session.uploadTaskWithStreamedRequest(request).resume()
        completion(success: true)
    }
    
    /*
     *更新头像昵称
     */
    func updateUserInfo(name :String, avatarUrl: String,completion:(success: Bool)->()) {
        let parameters: [String: AnyObject] = [
            "nick_name": name,
            "avatar_url": avatarUrl,
        ]
        Alamofire.request(Router.updateUserinfo(parameters)).validate().responseJSON { (response: Response<AnyObject, NSError>) in
            switch response.result {
            case .Success(let value):
                print("更新用户头像--\(value)")
                    completion(success: true)
            case .Failure(let value):
                print("更新用户头像--\(value)")
            }
        }
    }
    
    /*
     *获取头像昵称
     */
    func getUserInfo(completion:(success: Bool , nickName : String, avatarUrl : String)->()){
        Alamofire.request(Router.getUserInfo).validate().responseJSON{response in
            switch response.result {
            case .Success(let value):
                 let data = value.objectForKey("data")
                 let   nickName = data!.objectForKey("nick_name") as? String ?? ""
                 let   avatarUrl = data!.objectForKey("avatar_url") as? String ?? ""
                completion(success: true, nickName: nickName, avatarUrl : avatarUrl)
            case .Failure(let error):
                print("\(#function) error: \(error)")
            }
        }
    }
}

extension LoginAPIDataManager : NSURLSessionDelegate {
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error?.description == nil {
            print("====SUCESS++++++")
        } else {
            print("====ERROR \(error)")
        }
    }
    
}
