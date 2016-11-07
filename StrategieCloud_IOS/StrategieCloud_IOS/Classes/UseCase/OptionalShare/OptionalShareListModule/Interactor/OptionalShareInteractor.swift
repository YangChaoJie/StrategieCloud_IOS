//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation
import RealmSwift
class OptionalShareInteractor: OptionalShareInteractorInputProtocol
{
    weak var presenter: OptionalShareInteractorOutputProtocol?
    var APIDataManager: OptionalShareAPIDataManagerInputProtocol?
    var localDatamanager: OptionalShareLocalDataManagerInputProtocol?
    init() {}
	
	func fetchStockDataFromRealm() {
		localDatamanager?.fetchStockDataFromRealm({ (stocks) in
			let optionalItems = stocks.map({
				OptionalItem(stockName: $0.name,
					stockCode: $0.code,
					change: $0.change,
					changePct: $0.increase,
					trend: $0.trend,
					lastPrice: $0.price,
					status: $0.status,
                    isStrategy: $0.isStrategy,
					position: $0.position)
			})
			self.presenter?.returnStockDataFromRealm(optionalItems)
		})
	}
	
	func checkLocalStockStatus() {
		self.localDatamanager?.fetchStockDataFromRealm(byUploadedStatus: false, completion: { (results) in
			let notUploadedStocks = results.map { $0.code }
			if notUploadedStocks.count > 0 {
				self.APIDataManager?.uploadStockToServer(notUploadedStocks, completion: { (success) in
					if success {
						self.fetchStockDataFromServer()
					}
				})
			} else {
				self.fetchStockDataFromServer()
			}
		})
	}

	func regularlyUpdateStockFromServer(stockCodes: [String]) {
		APIDataManager?.updateStockDataFromServer(stockCodes, completion: { (success, stocks) in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { 
                if let items = stocks {
                    if success {
                        let optionShareItem = self.segmentDataToOptionItem(items)
                        if let optionStocks = optionShareItem["optionItem"] {
                            let optionItems = self.convertToOptionItem( optionStocks)
                            let headItems = self.convertToOptionItem(optionShareItem["headItem"]!)
                            
                            self.localDatamanager?.realmSyncServerStocks(optionItems)
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                self.presenter?.returnHeaderStockDataFormServer(headItems,isMsg: self.getAlertState(stocks!)[0])
                                self.presenter?.returnRegularlyStockFromServer(optionItems)
                            })
                        }
                    } else {
                        self.presenter?.returnStockDataFromServerFailure()
                    }
                }
            })
		})
	}
	
	func updateLocalRealm(stocks: [OptionalItem]) {
		self.localDatamanager?.realmSyncServerStocks(stocks)
	}

	private func fetchStockDataFromServer() {
		APIDataManager?.fetchStockDataFromServer({ [weak self] (success, value) in
			if success {
                //new add
                let optionShareItem = self?.segmentDataToOptionItem(value!)
                if optionShareItem?.keys.count > 0 {
                    let optionItems = self!.convertToOptionItem(optionShareItem!["optionItem"]!)
                    let headItems = self!.convertToOptionItem(optionShareItem!["headItem"]!)
                    self?.presenter?.returnHeaderStockDataFormServer(headItems,isMsg:self!.getAlertState(value!)[0])
                    self!.localDatamanager?.realmSyncServerStocks(optionItems)
                }
				self!.localDatamanager?.fetchStockDataFromRealm({ (stocks) in
					let optionalItems = stocks.map({
						OptionalItem(stockName: $0.name,
							stockCode: $0.code,
							change: $0.change,
							changePct: $0.increase,
							trend: $0.trend,
							lastPrice: $0.price,
							status: $0.status,
                            isStrategy: $0.isStrategy,
							position: $0.position)
					})
					self!.presenter?.updateStockDataFromRealm(optionalItems)
				})
			} else {
				self!.presenter?.returnStockDataFromServerFailure()
			}
		})
	}
    //new add
    func updateHeaderItems(completion: (success: Bool, data: AnyObject) -> ()) {
        APIDataManager?.updateHeaderStocks({ (success, data) in
            if success {
               completion(success: true, data: data)
            }else {
               completion(success: false,data: "")
            }
        })
    }
    
    
    //new add
    func segmentDataToOptionItem(value: AnyObject)->[String:[OptionShareItem]] {
        var dic : [String:[OptionShareItem]] = [:]
        var array: [OptionShareItem] = []
        var headItems:[OptionShareItem] = []
        let status = value.valueForKeyPath("status") as! String
      //  print("======\(value)")
        if status == "success"  {
            let data = value.valueForKeyPath("data") as! NSDictionary
            let item = OptionalShareItem.init(representation: data)
            //print("没有数据时为======\(item?.stocks)")
            for item in (item?.stocks)! {
                let optionItem = OptionShareItem.init(representation: item)
                array.append(optionItem!)
            }
            
            dic["optionItem"] = array
            
            for item in (item?.head)! {
                let optionItem = OptionShareItem.init(representation: item)
                headItems.append(optionItem!)
            }
            dic ["headItem"] = headItems
        }
        return dic
    }
    
  //new ADD
    func getAlertState(value: AnyObject) ->[Bool]{
        var stateArray: [Bool] = []
        let status = value.valueForKeyPath("status") as! String
        if status == "success"  {
            let data = value.valueForKeyPath("data") as! NSDictionary
            //print("服务器的数据是===\(data)")
            let item = OptionalShareItem.init(representation: data)
            //print("服务器的数据是===\(item?.isMsg)")
            stateArray.append((item?.isMsg)!)
        }
        return stateArray
    }
    
    func convertToOptionItem(stocks: [OptionShareItem])->[OptionalItem] {
        var optionItems: [OptionalItem] = []
        for stock in stocks {
            let optionalItem = OptionalItem(stockName: stock.stockName,
                                            stockCode: stock.stockCode,
                                            change: stock.change,
                                            changePct: stock.changePct,
                                            trend:  stock.trend,
                                            lastPrice:  stock.lastPrice,
                                            status: stock.status,
                                            isStrategy: stock.isStrategy,
                                            position: stock.position
            )
            optionItems.append(optionalItem)
        }
        return optionItems
    }
    
}
