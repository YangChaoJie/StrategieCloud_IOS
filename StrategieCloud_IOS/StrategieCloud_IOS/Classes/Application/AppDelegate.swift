//
//  AppDelegate.swift
//  ArtOfWarCloud_IOS
//
//  Created by 杨超杰 on 16/4/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import AudioToolbox
import MonkeyKing
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	let account = MonkeyKing.Account.QQ(appID: Configs.QQ.appID)
	let wxAccount = MonkeyKing.Account.WeChat(appID: Configs.Wechat.appID, appKey: Configs.Wechat.appKey)
	
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

		UITabBar.setupStyle()
		UINavigationBar.setupStyle()

        setKeyWindow()
        UMSetInfo(launchOptions)
		realmMigration()
		
		MonkeyKing.registerAccount(account)
		MonkeyKing.registerAccount(wxAccount)
		
		AppDelegate.updateUserInfo()
        return true
    }
    
    private func UMSetInfo(launchOptions: [NSObject: AnyObject]?) {
		let appKey = "575cc33ee0f55aaa1400378d"

		MobClick.setAppVersion(SysUtils.appVersionNumber())

        let analytics = UMAnalyticsConfig.sharedInstance()
        analytics.appKey = appKey
        MobClick.startWithConfigure(analytics)
		MobClick .setLogEnabled(true)

        UMessage.startWithAppkey(appKey, launchOptions: launchOptions)
        UMessage.registerForRemoteNotifications()
        UMessage.setLogEnabled(true)
    }
    
    private func setKeyWindow() {
        window = UIWindow(frame: MainBounds)
		window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = getRootViewController()
        window?.makeKeyAndVisible()
    }
	
    private func getRootViewController() -> UIViewController {
		
		//得到当前应用的版本号
		let currentAppVersion = SysUtils.appVersionNumber()
		let userDefaults = NSUserDefaults.standardUserDefaults()
		let appVersion = userDefaults.stringForKey("appVersion")
		// 如果appversion为nil说明是第一次启动；如果appVersion不等于currentAppVersion说明是更新了
		if appVersion == nil || appVersion != currentAppVersion {
			userDefaults.setValue(currentAppVersion, forKey: "appVersion")
			// v1.0.1版时默认设置switch开
			if currentAppVersion == "1.0.1" {
				NSUserDefaults.standardUserDefaults().setBool(true, forKey: KLineTopInfoView.BSSwitchKey)
				NSUserDefaults.standardUserDefaults().synchronize()
			}
			return GuideViewController() as UIViewController
		}
        return MainTabBarViewController() as UIViewController
    }
	
	private func realmMigration() {

		let config = Realm.Configuration(
			// 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
			schemaVersion: 1,

			// 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
			migrationBlock: { migration, oldSchemaVersion in
				if (oldSchemaVersion < 1) {
				}
		})
		Realm.Configuration.defaultConfiguration = config
		let _ = try! Realm()

	}
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if MonkeyKing.handleOpenURL(url) {
            return true
        }
        return false
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        UMessage.registerDeviceToken(deviceToken)
		UserMannager.instance.setdeviceToken(convertDeviceTokenToString(deviceToken))
		AppDelegate.updateUserInfo()
    }
    
    private func convertDeviceTokenToString(deviceToken:NSData) -> String {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString( " ", withString: "") as String
       return deviceTokenString
    }
	
	private func playAudioFile() {
		var soundID: SystemSoundID = 0
		let fileURL = NSBundle.mainBundle().URLForResource("winner_push_sound", withExtension: "caf")
		AudioServicesCreateSystemSoundID(fileURL!, &soundID)
		AudioServicesPlayAlertSound(soundID)
	}
	
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
		AppDelegate.updateUserInfo()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
		UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
		playAudioFile()
		
		if UIApplication.sharedApplication().applicationState == UIApplicationState.Active {
			let alertMsg = (userInfo as NSDictionary).objectForKey("aps")!.objectForKey("alert") as! String
			let alertController = UIAlertController(title: "消息提示", message: alertMsg, preferredStyle: UIAlertControllerStyle.Alert)
			let confirmAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Cancel, handler: { (_) in
				UMessage.sendClickReportForRemoteNotification(userInfo)
			})
			alertController.addAction(confirmAction)
			window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
		}
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

