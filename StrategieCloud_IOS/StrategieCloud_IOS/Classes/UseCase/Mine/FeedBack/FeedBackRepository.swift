//
//  FeedBackRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class FeedBacKRepsitory :FeedBackRepositoryProtocol{
    func suggest(text: String,completion:(success: Bool, data: AnyObject)->()) {
        let parameters: [String: AnyObject] = [
            "suggestion"  : text
                                              ]
        Alamofire.request(Router.suggest(parameters)).responseJSON{(response) in
            switch response.result {
            case .Success(let value):
                print("请求的数据===\(value)")
                completion(success: true, data: value)
            case .Failure(let error):
                completion(success: false, data: "")
                print("error: \(error)")
            }
        
        }
    }
}