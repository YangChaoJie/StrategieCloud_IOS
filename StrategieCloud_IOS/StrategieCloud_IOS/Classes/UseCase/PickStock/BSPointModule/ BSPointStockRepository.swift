//
//  HotStockRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/16.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class BSPointStockRepository : BSPointStockDataSource{
    //API
    func glamourStock(option:String,completion: (success: Bool, data: AnyObject?) -> ()) {
        print("请求的参数-======\(option)")
        Alamofire.request(Router.glamourStock(option)).responseJSON{ (response) in
            switch response.result{
            case .Success(let value):
             //print("得到的数据是\(value)")
            completion(success: true, data: value)
            case .Failure(let error):
            print("\(#function) error: \(error)")
            completion(success: false, data: nil)
            }
        }
    }
    
    // Local
    func addStockToLocalDatabase(name name: String, code: String, completion: () -> ()) {
        RealmHelper.instance.addStockToRealm(name, code: code)
        completion()
    }
    
    func isOptionalShare(stockCode code: String) -> Bool {
        return RealmHelper.instance.isOptionalShare(witCode: code)
    }
}