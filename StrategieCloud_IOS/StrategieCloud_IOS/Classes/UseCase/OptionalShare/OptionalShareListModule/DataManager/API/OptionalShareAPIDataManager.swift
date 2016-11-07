//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation
import Alamofire

class OptionalShareAPIDataManager: OptionalShareAPIDataManagerInputProtocol
{
    init() {}
	
    func fetchStockDataFromServer(completion: (success: Bool, value: AnyObject?) -> ()) {
		Alamofire.request(Router.getChosenStock).responseJSON{ (response: Response<AnyObject, NSError>) in
			switch response.result {
            case .Success(let value):
                completion(success: true, value: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false, value: nil)
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
				print("上传股票====\(#function): \(value)")
				completion(success: true)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false)
			}
		}
	}

	func updateStockDataFromServer(stocksCode: [String], completion: (success: Bool, value: AnyObject?) -> ()) {
		let parameters = [
			"tickers": stocksCode
		]
		Alamofire.request(Router.updateStockShortInfo(parameters)).responseJSON{ (response: Response<AnyObject, NSError>) in
			switch response.result {
			case .Success(let value):
               // print("\(value)")
				completion(success: true, value: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false, value: nil)
			}
		}
	}
	
	
    func updateHeaderStocks(completion: (success: Bool, data: AnyObject) -> ()) {
        let tickets = ["sh000001","sz399001"]
        let parameters: [String: AnyObject] =
            [
                "tickers": tickets,
                ]
        Alamofire.request(Router.UpdateStocks(parameters))
            .responseCollectionData { (response: Response<[OptionalItem], BackendError>) in
                switch response.result {
                case .Success(let value):
                    completion(success: true, data: value)
                case .Failure(let error):
                    completion(success: false, data: "")
                    print("error: \(error)")
                }
        }
    }
    
    func deleteStock(tickets : [String], completion: (success: Bool, data: AnyObject) -> ()) {
        let parameters: [String: AnyObject] =
            [
                "tickers": tickets,
            ]
          Alamofire.request(Router.deleteTickets(parameters))
            .responseCollectionData { (response: Response<[OptionalItem], BackendError>) in
                switch response.result {
                case .Success(let value):
                print("删除股票--------\(value)=======")
                    completion(success: true, data: value)
                case .Failure(let error):
                    completion(success: false, data: "")
                    print("error: \(error)")
                }
        }
        
    }

}