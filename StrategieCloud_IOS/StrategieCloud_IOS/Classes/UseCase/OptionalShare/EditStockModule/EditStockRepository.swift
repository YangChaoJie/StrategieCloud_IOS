//
//  EditStockRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/8.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
class EditStockRepository: EditStockDataSource{
    
    //API
    func deleteStockFromNetWork(tickets : [String], completion: (success: Bool) -> ()) {
        let parameters: [String: AnyObject] =
            [
                "tickers": tickets,
            ]
        
        print("parameters-----> \(parameters)")
        
        Alamofire.request(Router.deleteTickets(parameters))
            .responseCollectionData { (response: Response<[OptionalItem], BackendError>) in
                switch response.result {
                case .Success(let value):
                    print("删除股票--------\(value)=======")
                    completion(success: true)
                case .Failure(let error):
                    completion(success: false)
                    print("删除股票错误--------\(error)=======")
                    print("error: \(error)")
                }
        }
        
    }
    
    // MARK: --local
    func deleteTableItemInDataBase(tableItems: [OptionalShareModel]) {
        RealmHelper.instance.deleteTableItems(tableItems)
    }
    
    func fetchStockRepository(completion: (results: Results<(OptionalShareModel)>) -> ()) {
        completion(results: RealmHelper.instance.fetchStock())
    }

    func updatePosition(optionItem : OptionalShareModel,index: Int) {
        RealmHelper.instance.updatePosition(optionItem, index: index)
    }
}