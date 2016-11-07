//
//  ThirdStrategyRepository.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire

class ThirdStrategyRepository: ThirdStrategyDataSource {
	
	func fetchAowDetailWithCode(code: String, completion: ((bean: StrategyBean?) -> ())) {
		Alamofire.request(Router.AowDetail(ticker: code)).responseObject { (response: Response<StrategyBean, BackendError>) in
			switch response.result {
			case .Success(let value):
				completion(bean: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(bean: nil)
			}
		}
	}
	
	func fetchProfitRankDetail(code: String, aowId: Int, completion: ((bean: StrategyBean?) -> ())) {
		let parameters = [
			"ticker": code,
			"aow_id": "\(aowId)"
		]
		Alamofire.request(Router.ProfitRankDetail(parameters)).responseObject { (response: Response<StrategyBean, BackendError>) in
			switch response.result {
			case .Success(let value):
				completion(bean: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(bean: nil)
			}
		}
	}
	
	func fetchBacktestData(code: String, style: Int, period: Int, adaptor: Int, completion: (bean: StrategyBean?) -> ()) {
		let parameters = [
			"ticker": code,
			"style": "\(style)",
			"period": "\(period)",
			"adaptor": "\(adaptor)"
		]
		Alamofire.request(Router.BacktestData(parameters)).responseObject { (response: Response<StrategyBean, BackendError>) in
			switch response.result {
			case .Success(let value):
				completion(bean: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(bean: nil)
			}
		}
	}
	
	func uploadParamSet(code: String, style: Int, period: Int, adaptor: Int, aowSwitch: Bool, completion: ((success: Bool) -> ())) {
		let parameters = [
			"ticker": code,
			"style": "\(style)",
			"period": "\(period)",
			"adaptor": "\(adaptor)",
			"aow_switch": (aowSwitch ? "true" : "false")
		]
		Alamofire.request(Router.AowInfo(parameters)).responseJSON { (response: Response<AnyObject, NSError>) in
			switch response.result {
			case .Success:
				completion(success: true)
			case .Failure(let error):
				print("\(#function) error \(error)")
				completion(success: false)
			}
		}
	}
}