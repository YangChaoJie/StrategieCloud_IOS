//
//  ApplicationStrategyPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class ApplicationStrategyPresenter:ApplicationStrategyPresenterProtocol {
    var view: ApplicationStrategyPageProtocol?
    var repository: ApplicationStrategyRespositoryProtocol?
    var strategyItem: [StrategyStockItem] = []
    
    var strategyChartItem : StrategyChartItem = StrategyChartItem()
    init() {
        repository = ApplicationStrategyRepository()
    }
    
    func numberOfSection()-> Int {
        return self.strategyItem.count
    }
    
    func getStrategyWinInfo(stockCode:String) {
        repository?.getStrategyWinInfo(stockCode, completion: { (success, data) in
            if success {
                self.strategyItem = data as! [StrategyStockItem]
                self.view?.notifyFetchSuccess()
            }else{
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func setDataToHeaderView(view:StrategyPageHeaderViewDataSource,section:Int) {
        let item = strategyItem[section]
        view.set(use: item.isUsing)
        view.set(name: item.name)
        view.set(aowId: item.aowId)
        view.setProfit(profit: item.profit)
        view.setStarNumber(number: item.star)
    }
    
    func setEachProfitContentToView(cell: StrategyIncomeCellDataSource,indexPath:NSIndexPath) {
        if self.strategyItem[indexPath.section].strategyChartItem != nil {
            let item = self.strategyItem[indexPath.section].strategyChartItem!
            cell.eachProfitValue(item.profit10, profit60:  item.profit60, profit250:  item.profit250)
        }
      
    }
    
    func setBacktestChartContentToView(cell: StrategyChartCellDataSource,index:NSIndexPath) {
        if self.strategyItem[index.section].strategyChartItem != nil {
            let item = self.strategyItem[index.section].strategyChartItem!
            if self.strategyChartItem.dataform != nil{
                //print("分析的数据是----\(strategyChartItem.dataform)")
                cell.backTestChartViewData(BackTestBean(data: item.dataform))
            }
        }
    }
    
    func settingUse(aowId:Int,code:String) {
        repository?.settingStrategy(code, aowId: aowId, completion: { (success) in
            if success {
                self.view?.getDataToServer()
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    
    func getStrategyChartInfo(aowId:Int) {
        repository?.getStrategyAoeDetail(aowId, completion: { (success, data) in
            //在这里查找 数组里 等于 aowId 的 并给 数组的 strategyChartItem  赋值
            if success{
                self.strategyChartItem = data!
                var items: [StrategyStockItem] = []
                for item in self.strategyItem {
                    if item.aowId == aowId  && item.strategyChartItem?.profit10 !=  self.strategyChartItem.profit10 {
                        let optionItem = StrategyStockItem(name: item.name,
                                            profit:item.profit,
                                            star:item.star,
                                            isUsing:item.isUsing,
                                            aowId:item.aowId,strategyChartItem :
                                            self.strategyChartItem)
                        items.append(optionItem)
                    }else{
                        items.append(item)
                    }
                }
                self.strategyItem = items
                self.view?.notifyFetchSuccess()
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
}
