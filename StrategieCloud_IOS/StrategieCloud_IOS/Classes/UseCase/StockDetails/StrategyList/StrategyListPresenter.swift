//
//  StrategyListPresenter.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/9/6.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class StrategyListPresenter: StrategyListPresenterProtocol {
	
	weak var view: StrategyListViewProtocol?
	var dataSource: StrategyListDataSource?
	var strategyItems: [StrategyStockItem] = []

	init(view: StrategyListViewProtocol) {
		self.view = view
		dataSource = StrategyListRepository()
	}
	
	func gainStrategyListFromServer(withCode code: String) {
		dataSource?.requestStrategyList(code, completion: { [weak self] (success, data) in
			if success {
               if let dataSource = data {
                self!.strategyItems = dataSource
                }
				
				self!.view?.notifyFetchSuccess()
			} else {
				self!.view?.notifyFetchFailure()
			}
		})
	}

	func numberOfSection() -> Int {
		return strategyItems.count
	}
    
    func isOptionalShare(stockCode code: String) -> Bool{
        return (dataSource?.isOptionalShare(stockCode: code))!
    }

    func setContentOfSection(section: Int, dataSource: SectionHeaderViewDataSource) {
		let item = self.strategyItems[section]
		dataSource.sectionHeaderView(name: item.name,
		                             profit: item.profit,
		                             idx: item.star,
		                             using: item.isUsing,
		                             section: section,
		                             isExpanded: item.isExpanded,
                                     time: item.backtestStart)
	}

	func setContentOfProfit(section: Int, dataSource: ProfitTableViewCellDataSource) {
		let item = self.strategyItems[section]
		if let strategyItem = item.strategyChartItem {
			dataSource.profitValue(strategyItem.profit10, profit60: strategyItem.profit60, profit250: strategyItem.profit250)
		}
	}

	func setContentOfChart(section: Int, dataSource: StrategyChartTableViewCellDataSource) {
		let item = self.strategyItems[section]
		if let strateyItem = item.strategyChartItem {
			dataSource.backTestChartViewData(BackTestBean(data: strateyItem.dataform))
		} else {
			dataSource.backTestChartViewData(nil)
		}
	}

	func expanededOfSection(section: Int) -> Bool {
		return self.strategyItems[section].isExpanded
	}

	func switchExpandSection(section: Int) {
		strategyItems[section].isExpanded = !strategyItems[section].isExpanded
		view?.reloadSection(section)
		if strategyItems[section].isExpanded {
			getStrategyCharInfo(section)
		}
	}

	func switchApplyStrategy(section: Int, code: String, switchOn: Bool) {
		let aowID = self.strategyItems[section].aowId
		if switchOn {
			dataSource?.applyStrategy(withAowID: aowID, code: code, completion: { [weak self] (success) in
				if success {
					self!.strategyItems[section].isUsing = true
					for i in 0..<self!.strategyItems.count {
						if i == section {
							self!.strategyItems[i].isUsing = true
						} else {
							self!.strategyItems[i].isUsing = false
						}
					}
					self?.view?.reloadSections(self!.strategyItems.count)
				} else {
                    
					self!.view?.notifyUsingFailure()
				}
			})
		} else {
            dataSource?.applyStrategy(withAowID: 0, code: code, completion: { [weak self] (success) in
                if success {
                    self!.strategyItems[section].isUsing = false
                    self?.view?.reloadSections(self!.strategyItems.count)
                } else {
                    self!.view?.notifyUsingFailure()
                }
            })
			//self.view?.reloadSection(section)
		}
	}
	
	private func getStrategyCharInfo(section: Int) {
		if let _ = self.strategyItems[section].strategyChartItem {
			view?.reloadCells(withSection: section)
		} else {
			dataSource?.requestStrategyDetail(withAowID: String(strategyItems[section].aowId), completion: { [weak self] (success, data) in
				if success {
					self!.strategyItems[section].strategyChartItem = data
				}
				self!.view?.reloadCells(withSection: section)
			})
		}
	}
}