//
//  HotStockPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/16.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class BSPointStockPresenter : BSPointStockPresenterProtocol{
    var view : BSPointStockViewProtocol?
    var repository: BSPointStockDataSource?
    var BsItem: [BsPointItem] = []
    init() {
        repository = BSPointStockRepository()
    }
    
    func numberOfItems(inSection section: Int) -> Int {
      return BsItem.count
    }
    
    func skipToDetailView(index: NSIndexPath) {
		var roughStocks: [RoughStock] = []
		for item in  BsItem {
			roughStocks.append(RoughStock(name: item.stockName, code: item.stockCode))
		}
        self.view?.skipToDetailView(roughStocks, index: index.row)
    }
    
    func setContentToView(cell: BSPointDataSources, indexPath: NSIndexPath) {
        let item = self.BsItem[indexPath.row]
        let optionalShare = repository?.isOptionalShare(stockCode: item.stockCode )
        self.BsItem[indexPath.row].setOptionalShare(optionalShare!)
        
        let newItem = self.BsItem[indexPath.row]
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
        var items: [BsPointItem] = []
        repository?.glamourStock(option, completion: { (success, data) in
            if success {
                let status = data!.valueForKeyPath("status") as! String
                if status == "success" {
                    let result = data!.valueForKeyPath("data") as! [AnyObject]
                    if result.count > 0 {
                    for i in 0...result.count-1 {
                        let item = BsPointItem.init(data: result[i] as! [AnyObject])
                        items.append(item)
                        }
                    }
                    self.BsItem = items
                    self.view?.notifyFetchSuccess()
                }
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
}