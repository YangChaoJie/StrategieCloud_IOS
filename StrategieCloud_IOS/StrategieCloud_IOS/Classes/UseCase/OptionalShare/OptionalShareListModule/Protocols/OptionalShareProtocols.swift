//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation
import RealmSwift
protocol OptionalShareViewProtocol: class
{
    var presenter: OptionalSharePresenterProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> VIEW
    */
	func fetchLocalStockSuccess()
	func fetchServerStockSuccess(regularlyRefresh regular: Bool)
	func fetchServerStockFailure()
	func startRefresh()
	func orderRefresh()
}

protocol OptionalShareWireFrameProtocol: class
{
    static func presentOptionalShareModule() -> AnyObject
    /**
    * Add here your methods for communication PRESENTER -> WIREFRAME
    */

//	func presentStockDetailsModule(controller: UINavigationController)
//	func presentStockDetailsModule(selectedIndex index: Int, optionalShares: [OptionalShareItem], controller: UINavigationController)
}

protocol OptionalSharePresenterProtocol: class
{
    var view: OptionalShareViewProtocol? { get set }
    var interactor: OptionalShareInteractorInputProtocol? { get set }
    var wireFrame: OptionalShareWireFrameProtocol? { get set }
    /**
    * Add here your methods for communication VIEW -> PRESENTER
    */
	func didSelectOptionalShareItem(atIndexPath indexPath: NSIndexPath, controller: UINavigationController)
    func didTapOptionalHeaderView(index: Int, controller: UINavigationController)
    
    func numberOfItems(shareView section: Int) -> Int
    func setContentToView(shareView view: OptionalShareListDataSources, indexPath: NSIndexPath)
	func setOptionOrderType(type: OrderType)
	func fetchStockDataFromRealm()
	func regularlyUpdateStockDataFromServer()
	func updateLocalRealm()
    
    func setDataToHeaderView(view: OptionalShareHeaderDataSources)
    func setHeaderState(type:String)
}

protocol OptionalShareInteractorOutputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> PRESENTER
    */
	func returnStockDataFromRealm(results: [OptionalItem])
    func returnHeaderStockDataFormServer(results: [OptionalItem],isMsg:Bool)
//	func returnStockDataFromServer(results: [OptionalItem]?)
	func returnRegularlyStockFromServer(results: [OptionalItem]?)
	func returnStockDataFromServerFailure()
    func updateStockDataFromRealm(optionItems: [OptionalItem])
}

protocol OptionalShareInteractorInputProtocol: class
{
    var presenter: OptionalShareInteractorOutputProtocol? { get set }
    var APIDataManager: OptionalShareAPIDataManagerInputProtocol? { get set }
    var localDatamanager: OptionalShareLocalDataManagerInputProtocol? { get set }
    /**
    * Add here your methods for communication PRESENTER -> INTERACTOR
    */
	func updateLocalRealm(stocks: [OptionalItem])
	func fetchStockDataFromRealm()
	func checkLocalStockStatus()
	func regularlyUpdateStockFromServer(stockCodes: [String])
    
    func updateHeaderItems(completion: (success: Bool, data: AnyObject) -> ())
}

protocol OptionalShareDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> DATAMANAGER
    */
}

protocol OptionalShareAPIDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
    */
	//func searchStock(withText text: String, completion: (success: Bool, data: AnyObject?) -> ())
	
	func fetchStockDataFromServer(completion: (success: Bool, value: AnyObject?) -> ())
	func uploadStockToServer(stocksCode: [String], completion: (success: Bool) -> ())
	func updateStockDataFromServer(stocksCode: [String], completion: (success: Bool, value: AnyObject?) -> ())
    func updateHeaderStocks(completion: (success: Bool, data: AnyObject) -> ())
}

protocol OptionalShareLocalDataManagerInputProtocol: class
{
    /**
    * Add here your methods for communication INTERACTOR -> LOCALDATAMANAGER
    */
	func fetchStockDataFromRealm(completion: (stocks: Results<OptionalShareModel>) -> ())
	func fetchStockDataFromRealm(byUploadedStatus uploaded: Bool, completion: (results: Results<OptionalShareModel>) -> ())
	func realmSyncServerStocks(stocks: [OptionalItem]?)
}

protocol OptionalShareDataSources: class {
	func set(stockName name: String)
	func set(stockCode code: String)
  
}

protocol OptionalShareListDataSources: class {
    func set(stockName name: String)
    func set(stockCode code: String)
    func set(change change: String)
    func set(trend trend: Int)
	func set(changePct changePct: String, status: Int)
    func set(lastPrice price: String)
    func set(strategy isStrategy: Bool)
}

