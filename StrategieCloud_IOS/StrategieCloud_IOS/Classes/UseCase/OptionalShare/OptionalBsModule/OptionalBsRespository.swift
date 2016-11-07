//
//  OptionalBsRespository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class OptionBsRespository : OptionBsRespositoryProtocol{
    func getChosenAlert(completion: (data: [BsItem]?,success: Bool) -> ()) {
        Alamofire.request(Router.getChosenBsAlert("bspoint")).responseCollectionData { (response:Response<[BsItem], BackendError>) in
          
            switch response.result{
            case .Success(let value):
                 print("Bs的数据是\(value)")
                completion(data: value,success:true)
            case .Failure(let error):
                print("\(error)")
                completion(data: nil,success:false)
            }
        }
    }
}