//
//  ThirdStrategyPresenter.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class ThirdStrategyPresenter : ThirdStrategyPresenterProtocol {

	weak var view: ThirdStrategyViewProtocol?
	var repository: ThirdStrategyDataSource?
	
	var strategyBean: StrategyBean = StrategyBean()
	
	
	init(view: ThirdStrategyViewProtocol) {
		self.view = view
		repository = ThirdStrategyRepository()
	}
	
	func codeInOpitonalShare(code: String) -> Bool {
		return RealmHelper.instance.isOptionalShare(witCode: code)
	}
	
	func fetchProfitRankDetail(code: String, aowId: Int) {
		repository?.fetchProfitRankDetail(code, aowId: aowId, completion: { (bean) in
			if let _bean = bean {
				self.strategyBean = _bean
			}
			self.view?.fetchAowDetailSuccess()
		})
	}
	
	func fetchAowDetailWithCode(code: String) {
		repository?.fetchAowDetailWithCode(code, completion: { (bean) in
			if let _bean = bean {
				self.strategyBean = _bean
			}
			self.view?.fetchAowDetailSuccess()
		})
	}
	
	func setShowStyleContentToView(cell: ShowParamViewCellDataSource) {
		cell.setTitleForStyle(strategyBean.style)
	}
	
	func setShowPeiodContentToView(cell: ShowParamViewCellDataSource) {
		cell.setTitleForPeriod(strategyBean.period)
	}
	
	func setStyleContentToView(cell: OptionalParamViewCellDataSource) {
		cell.setTitleForStyle(strategyBean.style)
	}
	
	func setPeriodContentToView(cell: OptionalParamViewCellDataSource) {
		cell.setTitleForPeriod(strategyBean.period)
	}
	
	func setAdaptiveContentToView(cell: AdaptiveOptionalCellProtocol) {
		switch strategyBean.adaptor {
		case .On:
			cell.setSwithBtnState(true)
		case .Off:
			cell.setSwithBtnState(false)
		}
	}
	
	func setAdaptiveContentTextToView(cell: AdaptiveShowCellDataSource) {
		switch strategyBean.adaptor {
		case .On:
			cell.adaptiveShowCell(true)
		case .Off:
			cell.adaptiveShowCell(false)
		}
	}
	
	func setRecommendIdxContentToView(cell: RecommendIdxViewCellDataSource) {
		cell.recommendIdxRatingBar(strategyBean.recommendIdx)
	}
	
	func setBacktestChartContentToView(cell: BackTectChartDataSource) {
		cell.backTestChartViewData(BackTestBean(data: strategyBean.dataform))
	}
	
	func setTotalProfitContentToView(cell: TotalProfitDataSource) {
		cell.totalProfitValue(strategyBean.totalProfit, apply: strategyBean.applySwitch)
	}
	
	func setEachProfitContentToView(cell: EachProfitDataSource) {
		cell.eachProfitValue(strategyBean.profit10, profit60: strategyBean.profit60, profit250: strategyBean.profit250)
	}
	
	func setAdaptive(adaptor: StrategyBean.Adaptor) {
		strategyBean.adaptor = adaptor
		self.cleanDatafrom()
	}
	
	func setStyle(style: StrategyBean.Style) {
		strategyBean.style = style
		self.cleanDatafrom()
	}
	
	func setPeriod(period: StrategyBean.Period) {
		strategyBean.period = period
		self.cleanDatafrom()
	}

	func setAowSwitch(on: Bool, withCode code: String) {
		strategyBean.applySwitch = on
		uploadAowParam(code)
	}
	
	func fetchBacktestData(withCode code: String) {
		let style = strategyBean.style.rawValue
		let period = strategyBean.period.rawValue
		let adaptor = strategyBean.adaptor.rawValue
		repository?.fetchBacktestData(code, style: style, period: period, adaptor: adaptor, completion: { (bean) in
			
			if let _bean = bean {
				self.strategyBean.recommendIdx = _bean.recommendIdx
				self.strategyBean.dataform = _bean.dataform
				self.strategyBean.profit10 = _bean.profit10
				self.strategyBean.profit60 = _bean.profit60
				self.strategyBean.profit250 = _bean.profit250
				self.strategyBean.totalProfit = _bean.totalProfit
				self.view?.notifyRefresh()
			}
		})
	}
	
	func showChart() -> Bool {
		if let _ = self.strategyBean.dataform {
			return true
		}
		return false
	}
	
	private func uploadAowParam(code: String) {
		let style = strategyBean.style.rawValue
		let period = strategyBean.period.rawValue
		let adaptor = strategyBean.adaptor.rawValue
		let aowSwitch = strategyBean.applySwitch
		repository?.uploadParamSet(code, style: style, period: period, adaptor: adaptor, aowSwitch: aowSwitch, completion: { (success) in
			if !success {
				self.strategyBean.applySwitch = !self.strategyBean.applySwitch
				self.view?.notifyRefresh()
			}
		})
	}
	
	private func cleanDatafrom() {
		if strategyBean.dataform != nil {
			strategyBean.dataform = nil
			view?.notifyRefresh()
		}
		strategyBean.applySwitch = false
	}
}