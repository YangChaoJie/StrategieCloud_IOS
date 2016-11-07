//
//  OptionalLiveRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class OptionalLiveRepository :OptionalLiveRepositoryProtocol{

	func getInventorymessage(completion: (success: Bool, data: LiveMsg?) -> ()) {
		
		Alamofire.request(Router.getInventorymessage).responseObject { (response: Response<LiveMsg, BackendError>) in
			
			switch response.result {
			case .Success(let value):
                print("value---\(value)")
				completion(success: true, data: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false, data: nil)
			}
		}
	}
}