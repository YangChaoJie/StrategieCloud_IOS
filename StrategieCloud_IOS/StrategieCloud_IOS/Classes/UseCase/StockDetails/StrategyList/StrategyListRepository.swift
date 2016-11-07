//
//  StrategyListRepository.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/9/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire

class StrategyListRepository: StrategyListDataSource {

	func requestStrategyList(code: String, completion: (success: Bool, data: [StrategyStockItem]?) -> ()) {
		Alamofire.request(Router.getStrategyWinInfo(code)).responseCollectionData { (response: Response<[StrategyStockItem], BackendError>) in
			switch response.result {
			case .Success(let value):
                print("获取的数据是\(value)")
				completion(success: true, data: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false, data: nil)
			}
		}
	}

	func requestStrategyDetail(withAowID aowID: String, completion: (success: Bool, data: StrategyChartItem?) -> ()) {
		Alamofire.request(Router.getStrategyAowDetail(aowID)).responseObject { (response: Response<StrategyChartItem, BackendError>) in
			switch response.result {
			case .Success(let value):
				completion(success: true, data: value)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false, data: nil)
			}
		}
	}

	func applyStrategy(withAowID aowID: Int, code: String, completion: (success: Bool) -> ()) {
		let parameters = [
			"ticker": code,
			"aow_id": String(aowID)
		]
		Alamofire.request(Router.aowSettingStrategy(parameters)).responseJSON { (response: Response<AnyObject, NSError>) in
			switch response.result {
			case .Success:
				completion(success: true)
			case .Failure(let error):
				print("\(#function) error: \(error)")
				completion(success: false)
			}
		}
	}
    
    //local
    func isOptionalShare(stockCode code: String) -> Bool {
        return RealmHelper.instance.isOptionalShare(witCode: code)
    }
}