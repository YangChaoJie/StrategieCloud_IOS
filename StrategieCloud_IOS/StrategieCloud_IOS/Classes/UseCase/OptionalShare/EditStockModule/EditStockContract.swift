//
//  EditStockContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/8.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import RealmSwift

protocol EditStockViewProtocol:class {
    // Presenter -> View
    func notifyFetchSuccess()
    func notifyFetchFailure()
	
	func notifyMove(fromIndex index1: NSIndexPath, toIndex index2: NSIndexPath)
    func deleteRowsAtIndexPaths(indexPath: [NSIndexPath])
}


protocol EditStockPresenterProtocol:class {
    
    var view: EditStockViewProtocol? { get set }
    // View -> Presenter
    func numberOfItems(shareView section: Int) -> Int
    func setContentToView(shareView view: OptionalDataSources, indexPath: NSIndexPath)
    func getStock()
    func delete(indexPaths :[NSIndexPath]?)
    func savePosition()
    func findIndexPathByCode(code: String) -> Int
	func moveItem(fromIndex index1: NSIndexPath, toIndex index2: NSIndexPath)
}

protocol EditStockDataSource: class {
    // Presenter -> Respository
    func deleteStockFromNetWork(tickets : [String], completion: (success: Bool) -> ())
    func deleteTableItemInDataBase(tableItems: [OptionalShareModel])
    
    func fetchStockRepository(completion: (results: Results<(OptionalShareModel)>) -> ())
    func updatePosition(optionItem : OptionalShareModel,index: Int)
    
}
@objc
protocol OptionalDataSources: class {
    func set(stockName name: String)
    func set(stockCode code: String)
    optional func set(change change: String)
    optional func set(trend trend: Int)
    optional func set(status status: Int)
    optional func set(changePct changePct: String)
    optional func set(lastPrice price: String)
}
