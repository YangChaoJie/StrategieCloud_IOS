//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

protocol LoginViewProtocol: class
{
    var presenter: LoginPresenterProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> VIEW
    */
    func notifyFetchSuccess()
	func uploadImageFailure()
}

protocol LoginWireFrameProtocol: class
{
    //static func presentLoginModule(fromView nview: UINavigationController)
    /**
    * Add here your methods for communication PRESENTER -> WIREFRAME
    */
    func LoginViewModule(navView: UINavigationController)
    func MineViewModule(navView : UINavigationController)
    static func registerViewModule(title: String) ->UIViewController
    func presentUserNameView(navView: UINavigationController)
    
    func UserNameViewModule(navView: UINavigationController)
    func presentUserSetInfoView(navView: UINavigationController)
}

protocol LoginPresenterProtocol: class
{
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var wireFrame: LoginWireFrameProtocol? { get set }
    /**
    * Add here your methods for communication VIEW -> PRESENTER
    */
    func getAuthentiCode(code : String, phoneNumber: String)
    func register(phone_number: String, authenticode: String, password: String,navView: UINavigationController)
    func login(phoneNumber : String, password : String,navView: UINavigationController)
    
   
    func resetPassword(phone_number: String, authenticode: String, password: String,navView: UINavigationController)
    func loginOut(navView: UINavigationController)
    func registerModule(view: UINavigationController, title : String)
    func presentUserNameView(navView: UINavigationController)
    func comeBackLoginModule(view: UINavigationController)
    
    func comeBackUserNameView(view: UINavigationController ,name: String)
    func uploadImage(image : UIImage, name : String, navView: UINavigationController)
    func uploadImage(image : UIImage, name : String)
    func comeBackMineModule(view: UINavigationController)
    func getUserInfo()
}

protocol LoginInteractorOutputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> PRESENTER
    */
	
	func uploadImageFailure()
}

protocol LoginInteractorInputProtocol: class
{
    var presenter: LoginInteractorOutputProtocol? { get set }
    var APIDataManager: LoginAPIDataManagerInputProtocol? { get set }
    var localDatamanager: LoginLocalDataManagerInputProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> INTERACTOR
    */
    func getCode(code : String , phone : String)
    func register(phone_number: String, authenticode: String, password: String, completion: (success: Bool)->())
    func login(phoneNumber : String, password : String, completion: (success: Bool)->())
    
    func resetPassword(phone_number: String, authenticode: String, password: String,completion: (success: Bool)->())
    func loginOut(completion:(success: Bool)->())
    
    func uploadImage(image : UIImage, name : String, completion:(success: Bool)->())
    
    func getUserInfo(completion:(success: Bool)->())
    
    func deleteDataSource()
    
    func updateUserInfo(name : String, avatarUrl: String, completion:(success: Bool)->())

}

protocol LoginDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> DATAMANAGER
    */
}

protocol LoginAPIDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
    */
    func getAuthenticode(option : String , phoneNumber : String)
    func registerbyphone(phone_number: String, authenticode: String, password: String, completion: (success: Bool,
        userToken :String)->())
    func loginbyphone(phoneNumber : String, password : String, completion: (success: Bool,userToken :String)->())
    
    func loginOut(completion: (success: Bool,userToken :String)->())
    
    func resetPassword(phone_number: String, authenticode: String, password: String, completion: (success: Bool)->())
    
    func getUploadUrl(completion: (success: Bool, url : String)->())
    
    func postImage(url : String , imageUrl : String, completion:(success: Bool)->())
    
    func updateUserInfo(name :String, avatarUrl: String,completion:(success: Bool)->())
    
    func getUserInfo(completion:(success: Bool , nickName : String, avatarUrl : String)->())
}

protocol LoginLocalDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> LOCALDATAMANAGER
    */
    func persist(uerToken : String, phoneNumber : String)
    func invalidToken(userToken : String)
    func persistUserInfo(nickName : String , image : String)
    func deleteDataSource()
}
