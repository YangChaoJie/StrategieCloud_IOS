//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

class LoginWireFrame: LoginWireFrameProtocol
{
    class func presentUserInfoModule(fromView nview: UINavigationController)
    {
        let view: LoginViewProtocol = UserInfoView()
        let presenter: protocol<LoginPresenterProtocol, LoginInteractorOutputProtocol> = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let APIDataManager: LoginAPIDataManagerInputProtocol = LoginAPIDataManager()
        let localDataManager: LoginLocalDataManagerInputProtocol = LoginLocalDataManager()
        let wireFrame: LoginWireFrameProtocol = LoginWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
        
        nview.pushViewController(view as! UIViewController, animated: true)
    }
    
    func LoginViewModule(navView: UINavigationController) {
       navView.popViewControllerAnimated(true)
    }
    
    func UserNameViewModule(navView: UINavigationController) {
        navView.popViewControllerAnimated(true)
    }
    
    func MineViewModule(navView : UINavigationController) {
        navView.popToRootViewControllerAnimated(true)
    }

    class func registerViewModule(title: String)-> UIViewController {
        let view: LoginViewProtocol  = RegisterViewController()
            //RegisterViewController()
        let presenter: protocol<LoginPresenterProtocol, LoginInteractorOutputProtocol> = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let APIDataManager: LoginAPIDataManagerInputProtocol = LoginAPIDataManager()
        let localDataManager: LoginLocalDataManagerInputProtocol = LoginLocalDataManager()
        let wireFrame: LoginWireFrameProtocol = LoginWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
        (view as! UIViewController).title = title
        return view as! UIViewController
    }
    
    func presentUserNameView(navView: UINavigationController) {
        let view: LoginViewProtocol  = UserNameView()
        let presenter: protocol<LoginPresenterProtocol, LoginInteractorOutputProtocol> = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let APIDataManager: LoginAPIDataManagerInputProtocol = LoginAPIDataManager()
        let localDataManager: LoginLocalDataManagerInputProtocol = LoginLocalDataManager()
        let wireFrame: LoginWireFrameProtocol = LoginWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
        
        navView.pushViewController(view as! UIViewController, animated: true)
    }
    
    func presentUserSetInfoView(navView: UINavigationController) {
        let view: LoginViewProtocol  = UserSetInfoView()
        let presenter: protocol<LoginPresenterProtocol, LoginInteractorOutputProtocol> = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let APIDataManager: LoginAPIDataManagerInputProtocol = LoginAPIDataManager()
        let localDataManager: LoginLocalDataManagerInputProtocol = LoginLocalDataManager()
        let wireFrame: LoginWireFrameProtocol = LoginWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
        navView.pushViewController(view as! UIViewController, animated: true)
    }
    
    
}