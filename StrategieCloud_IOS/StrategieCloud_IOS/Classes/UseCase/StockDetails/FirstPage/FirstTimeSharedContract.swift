//
//  FirstTimeSharedContract.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

protocol FirstTimeSharedPresenterProtocol: class {
	
	// View -> Presenter
	
	func fetchMinuteTickData(withCode code: String)
	func fetchMinuteVolumeData(withCode code: String)
	func fetchStockDetailsInfo(withCode code: String)
}

protocol FirstTimeSharedViewProtocol: class {
	// Presenter -> View
	
	func setAboveViewDatas(chartData: CombinedChartData?, value: [Double]?)
	func setBelowViewDatas(chartData: CombinedChartData?)
	func setStockDetailsInfo(stockDetailsItem: StockDetailsItem)
}

protocol FirstTimeSharedDataSource: class {
	// Presenter -> Repository
	
	func fetchMinuteTickData(withCode code: String, completion: (chartData: CombinedChartData?, value: [Double]?) -> ())
	func fetchMinuteVolumeData(withCode code: String, completion: (chartData: CombinedChartData?) -> ())
	func fetchStockDetailsInfo(withCode code: String, completion: (success: Bool, stockDetailsItem: StockDetailsItem?) -> ())
}