//
//  UserSingleton.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/22.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
public class UserMannager{
	
	enum UserRole: Int {
		case UnRegister = 201
		case Registered = 202
		case Payed = 203
		case Admin = 204
	}
	
    static let instance = UserMannager()
	
    private let qqMesage = "com.ringear.strategiescloud.usermanager.qqMesage"
    private let wxMesage = "com.ringear.strategiescloud.usermanager.wxMesage"
    private let userID = "com.ringear.strategiescloud.usermanager.userID"
    private let userToken = "com.ringear.strategiescloud.usermanager.user_token"
    private let userRole = "com.ringear.strategiescloud.usermanager.userRole"
    private let headImageUrl = "com.ringear.strategiescloud.usermanager.headImageUrl"
    private let userName = "com.ringear.strategiescloud.usermanager.userName"
    private let state = "com.ringear.strategiescloud.usermanager.state"
    private let userUuid = "com.ringear.strategiescloud.usermanager.uuid"
    private let buySellInfo = "com.ringear.strategiescloud.usermanager.buySellInfo"
    private let glamourInfo = "com.ringear.strategiescloud.usermanager.glamourInfo"
    private let deviceToken = "com.ringear.strategiescloud.usermanager.deviceToken"
    private let userInfoRole = "com.ringear.strategiescloud.usermanager.userInfoRole"
    private let popState = "com.ringear.strategiescloud.usermanager.pop"
    private static let baseUrl = "com.ringear.strategiescloud.usermanager"
    public static let AvataUrlKey = UserMannager.baseUrl + ".tempavatarurl"
	public static let changeState = UserMannager.baseUrl + ".changeState"
    init(){
    }
	
	let UserDefault = NSUserDefaults.standardUserDefaults()
	
	
	
    public func setUserRole(role : Int) {
         NSUserDefaults.standardUserDefaults().setObject(role, forKey: userRole)
    }
    
    public func getUserRole(){
         NSUserDefaults.standardUserDefaults().objectForKey(userRole)
    }
    
    public func loginOut() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userID)
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(userToken)
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(userUuid)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(headImageUrl)
        NSUserDefaults.standardUserDefaults().removeObjectForKey(userName)
        UserDefault.removeObjectForKey(UserMannager.AvataUrlKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func setUserID(token : String){
        NSUserDefaults.standardUserDefaults().setObject(token, forKey: userID)
    }
    
    public func getUserID()  -> String? {
        return NSUserDefaults.standardUserDefaults().objectForKey(userID) as? String
    }
    
    public func setUserName(name : String){
        NSUserDefaults.standardUserDefaults().setObject(name, forKey: userName)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func getUserName()  -> String {
        return (NSUserDefaults.standardUserDefaults().objectForKey(userName) as? String) ?? ""
    }
    
    public func getUserInfoRole()-> String {
        return (NSUserDefaults.standardUserDefaults().objectForKey(userInfoRole) as? String) ?? ""
    }
    
    public func setUserInfoRole(role: String) {
        NSUserDefaults.standardUserDefaults().setObject(role, forKey: userInfoRole)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func setUserToken(token :String) {
         UserDefault.setObject(token, forKey: userToken)
         UserDefault.synchronize()
    }
    
    public func getUserToken() -> String{
		return (UserDefault.objectForKey(userToken) as? String) ?? ""
    }
    
    public func setLoginStatues(statue: Bool ) {
        NSUserDefaults.standardUserDefaults().setObject(statue, forKey: state)
		NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func getLoginStatues()->Bool {
		if let state = NSUserDefaults.standardUserDefaults().objectForKey(state) as? Bool {
			return state
		}
		return false
    }
    
    public func setPopState(pop: Bool) {
        UserDefault.setObject(pop, forKey: popState)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    public func getPopState() -> Bool {
        if let state = NSUserDefaults.standardUserDefaults().objectForKey(popState) as? Bool {
            return state
        }
        return false
    }
    
    
    public func setUuid(uuid : String){
		UserDefault.setObject(uuid, forKey: userUuid)
		UserDefault.synchronize()
    }
	
    public func getUuid() -> String {
		guard let _ = UserDefault.objectForKey(userUuid) as? String else {
			setUuid(DeviceInfo.deviceUUID)
			return UserDefault.objectForKey(userUuid) as! String
		}
		return UserDefault.objectForKey(userUuid) as! String
    }
    
    public func setdeviceToken(token : String){
        UserDefault.setObject(token, forKey: deviceToken)
        UserDefault.synchronize()
    }
    
    public func getdeviceToken()-> String {
         return (UserDefault.objectForKey(deviceToken) as? String) ?? ""
    }
    

    func setAvatarUrl(url: String) {
        UserDefault.setObject(url, forKey: UserMannager.AvataUrlKey)
    }
    
    func getAvatarUrl() -> String {
        return UserDefault.objectForKey(UserMannager.AvataUrlKey) as? String ?? ""
    }
    
    func  setChangeState(state:Bool) {
        NSUserDefaults.standardUserDefaults().setObject(state, forKey: UserMannager.changeState)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func getChangeState()-> Bool {
        return NSUserDefaults.standardUserDefaults().objectForKey(buySellInfo) as? Bool ?? false
    }
}
