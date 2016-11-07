//
//  incomeTopRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class IncomeTopRepository: IncomeTopRepositoryProtocol {
    func getProfitRank(completion: (success: Bool, data: AnyObject) -> ()) {
        Alamofire.request(Router.getStrategyProfitRank).responseJSON{(response) in
            switch response.result{
            case .Success(let value):
               completion(success: true, data: value)
            case .Failure( _):
                completion(success: false, data: "")
            }
            
        }
    }
    
    func getProfitRankMore(option: String,completion: (success: Bool, data: AnyObject) -> ()) {
        Alamofire.request(Router.getProfitRankMore(option)).responseJSON{(response) in
            switch response.result{
            case .Success(let value):
                //print("\(value)")
                completion(success: true, data: value)
            case .Failure( let value):
                print("================\(value)")
                completion(success: false, data: "")
            }
            
        }
    }
    
    func getStrategyRank(option: String,period:String,completion: (success: Bool, data: AnyObject) -> ()) {
     //   print("上传的参数为\(option)  \(period)")
        Alamofire.request(Router.getstrategyRank(option, period)).responseJSON{(response) in
            switch response.result{
            case .Success(let value):
                //print("\(value)")
                completion(success: true, data: value)
            case .Failure( let value):
                print("================\(value)")
                completion(success: false, data: "")
            }
        }
    }
    
}