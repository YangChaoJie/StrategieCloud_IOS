//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

class LoginPresenter: LoginPresenterProtocol, LoginInteractorOutputProtocol
{
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var wireFrame: LoginWireFrameProtocol?
    
    init() {}
    //MARK: LoginPresenterProtocol
    func getAuthentiCode(code : String, phoneNumber: String)  {
        self.interactor?.getCode(code, phone: phoneNumber)
    }
    
    func register(phone_number: String, authenticode: String, password: String,navView: UINavigationController){
        self.interactor!.register(phone_number, authenticode: authenticode, password: password, completion:{ (success) in
            if success {
                hudView.successNotice(HudCodeMessage.resigerSucess.rawValue)
                self.interactor?.deleteDataSource()
                self.presentUserSetView(navView)
                UserMannager.instance.setUserInfoRole("手机号 用户")
            }else {
                self.presentUserSetView(navView)
            }
        })
    }
    
    func login(phoneNumber : String, password : String,navView: UINavigationController){
        self.interactor?.login(phoneNumber, password: password, completion: { (success) in
            if success {
                hudView.noticeSuccess(HudCodeMessage.loginSucess.rawValue,autoClear: true)
                self.comeBackLoginModule(navView)
                self.getUserInfo()
                self.interactor?.deleteDataSource()
            }else {
                hudView.noticeOnlyText2("网络出现错误")
            }
        })
    }
    
    func resetPassword(phone_number: String, authenticode: String, password: String,navView: UINavigationController) {
        self.interactor?.resetPassword(phone_number, authenticode: authenticode, password: password, completion: { (success) in
            if success {
                self.comeBackLoginModule(navView)
            }else {
            }
        })
    }
    
    func loginOut(navView: UINavigationController)  {
        self.interactor?.loginOut({ (success) in
            if success {
                self.comeBackMineModule(navView)
                self.interactor?.deleteDataSource()
            }else {
                self.comeBackMineModule(navView)
            }
        })
    }
    
    func uploadImage(image : UIImage, name : String, navView: UINavigationController){
        self.interactor?.uploadImage(image, name: name, completion: { (success) in
            if success {
				self.view?.notifyFetchSuccess()
                self.comeBackMineModule(navView)
			}
        })
    }
    
    func uploadImage(image : UIImage, name : String){
        self.interactor?.uploadImage(image, name: name, completion: { (success) in
            if success {
                self.view?.notifyFetchSuccess()
            }
        })
    }
	
	func uploadImageFailure() {
		view?.uploadImageFailure()
	}
    
    
    func getUserInfo() {
        self.interactor?.getUserInfo({ (success) in
            
        })
    }
    
    func registerModule(view: UINavigationController, title : String) {
       // self.wireFrame?.registerViewModule(view, title: title)
    }
    
    func comeBackLoginModule(view: UINavigationController){
        self.wireFrame?.LoginViewModule(view)
    }
    
    func comeBackMineModule(view: UINavigationController){
        self.wireFrame?.MineViewModule(view)
    }
    
    func presentUserSetView(view: UINavigationController){
        self.wireFrame?.presentUserSetInfoView(view)
    }
    
    func presentUserNameView(navView: UINavigationController){
        self.wireFrame?.presentUserNameView(navView)
    }
    
    func comeBackUserNameView(view: UINavigationController ,name: String){
        interactor?.updateUserInfo(name, avatarUrl: UserMannager.instance.getAvatarUrl(), completion: { (success) in
            
        })
        self.wireFrame?.UserNameViewModule(view)
    }
}