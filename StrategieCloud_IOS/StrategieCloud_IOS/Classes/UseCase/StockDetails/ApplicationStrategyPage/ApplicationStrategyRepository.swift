//
//  ApplicationStrategyRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class ApplicationStrategyRepository :ApplicationStrategyRespositoryProtocol{
    func getStrategyWinInfo(option:String,completion: (success: Bool, data: AnyObject?) -> ()) {
        Alamofire.request(Router.getStrategyWinInfo(option)).responseCollectionData { (response:Response<[StrategyStockItem], BackendError>) in
            switch response.result{
            case .Success(let value):
                completion(success: true, data: value)
            case .Failure(let error):
                print("\(#function) error: \(error)")
                completion(success: false, data: nil)
            }
        }

    }
    
    func  settingStrategy(stocksCode: String,aowId: Int,completion: (success: Bool) -> ()) {
        let s = String(aowId)
        let parameters: [String: AnyObject] = [
            "ticker": stocksCode,
            "aow_id": s
        ]
        
        Alamofire.request(Router.aowSettingStrategy(parameters)).responseJSON { (response) in
            switch response.result{
            case .Success(let value):
                print("===\(value)")
                completion(success: true)
            case .Failure(let error):
                print("\(#function) error: \(error)")
                completion(success: false)
            }
        }
    }
    
    func getStrategyAoeDetail(aowId:Int,completion: (success: Bool, data: StrategyChartItem?) -> ()) {
        Alamofire.request(Router.getStrategyAowDetail(String(aowId))).responseObject {(response: Response<StrategyChartItem, BackendError>) in
            switch response.result{
            case .Success(let value):
                print("===\(value)")
                completion(success: true, data: value)
            case .Failure(let error):
                print("\(#function) error: \(error)")
                completion(success: false, data: nil)
            }
        }
    }
}