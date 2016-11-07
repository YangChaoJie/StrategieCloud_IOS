//
//  ThirdStrategyContract.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

protocol ThirdStrategyPresenterProtocol: class {
	//View -> Presenter
	
	func fetchAowDetailWithCode(code: String)
	func fetchProfitRankDetail(code: String, aowId: Int)

	func setShowStyleContentToView(cell: ShowParamViewCellDataSource)
	func setShowPeiodContentToView(cell: ShowParamViewCellDataSource)
	
	func setStyleContentToView(cell: OptionalParamViewCellDataSource)
	func setPeriodContentToView(cell: OptionalParamViewCellDataSource)
	func setAdaptiveContentToView(cell: AdaptiveOptionalCellProtocol)
	func setRecommendIdxContentToView(cell: RecommendIdxViewCellDataSource)
	func setBacktestChartContentToView(cell: BackTectChartDataSource)
	func setTotalProfitContentToView(cell: TotalProfitDataSource)
	func setEachProfitContentToView(cell: EachProfitDataSource)
	func setAdaptiveContentTextToView(cell: AdaptiveShowCellDataSource)
	
	func showChart() -> Bool
	func fetchBacktestData(withCode code: String)
	
	func setAdaptive(adaptor: StrategyBean.Adaptor)
	func setStyle(style: StrategyBean.Style)
	func setPeriod(period: StrategyBean.Period)
	func setAowSwitch(on: Bool, withCode code: String)
	
	func codeInOpitonalShare(code: String) -> Bool
}

protocol ThirdStrategyViewProtocol: class {
	// Presenter -> View
	
	func fetchAowDetailSuccess()
	func notifyRefresh()
}

protocol ThirdStrategyDataSource: class {
	// Presenter -> Repository
	
	func fetchProfitRankDetail(code: String, aowId: Int, completion:((bean: StrategyBean?) -> ()))
	func fetchAowDetailWithCode(code: String, completion: ((bean: StrategyBean?) -> ()))
	func fetchBacktestData(code: String, style: Int, period: Int, adaptor: Int, completion: (bean: StrategyBean?) -> ())
	
	func uploadParamSet(code: String, style: Int, period: Int, adaptor: Int, aowSwitch: Bool, completion: ((success: Bool) -> ()))
}