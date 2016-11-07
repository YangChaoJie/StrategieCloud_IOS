//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

protocol MineViewProtocol: class
{
    var presenter: MinePresenterProtocol? { get set }
    func setUserInfo(name: String, url: String)
    /**
    * Add here your methods for communication PRESENTER -> VIEW
    */
}

protocol MineWireFrameProtocol: class
{
    static  func presentMineModule(viewController : MineViewProtocol) -> AnyObject

    /**
    * Add here your methods for communication PRESENTER -> WIREFRAME
    */
    
     func presentLoginModule(controller: UINavigationController)
    
    func presentUserInfoModule(controller: UINavigationController)
    
}

protocol MinePresenterProtocol: class
{
    var view: MineViewProtocol? { get set }
    var interactor: MineInteractorInputProtocol? { get set }
    var wireFrame: MineWireFrameProtocol? { get set }
    /**
    * Add here your methods for communication VIEW -> PRESENTER
    */
    
    func presentLoginModule(controller: UINavigationController)

//	func setHeaderViewContent(headerView: UserLoginView)
    func getUserInfo(headerView: UserLoginView)
	
	func setNickNametoHeaderView(headerView: UserLoginViewDataSource)
	func getSections() -> Int
	func numberOfRowsInSection(section: Int) -> Int
	func setCellContent(cell: MineViewCellDataSource, indexPath: NSIndexPath)
	func getVersionItemIndexPath() -> (section: Int, row: Int)
}

protocol MineInteractorOutputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> PRESENTER
    */
}

protocol MineInteractorInputProtocol: class
{
    var presenter: MineInteractorOutputProtocol? { get set }
    var APIDataManager: MineAPIDataManagerInputProtocol? { get set }
    var localDatamanager: MineLocalDataManagerInputProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> INTERACTOR
    */
    func getUserInfo(completion:(success: Bool , nickName : String, avatarUrl : String)->())
   
}

protocol MineDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> DATAMANAGER
    */
}

protocol MineAPIDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
    */
    func getUserInfo(completion:(success: Bool , nickName : String, avatarUrl : String)->())
   
}

protocol MineLocalDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> LOCALDATAMANAGER
    */
}

protocol UserLoginViewDatasource: class {
	func setUserName(name: String)
}
