//
//  OptionChangeRespository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class OptionChangeRespository: OptionChangeRespositoryProtocol {
    func getChosenAlert(completion: (data: [ChangeItem]?,success: Bool) -> ()) {
        
        Alamofire.request(Router.getChosenBsAlert("alert")).responseCollectionData { (response:Response<[ChangeItem], BackendError>) in

            switch response.result{
            case .Success(let value):
               // print("异动的数据是\(value)")
                completion(data: value,success:true)
            case .Failure(let error):
                print("\(error)")
                completion(data: nil,success:false)
            }
        }
    }
}