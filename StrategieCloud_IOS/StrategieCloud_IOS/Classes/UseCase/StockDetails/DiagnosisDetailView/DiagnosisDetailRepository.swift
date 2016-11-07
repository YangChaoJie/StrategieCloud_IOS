//
//  DiagnosisDetailRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class DiagnosisDetailRepository:DiagnosisDetailRepositoryProtocol{
    func diagnosestock(stockCode:String,completion: (success: Bool, data: AnyObject?) -> ()){
        Alamofire.request(Router.diagnosestock(stockCode)).responseJSON { (response) in
            switch response.result{
            case .Success(let value):
                completion(success: true, data: value)
            case .Failure(let error):
                print("\(#function) error: \(error)")
                completion(success: false, data: nil)
            }
        }
    }
}