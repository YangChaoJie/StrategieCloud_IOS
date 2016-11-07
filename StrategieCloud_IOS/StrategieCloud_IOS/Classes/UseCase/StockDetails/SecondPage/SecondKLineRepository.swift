//
//  SecondKLineRepository.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire

class SecondKLineRepository: SecondKLineDataSource {
	
	func fetchKLineData(withCode code: String, completionHandler: (success: Bool, data: String?, strategyType: Int) -> ()) {
		Alamofire.request(Router.KLineData(code)).responseJSON { (response: Response<AnyObject, NSError>) in
			switch response.result {
			case .Success(let value):
				if let _data = value["data"] as? NSDictionary {
					completionHandler(success: true, data: _data["figure"] as? String, strategyType: _data["is_bs"] as! Int)
				}
			case .Failure(let error):
				print("\(#function),error : \(error)")
				completionHandler(success: false, data: nil, strategyType: 0)
			}
		}
	}

	func fetchKLineIndexData(withCode code: String, option: String, completionHandler: (success: Bool, data: String?) -> ()) {
		Alamofire.request(Router.KLineIndex(code, option)).responseJSON { (response: Response<AnyObject, NSError>) in
			switch response.result {
			case .Success(let value):
				if let _data = value["data"] as? NSDictionary {
					completionHandler(success: true, data: _data["figure"] as? String)
				}
			case .Failure(let error):
				print("\(#function),error : \(error)")
				completionHandler(success: false, data: nil)
			}
		}
	}
}