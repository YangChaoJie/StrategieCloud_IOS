//
//  RealmHelper.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmHelper {

	class var instance: RealmHelper {
		struct Static {
			static let sharedInstance: RealmHelper = RealmHelper()
		}
		return Static.sharedInstance
	}
	
	init() {
	
	}
	
	public func addStockToRealm(name: String, code: String, uploaded: Bool = false) {
	
		let realm = try! Realm()
        realm.configuration.deleteRealmIfMigrationNeeded
		let objects = realm.objects(OptionalShareModel)
		var newID = Int(1)
		if objects.count > 0 {
			if let object = objects.sorted("id", ascending: false).first {
				newID = object.id + 1
			}
		}
		
		let stock = OptionalShareModel()
		stock.name = name
		stock.code = code
		stock.id = newID
		stock.position = 1
		if uploaded {
			stock.uploaded = true
		}
		
		try! realm.write({
			for i in 0 ..< objects.count {
				let savedStock = objects[i]
				savedStock.position += 1
			}
            //new add by 10.14
            let predicate = NSPredicate(format: "code = %@", code)
            let object = realm.objects(OptionalShareModel).filter(predicate)
            if  object.isEmpty {
                realm.add(stock)
            }
		})
	}
    
    func addStock(optionItem : OptionalItem){
        let realm = try! Realm()
        let objects = realm.objects(OptionalShareModel)
        var newID = Int(1)
        if objects.count > 0 {
            if let object = objects.sorted("id", ascending: false).first {
                newID = object.id + 1
            }
        }
        let stock = OptionalShareModel()
        stock.name = optionItem.stockName
        stock.code = optionItem.stockCode
        stock.change = optionItem.change
        stock.increase = optionItem.changePct
        stock.price = optionItem.lastPrice
        stock.status = optionItem.status
        stock.trend = optionItem.trend
        stock.uploaded = true
        stock.id = newID
        stock.position = 1
         if  optionItem.isStrategy != nil {
           stock.isStrategy = optionItem.isStrategy!
        }
        
        try! realm.write({
            for i in 0 ..< objects.count {
                let savedStock = objects[i]
                savedStock.position += 1
            }
            realm.add(stock)
        })
    }
	
	public func isOptionalShare(witCode code: String) -> Bool {
		let realm = try! Realm()
		let predicate = NSPredicate(format: "code = %@", code)
		let object = realm.objects(OptionalShareModel).filter(predicate)

		return (object.isEmpty ? false : true)
	}
	
	public func addStockToSearchHistory(name: String, code: String) {
		let realm = try! Realm()
        let predicate = NSPredicate(format: "name = %@", name)
        let object = realm.objects(StockSearchHistoryModel).filter(predicate)
        if object.isEmpty == true {
            let stock = StockSearchHistoryModel()
            let objects = realm.objects(StockSearchHistoryModel)
            stock.name = name
            stock.code = code
            stock.position = 1
            
            try! realm.write({
                for i in 0 ..< objects.count {
                    let savedStock = objects[i]
                    savedStock.position += 1
                }
                realm.add(stock)
            })
        }
	}
    
    func fetchStock() -> Results<(OptionalShareModel)> {
        let realm = try! Realm()
        print("数据库地址是===\(realm.configuration.fileURL)")
        let results = realm.objects(OptionalShareModel).sorted("position", ascending: true)
		return results
    }
    
    func fetchStockByStatus(status : Bool) -> Results<(OptionalShareModel)> {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "uploaded = %@", status)
        return realm.objects(OptionalShareModel).filter(predicate).sorted("position", ascending: true)
    }
	
	func fetchStockSearchHistory() -> Results<(StockSearchHistoryModel)> {
		let realm = try! Realm()
		return realm.objects(StockSearchHistoryModel).sorted("position", ascending: true)
	}
    
    func deleteStockSearchHistory(){
        let realm = try! Realm()
         let object = realm.objects(StockSearchHistoryModel)
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func updateStockState(name : String) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "code = %@", name)
        for optionalShareModel in realm.objects(OptionalShareModel).filter(predicate){
            try! realm.write{
                optionalShareModel.uploaded = true
            }
        }
    }
	
	func updateRealmStock(fromStocks stocks: [OptionalItem]) {
		let realm = try! Realm()
		for stock in stocks {
			let predicate = NSPredicate(format: "code = %@", stock.stockCode)
			let queryModels = realm.objects(OptionalShareModel).filter(predicate)
			if queryModels.count > 0 {
				for model in queryModels {
					try! realm.write({ 
						model.change = stock.change
						model.increase = stock.changePct
						model.trend = stock.trend
						model.status = stock.status
						model.price = stock.lastPrice
						model.uploaded = true
                        if  stock.isStrategy != nil {
                            model.isStrategy = stock.isStrategy!
                        }
					})
				}
			} else {
				addStock(stock)
			}
		}
	}
    
    func updateStock(optionItem : OptionalItem) {
        let realm = try! Realm()
        var isUpdate : Bool = false
        let predicate = NSPredicate(format: "code = %@", optionItem.stockCode)
        for optionalShareModel in realm.objects(OptionalShareModel).filter(predicate){
            isUpdate = true
            try! realm.write{
                optionalShareModel.name = optionItem.stockName
                optionalShareModel.code = optionItem.stockCode
                optionalShareModel.change = optionItem.change
                optionalShareModel.increase = optionItem.changePct
                optionalShareModel.trend = optionItem.trend
                optionalShareModel.status = optionItem.status
                optionalShareModel.price = optionItem.lastPrice
                optionalShareModel.uploaded = true
                if  optionItem.isStrategy != nil {
                   optionalShareModel.isStrategy = optionItem.isStrategy!
                }

               // optionalShareModel.isStrategy = optionItem.isStrategy
            }
        }
        
        if isUpdate == false{
            addStock(optionItem)
        }
    }
    
    func deleteTableItems(tableItems: [OptionalShareModel]) {
        let realm = try! Realm()
        try! realm.write {
            for item in tableItems {
               // let tableItem = item
                realm.delete(item)
            }
        }
    }
    
    func deleteAllStock() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
       }
    }
    
    func updatePosition(optionItem : OptionalShareModel,index: Int){
        let realm = try! Realm()
             try! realm.write{
              optionItem.position = index+1
      }
    }
    
    func stockEmpty() -> Bool {
        let realm = try! Realm()
        let object = realm.objects(OptionalShareModel)
        if object.count > 0 {
            return false
        }
        return true
    }
}