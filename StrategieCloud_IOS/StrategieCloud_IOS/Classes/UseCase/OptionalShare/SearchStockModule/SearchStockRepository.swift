//
//  SearchStockRepository.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class SearchStockRepository: SearchStockDataSource {
    
	// API
	func searchStock(withText text: String, completion: (success: Bool, data: AnyObject?) -> ()) {
                 let parameters = [
                    "ticker": text
                ]
		Alamofire.request(Router.newSearchTicket(parameters)).responseJSON { (response: Response<AnyObject, NSError>) in
			switch response.result {
			case .Success(let value):
               // print("-------\(value)")
				completion(success: true, data: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false, data: nil)
			}
		}
	}
    
    func uploadStockToServer(stocksCode: [String], completion: (success: Bool) -> ()) {
        let parameters = [
            "tickers": stocksCode
        ]
        Alamofire.request(Router.addChosenStock(parameters)).responseJSON { (response: Response<AnyObject, NSError>) in
            switch response.result {
            case .Success(let value):
                print("serach===\(#function): \(value)")
                completion(success: true)
            case .Failure(let error):
                print("\(#function) error: \(error)")
                completion(success: false)
            }
        }
    }
    
    func gethotdiagnosedstock(completion: (success: Bool, data: AnyObject?) -> ()){
        Alamofire.request(Router.gethotdiagnosedstock).responseJSON { (response: Response<AnyObject, NSError>) in
            switch response.result {
            case .Success(let value):
                // print("-------\(value)")
                completion(success: true, data: value)
            case .Failure(let error):
                print("\(#function) error: \(error)")
                completion(success: false, data: nil)
            }
        }
    }
    

	
	// Local
	func addStockToLocalDatabase(name name: String, code: String, completion: () -> ()) {
		RealmHelper.instance.addStockToRealm(name, code: code,uploaded:true)
		completion()
	}
	
	func isOptionalShare(stockCode code: String) -> Bool {
		return RealmHelper.instance.isOptionalShare(witCode: code)
	}
	
	func addStockToSearchHistory(name name: String, code: String) {
		RealmHelper.instance.addStockToSearchHistory(name, code: code)
	}
	
	func fetchSearchHistory(completion: (results: Results<(StockSearchHistoryModel)>) -> ()) {
		completion(results: RealmHelper.instance.fetchStockSearchHistory())
	}
    
    func fetchStock(completion: (results: Results<(OptionalShareModel)>) -> ()) {
        
        completion(results: RealmHelper.instance.fetchStock())
    }
    
    func deleteSearchHistory(){
        RealmHelper.instance.deleteStockSearchHistory()
    }
    
   
    
}