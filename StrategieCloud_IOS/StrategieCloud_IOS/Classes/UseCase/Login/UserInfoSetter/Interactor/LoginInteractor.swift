//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

class LoginInteractor: LoginInteractorInputProtocol
{
    weak var presenter: LoginInteractorOutputProtocol?
    var APIDataManager: LoginAPIDataManagerInputProtocol?
    var localDatamanager: LoginLocalDataManagerInputProtocol?
    
    init() {}
    func getCode(code : String , phone : String)  {
        self.APIDataManager?.getAuthenticode(code, phoneNumber: phone)
    }
    
    func register(phone_number: String, authenticode: String, password: String, completion: (success: Bool)->()) {
        self.APIDataManager?.registerbyphone(phone_number, authenticode: authenticode, password: password, completion: { (success, userToken) in
            self.localDatamanager?.persist(userToken, phoneNumber:phone_number)
            completion(success: success)
        })

    }
    
    func login(phoneNumber : String, password : String, completion: (success: Bool)->()){
        self.APIDataManager?.loginbyphone(phoneNumber, password: password, completion: { (success, userToken) in
            self.localDatamanager?.persist(userToken, phoneNumber:phoneNumber)
            completion(success: success)
        })
        
    }
    
    func resetPassword(phone_number: String, authenticode: String, password: String,completion: (success: Bool)->()) {
        self.APIDataManager?.resetPassword(phone_number, authenticode: authenticode, password: password, completion: { (success) in
            completion(success: success)
        })
        
    }
    
    func loginOut(completion:(success: Bool)->()) {
        self.APIDataManager?.loginOut({ (success, userToken) in
			StrategyCloudAvatarCache.clearDiskCache()
			UserMannager.instance.setAvatarUrl("")
            self.localDatamanager?.invalidToken(userToken)
            completion(success: success)
        })
    }
    
    func uploadImage(image : UIImage, name : String, completion:(success: Bool)->()){
        self.APIDataManager?.getUploadUrl({ (success, url) in
            if let uploadUrl : String = url {
                let downloadUrl = uploadUrl.componentsSeparatedByString("?")[0]
                let splitedArray = downloadUrl.componentsSeparatedByString("/")
                let avatarName = splitedArray[splitedArray.count - 1]
                if image.size.height != 0 {
                    //上传头像
                    let saveInfo = self.saveImage(image, percent: 0.6, imageName: avatarName)
                    if saveInfo.saveSuccess {
                       self.APIDataManager?.postImage(uploadUrl, imageUrl:saveInfo.filePath, completion: { (success) in
							self.APIDataManager?.updateUserInfo(UserMannager.instance.getUserName(), avatarUrl: downloadUrl, completion: { (success) in
								if success {
									StrategyCloudAvatarCache.clearDiskCache()
									UserMannager.instance.setAvatarUrl("")
									print("upload avatar success")
								} else {
									self.presenter?.uploadImageFailure()
								}
								completion(success: success)
							})
                       })
                    }
                }
            }
        })
    }
   
    func updateUserInfo(name : String, avatarUrl: String, completion:(success: Bool)->()) {
       self.APIDataManager?.updateUserInfo(name, avatarUrl: avatarUrl, completion: { (success) in
               completion(success: success)
       })
        
    }
    
    func getUserInfo(completion:(success: Bool )->())  {
        self.APIDataManager?.getUserInfo({ (success, nickName, avatarUrl) in
            self.localDatamanager?.persistUserInfo(nickName, image: avatarUrl)
            completion(success: true)
        })
    }
    
    func saveImage(newImage: UIImage, percent: CGFloat, imageName: String) -> (filePath: String, saveSuccess: Bool) {
        //高保真压缩图片质量
        let imageData = UIImageJPEGRepresentation(newImage, percent)
        // 获取沙盒目录，这里将图片放在沙盒的tmp文件夹中
        let fullPath = (NSTemporaryDirectory() as NSString).stringByAppendingPathComponent(imageName)
    
        let ret = imageData?.writeToFile(fullPath, atomically: false)
        return (fullPath, ret!)
    }
    
    func deleteDataSource() {
        localDatamanager?.deleteDataSource()
    }
    
}