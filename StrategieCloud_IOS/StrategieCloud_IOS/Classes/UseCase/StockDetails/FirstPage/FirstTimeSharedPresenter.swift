//
//  FirstTimeSharedPresenter.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class FirstTimeSharedPresenter: FirstTimeSharedPresenterProtocol {
	
	weak var firstTimeSharedView: FirstTimeSharedViewProtocol?
	var firstTimeSharedDatasource: FirstTimeSharedDataSource?
	
	init(view: FirstTimeSharedViewProtocol) {
		firstTimeSharedView = view
		firstTimeSharedDatasource = FirstTimeSharedRepository()
	}

	// MARK: - FirstTimeSharedPresenterProtocol
	func fetchMinuteTickData(withCode code: String) {
		firstTimeSharedDatasource?.fetchMinuteTickData(withCode: code, completion: { (chartData, value) in
			self.firstTimeSharedView?.setAboveViewDatas(chartData, value: value)
		})
	}
	
	func fetchMinuteVolumeData(withCode code: String) {
		firstTimeSharedDatasource?.fetchMinuteVolumeData(withCode: code, completion: { (chartData) in
			self.firstTimeSharedView?.setBelowViewDatas(chartData)
		})
	}
	
	func fetchStockDetailsInfo(withCode code: String) {
		firstTimeSharedDatasource?.fetchStockDetailsInfo(withCode: code, completion: { (success, stockDetailsItem) in
			if success {
				if let _stockDetailsItem = stockDetailsItem {
					self.firstTimeSharedView?.setStockDetailsInfo(_stockDetailsItem)
				}
			}
		})
	}
}