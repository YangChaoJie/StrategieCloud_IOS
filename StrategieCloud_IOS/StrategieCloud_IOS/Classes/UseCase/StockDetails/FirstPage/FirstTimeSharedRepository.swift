//
//  FirstTimeSharedRepository.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire

class FirstTimeSharedRepository: FirstTimeSharedDataSource {

	private enum DataOption: String {
		case TimeSharedData = "ticks"
		case VolumeData = "volume"
	}
	
	init() {}
	
	func fetchMinuteTickData(withCode code: String, completion: (chartData: CombinedChartData?, value: [Double]?) -> ()) {
		Alamofire.request(Router.MinuteTick(code, DataOption.TimeSharedData.rawValue)).responseJSON { (response: Response<AnyObject, NSError>) in
			
			switch response.result {
			case .Success(let value):
				if let data = value["data"] as? String {
					let parseChartData = ParseChartData(jsonStr: data)
					completion(chartData: parseChartData.chartData, value: parseChartData.changePct)
				}
			case .Failure(let error):
				completion(chartData: nil, value: nil)
				print("\(#function),error: \(error)")
			}
		}
	}
	
	func fetchMinuteVolumeData(withCode code: String, completion: (chartData: CombinedChartData?) -> ()) {
		Alamofire.request(Router.MinuteTick(code, DataOption.VolumeData.rawValue)).responseJSON { (response: Response<AnyObject, NSError>) in
			
			switch response.result {
			case .Success(let value):
				if let data = value["data"] as? String {
					let parseChartData = ParseChartData(jsonStr: data)
					completion(chartData: parseChartData.chartData)
				}
			case .Failure(let error):
				completion(chartData: nil)
				print("\(#function),error: \(error)")
			}
		}
	}

	func fetchStockDetailsInfo(withCode code: String, completion: (success: Bool, stockDetailsItem: StockDetailsItem?) -> ()) {
		Alamofire.request(Router.StockDetail(code)).responseObject { (response: Response<StockDetailsItem, BackendError>) in
			switch response.result {
			case .Success(let value):
				completion(success: true, stockDetailsItem: value)
			case .Failure(let error):
				completion(success: false, stockDetailsItem: nil)
				print("\(#function),error: \(error)")
			}
		}
	}
}