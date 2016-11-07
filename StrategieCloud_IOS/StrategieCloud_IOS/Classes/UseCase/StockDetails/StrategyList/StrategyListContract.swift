//
//  StrategyListContract.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/9/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

protocol StrategyListPresenterProtocol: class {
	//View -> Presenter
	
	func gainStrategyListFromServer(withCode code: String)
	
	func numberOfSection() -> Int
	func expanededOfSection(section: Int) -> Bool
	func setContentOfSection(section: Int, dataSource: SectionHeaderViewDataSource)
	func setContentOfProfit(section: Int, dataSource: ProfitTableViewCellDataSource)
	func setContentOfChart(section: Int, dataSource: StrategyChartTableViewCellDataSource)

	func switchExpandSection(section: Int)
	func switchApplyStrategy(section: Int, code: String, switchOn: Bool)
    
    func isOptionalShare(stockCode code: String) -> Bool
}

protocol StrategyListViewProtocol: class {
	// Presenter -> View
	
	func notifyFetchSuccess()
	func notifyFetchFailure()

	func reloadSection(section: Int)
	func reloadCells(withSection section: Int)
	func reloadSections(sectionCount: Int)
    func notifyUsingFailure()
}

protocol StrategyListDataSource: class {
	// Presenter -> Repository
	
	func requestStrategyList(code: String, completion: (success: Bool, data: [StrategyStockItem]?) -> ())
	func requestStrategyDetail(withAowID aowID: String, completion: (success: Bool, data: StrategyChartItem?) -> ())
	func applyStrategy(withAowID aowID: Int, code: String, completion: (success: Bool) -> ())
    
    func isOptionalShare(stockCode code: String) -> Bool
}