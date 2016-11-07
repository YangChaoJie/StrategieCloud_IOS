//
//  SearchStockPresenter.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class SearchStockPresenter: SearchStockPresenterProtocol {

	weak var view: SearchStockViewProtocol?
	var repository: SearchStockDataSource?
	
	var stockSearchItems: [StockSearchItem] = []
	
	init() {
		repository = SearchStockRepository()
	}

	// MARK: - SearchStockPresenterProtocol
	
	func searchHistoryStock() {
        self.stockSearchItems.removeAll()
        var array : [StockSearchItem] = []
		repository?.fetchSearchHistory({ (results) in
         
			for i in 0 ..< results.count {
				let result = results[i]
				let stockSearchItem = StockSearchItem(name: result.name, code: result.code)
				array.append(stockSearchItem)
			}
            self.stockSearchItems = array
			self.view?.notifyFetchSuccess()
		})
	}
	
	func historyStockEmpty() -> Bool {
		return stockSearchItems.isEmpty
	}
	
	func addStockToSearchHistory(fromIndex index: NSIndexPath) {
		let item = self.stockSearchItems[index.row]
		repository?.addStockToSearchHistory(name: item.name, code: item.code)
	}
	
	func searchStock(withText text: String) {
		repository?.searchStock(withText: text, completion: { (success, data) in
			if success {
				var optionalShareItems: [StockSearchItem] = []
				if let _data = data!.objectForKey("data") as? [[String]] {
					for index in 0 ..< _data.count {
						let optionalShareItem = StockSearchItem(name: _data[index][1], code: _data[index][0])
						optionalShareItems.append(optionalShareItem)
					}
				}
				self.stockSearchItems = optionalShareItems
				self.view?.notifyFetchSuccess()
			} else {
				self.view?.notifyFetchFailure()
			}
		})
	}
    
    // new add by 10.27
    func gethotdiagnosedstock() {
        repository?.gethotdiagnosedstock({ (success, data) in
            if success {
                var optionalShareItems: [StockSearchItem] = []
                if let _data = data!.objectForKey("data") as? [[String]] {
                    for index in 0 ..< _data.count {
                        let optionalShareItem = StockSearchItem(name: _data[index][1], code: _data[index][0])
                        optionalShareItems.append(optionalShareItem)
                    }
                }
                self.stockSearchItems = optionalShareItems
                self.view?.notifyFetchSuccess()
            } else {
                self.view?.notifyFetchFailure()
            }
        })
    }
	
    func enterStockDetailPage(withIndex index: NSIndexPath, inView view: UINavigationController,viewTag: Int) {
        let item = self.stockSearchItems[index.row]
        if viewTag == 2{
            let strategyListVC = DiagnosisDetailView()
            strategyListVC.stockCode = item.code
            strategyListVC.title = "“" + item.name + "”" + "诊股"
            let nav = MainNavigationController(rootViewController: strategyListVC)
            //skipView.navigationController?.presentViewController(nav, animated: true, completion: nil)
            view.presentViewController(nav, animated: true, completion: nil)
        }else{
            var roughStocks: [RoughStock] = []
            roughStocks.append(RoughStock(name: item.name, code: item.code))
            let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
            vc.roughStocks = roughStocks
            view.pushViewController(vc, animated: true)
        }
	}
    
    func deleteStockSearchHistory(){
        repository?.deleteSearchHistory()
        self.stockSearchItems.removeAll()
        self.view?.notifyFetchSuccess()
    }
	
	func setContentToView(cell: SearchViewCellDataSource, indexPath: NSIndexPath) {
		let item = self.stockSearchItems[indexPath.row]
		let optionalShare = repository?.isOptionalShare(stockCode: item.code)
		self.stockSearchItems[indexPath.row].setOptionalShare(optionalShare!)
		let newItem = self.stockSearchItems[indexPath.row]
		cell.set(stockName: newItem.name)
		cell.set(stockCode: newItem.code)
		cell.setAddBtnEnable(!newItem.optionalShare)
	}
	
	func numberOfItems(inSection section: Int) -> Int {
		return self.stockSearchItems.count
	}
	
	func addStock(withName name: String, code: String) {
        uploadStockToServer(code, name: name)
	}
    
    func uploadStockToServer(code: String, name: String) {
        var array : [String] = []
        array.append(code)
        repository?.uploadStockToServer(array, completion: { (success) in
            if success {
                self.repository?.addStockToLocalDatabase(name: name, code: code, completion: {
                    self.view?.notifyFetchSuccess()
                })
            }
        })
        
    }
}