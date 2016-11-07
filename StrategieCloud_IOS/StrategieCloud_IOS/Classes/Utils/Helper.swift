//
//  Helper.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/30.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import MJRefresh
enum ErrorCode : String {
    case headValid = "10401"
    case notUser = "10402"
    case notAuthority = "10403"
    case derviceId = "10404"
    case loginOther = "10405"
    case verify = "10406"
    case parameter = "10407"
    case phoneNumberOrPassword = "10408"
    case resgisted = "10409"
    case notStock = "10410"
    case option = "10411"
	
//	func desc() -> String {
//		switch self {
//		case .headValid:
//			return "head Authorization is not valid"
//		case .notUser:
//			return "用户不存在"
//		}
//	}
}

enum HudCodeMessage : String {
    case headValid = "head Authorization is not valid"
    case notUser = "用户不存在"
    case notAuthority = "没有权限访问"
    case derviceId = "device id 出现错误"
    case loginOther = "用户已在其他设备上登录"
    case verify = "验证码错误"
    case parameter = "参数错误"
    case phoneNumberOrPassword = "手机号或密码错误"
    case resgisted = "号码已注册"
    case notStock = "股票不存在"
    case option = "option错误"
    case uploadSucess = "上传成功"
    case loginSucess = "登录成功"
    case resigerSucess = "注册成功"
    case resetPasswordSucess = "重置密码成功"
    case phoneError = "手机号码格式错误"
    case passwordError = "密码长度必须为6~~10位"
}

class helper {
   //获取随机字符串
  class func getRandomStringOfLength(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var ranStr = ""
        for _ in 0..<length {
            let index = Int(arc4random_uniform(UInt32(characters.characters.count)))
            ranStr.append(characters[characters.startIndex.advancedBy(index)])
        }
        return ranStr
  }
  //截取错误码
  class func cutOffErrorCode(data :String)->String{
       let message = (data as NSString).substringToIndex(5)
       return message
   }
  //截取错误信息
  class func cutOffErrorMessage(data : String) -> String{
       let message = (data as NSString).substringFromIndex(6)
       return message
    }
  //获取系统时间 小时
    class func getCurrentTime()->String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    class func getCurrentDay()->String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM-dd"
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    //提示框
    class func messageShow(message: String,view: UIViewController) {
         let alertController = UIAlertController(title: "温馨提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)
         let cancelAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: nil)
         alertController.addAction(cancelAction)
         view.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func alertShow(message: String) {
        let alert = UIAlertView.init(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
        alert.show()
    }
    
    //设置刷新的字体大小
    class func setHeaderRefresh(header: MJRefreshNormalHeader) {
        header.stateLabel.font = UIFont.systemFontOfSize(10)
        header.stateLabel.textColor = UIColor.headerRefreshTextColor()
        header.lastUpdatedTimeLabel.font = UIFont.systemFontOfSize(10)
        header.lastUpdatedTimeLabel.textColor = UIColor.headerRefreshTextColor()
    }
}

let hudView = UIViewController()
class  InfoExamineHelper {
  // 检查密码是否为6-10位
  class func isPasswordOK(textField: UITextField) -> Bool {
        let MinPswLength = 6
        let MaxPswLength = 10
        if let psw = textField.text {
            let pswLength = (psw as NSString).length
            if pswLength >= MinPswLength && pswLength <= MaxPswLength {
                return true
            }
        }
        return false
    }
    // 判断手机号格式是否正确
   class func isTelNumber(number: String) -> Bool {
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[019]|77)[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        if ((regextestmobile.evaluateWithObject(number) == true)
            || (regextestcm.evaluateWithObject(number)  == true)
            || (regextestct.evaluateWithObject(number) == true)
            || (regextestcu.evaluateWithObject(number) == true))
        {
            return true
        } else {
            return false
        }
    }
}

