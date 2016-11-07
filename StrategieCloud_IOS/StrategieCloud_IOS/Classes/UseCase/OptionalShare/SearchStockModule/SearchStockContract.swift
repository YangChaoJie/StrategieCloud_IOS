//
//  SearchStockContract.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import RealmSwift

protocol SearchStockPresenterProtocol: class {
	
	var view: SearchStockViewProtocol? { get set }
	// View -> Presenter
	
	func searchStock(withText text: String)
	func searchHistoryStock()
	func setContentToView(cell: SearchViewCellDataSource, indexPath: NSIndexPath)
	func numberOfItems(inSection section:Int) -> Int
    
    func gethotdiagnosedstock()
	
	func addStock(withName name: String, code: String)
	func addStockToSearchHistory(fromIndex index: NSIndexPath)
	func historyStockEmpty() -> Bool
    func deleteStockSearchHistory()
    //func uploadStock()
	
    func enterStockDetailPage(withIndex index: NSIndexPath, inView view: UINavigationController,viewTag: Int)
}

protocol SearchStockViewProtocol: class {
	
	// Presenter -> View
	
	func notifyFetchSuccess()
	func notifyFetchFailure()
}

protocol SearchStockDataSource: class {
	
	// Presenter -> Respository
	
	// API
	func searchStock(withText text: String, completion: (success: Bool, data: AnyObject?) -> ())
    func uploadStockToServer(stocksCode: [String], completion: (success: Bool) -> ())
    func gethotdiagnosedstock(completion: (success: Bool, data: AnyObject?) -> ())
   
	
	// Local Data
	func addStockToLocalDatabase(name name: String, code: String, completion: () -> ())
	func isOptionalShare(stockCode code: String) -> Bool
	func addStockToSearchHistory(name name: String, code: String)
	func fetchSearchHistory(completion: (results: Results<(StockSearchHistoryModel)>) -> ())
    func fetchStock(completion: (results: Results<(OptionalShareModel)>) -> ())
    func deleteSearchHistory()
    //func updateStockState(name : String)
}