//
//  SecondKLinePresenter.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class SecondKLinePresenter: SecondKLinePresenterProtocol {

	weak var view: SecondKLineViewProtocol?
	var repository: SecondKLineDataSource?
	
	init(view: SecondKLineViewProtocol) {
		self.view = view
		repository = SecondKLineRepository()
	}
	
	func fetchKLine(withCode code: String) {
		repository?.fetchKLineData(withCode: code, completionHandler: { (success, data, strategyType) in
			if success {
				if let _data = data {
					let parseChartData = ParseChartData(jsonStr: _data)
					self.view?.setKLineData(withData: parseChartData.chartData, strategyType: strategyType)
				}
			}
		})
	}

	func fetchKLineIndex(withCode code: String, option: String) {
		repository?.fetchKLineIndexData(withCode: code, option: option, completionHandler: { (success, data) in
			if success {
				if let _data = data {
					let parseChartData = ParseChartData(jsonStr: _data)
					self.view?.setKLineIndexData(withData: parseChartData.chartData)
				}
			}
		})
	}
}
