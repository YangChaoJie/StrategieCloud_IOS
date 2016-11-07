//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

class MineWireFrame: MineWireFrameProtocol
{
    //在这个地方改输入口
    class func presentMineModule(viewController : MineViewProtocol) -> AnyObject
    {
        // Generating module components
        let view: MineViewProtocol = viewController
        let presenter: protocol<MinePresenterProtocol, MineInteractorOutputProtocol> = MinePresenter()
        let interactor: MineInteractorInputProtocol = MineInteractor()
        let APIDataManager: MineAPIDataManagerInputProtocol = MineAPIDataManager()
        let localDataManager: MineLocalDataManagerInputProtocol = MineLocalDataManager()
        let wireFrame: MineWireFrameProtocol = MineWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
        return view
    }
	
	class func enterLoginModule(controller: UINavigationController) {
		controller.pushViewController(LoginView(), animated: true)
	}
   
    
    func presentLoginModule(controller: UINavigationController) {
        controller.pushViewController(LoginView(), animated: true)
    }
    
    func presentUserInfoModule(controller: UINavigationController){
        LoginWireFrame.presentUserInfoModule(fromView: controller)
    }
  
}