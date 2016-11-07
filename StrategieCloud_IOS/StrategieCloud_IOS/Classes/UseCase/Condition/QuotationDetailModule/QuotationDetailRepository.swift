//
//  QuotationDetailRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class QuotationDetailRepository: QuotationDetailDataSourceProtocol {
    
    func getMoreMarKetInfo(option:String,completion: (success: Bool, data: AnyObject?) -> ()) {
        // print("value的值是===\(option)")
        Alamofire.request(Router.getMarkMoreInfo(option)).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                //print("value的值是===\(value)")
                completion(success: true, data: value)
            case .Failure(let error):
                completion(success: false, data: "")
                print("error=====\(error)")
            }
        }
    }
    
    func getIndustryInfo(info:String) {
        Alamofire.request(Router.getIndustryInfo(info)).responseJSON { (response) in
            switch response.result {
            case .Success(let value):
                print("value===\(value)")
            case .Failure(let error):
                print("error=====\(error)")
            }
        }
    }
}