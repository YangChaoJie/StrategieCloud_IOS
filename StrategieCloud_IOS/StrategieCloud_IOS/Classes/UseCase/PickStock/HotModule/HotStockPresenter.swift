//
//  HotStockPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/16.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class HotStockPresenter : HotStockPresenterProtocol{
    var view : HotStockViewProtocol?
    var repository: HotStockDataSource?
    var hotStockItem: [PickItem] = []
    init() {
        repository = HotStockRepository()
    }
    
    func numberOfItems(inSection section: Int) -> Int {
      return hotStockItem.count
    }
    
    func skipToDetailView(index: NSIndexPath) {
		var roughStocks: [RoughStock] = []
		for item in hotStockItem {
			roughStocks.append(RoughStock(name: item.stockName, code: item.stockCode))
		}
        self.view?.skipToDetailView(roughStocks, index: index.row)
    }
    
    func setContentToView(cell: HotDataSources, indexPath: NSIndexPath) {
        let item = self.hotStockItem[indexPath.row]
        let optionalShare = repository?.isOptionalShare(stockCode: item.stockCode)
        self.hotStockItem[indexPath.row].setOptionalShare(optionalShare!)
        
        let newItem = self.hotStockItem[indexPath.row]
        cell.set(stockCode: newItem.stockCode)
        cell.set(stockName: newItem.stockName)
        cell.set(feature: newItem.feature)
        cell.set(coordinate: newItem.coordinate)
        cell.setAddBtnEnable(!newItem.optionalShare)
    }
    
    func addStock(withName name: String, code: String) {
        repository?.addStockToLocalDatabase(name: name, code: code, completion: {
            self.view?.notifyFetchSuccess()
        })
    }
    
    func glamourstock(option:String)  {
        repository?.glamourStock(option, completion: { (success, data) in
            if success {
                self.hotStockItem = data as! [PickItem]
                self.view?.notifyFetchSuccess()
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
}