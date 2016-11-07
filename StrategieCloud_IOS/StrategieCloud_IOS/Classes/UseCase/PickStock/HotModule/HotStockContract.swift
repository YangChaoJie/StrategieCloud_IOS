//
//  HotStockContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/16.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import RealmSwift
protocol HotStockViewProtocol:class {
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func skipToDetailView(roughStocks: [RoughStock],index: Int)
}


protocol HotStockPresenterProtocol: class {
    
    weak var view: HotStockViewProtocol? { get set }
    
    func numberOfItems(inSection section:Int) -> Int
    func addStock(withName name: String, code: String)
    func setContentToView(cell: HotDataSources, indexPath: NSIndexPath)
    func glamourstock(option:String)
    func skipToDetailView(index: NSIndexPath)
}

protocol  HotStockDataSource: class {
    
    // Presenter -> Respository
    
    // API
    func glamourStock(option:String,completion: (success: Bool, data: AnyObject?) -> ())
    
    // Local Data
    func addStockToLocalDatabase(name name: String, code: String, completion: () -> ())
    func isOptionalShare(stockCode code: String) -> Bool
}

protocol HotDataSources {
    func set(stockName name: String)
    func set(stockCode code: String)
    func set(coordinate coordinate: String)
    func set(feature feature: [Int])
    func setAddBtnEnable(enable: Bool)
}