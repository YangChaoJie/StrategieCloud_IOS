//
//  SecondKLineContract.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

protocol SecondKLinePresenterProtocol: class {
	
	// View -> Presenter
	func fetchKLine(withCode code: String)
	func fetchKLineIndex(withCode code: String, option: String)

}

protocol SecondKLineViewProtocol: class {
	// Presenter -> View
	func setKLineData(withData data: CombinedChartData?, strategyType: Int)
	func setKLineIndexData(withData data: CombinedChartData?)
	
}

protocol SecondKLineDataSource: class {
	// Presenter -> Repository
	func fetchKLineData(withCode code: String, completionHandler: (success: Bool, data: String?, strategyType: Int) -> ())
	func fetchKLineIndexData(withCode code: String, option: String, completionHandler: (success: Bool, data: String?) -> ())
}