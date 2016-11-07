//
//  incomeTopPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct IncomeTag {
    static var riseTag = 0
}
class IncomeTopPresenter : IncomeTopPresenterProtocol{
    var view : IncomeTopViewProtocol?
    var repository: IncomeTopRepositoryProtocol?
    var incomeItem : NewItem?
    var item: [AnyObject] = []
    var profitItems: [ProfitItem] = []
    //IncomeTopItem?
    init() {
        repository = IncomeTopRepository()
    }
    
    func didSelectIncomeTopItem(indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            getRoughStocks((self.incomeItem?.h333Conser)!, row: indexPath.row)
        case 1:
            getRoughStocks((self.incomeItem?.h333radic)!, row: indexPath.row)
        default:()
        }
    }
    
    func getRoughStocks(array:[AnyObject],row: Int) {
          var roughStocks: [RoughStock] = []
          for model in array {
            let roughStock = RoughStock(name: model.objectAtIndex(0) as! String, code: model.objectAtIndex(1) as! String, aowID: model.objectAtIndex(4) as? Int)
            roughStocks.append(roughStock)
        }
       //在这里进行跳转
          self.view?.skipToDetailView(roughStocks, index: row)
    }
    

    
    func numberOfRow(section: Int)-> Int {

        return profitItems.count
    }
    
    func getProfitRank(){
        repository?.getProfitRank({ (success, data) in
            if success {
                let status = data.valueForKeyPath("status") as! String
                if status == "success" {
                    let result = data.valueForKeyPath("data")
                    self.incomeItem = NewItem.init(data: result! )
                    self.view?.notifyFetchSuccess()
                }
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func getProfitRank(option:String) {
        repository?.getProfitRankMore(option, completion: { (success, data) in
            if success {
                let status = data.valueForKeyPath("status") as! String
                if status == "success" {
                    let result = data.valueForKeyPath("data") as? [AnyObject]
                    self.item = result!
                    self.view?.notifyFetchSuccess()
                }
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    //new add
    func didSelectProfitItem(indexPath: NSIndexPath){
        getRoughProfitStocks(profitItems,row: indexPath.row)
    }
    
    func getRoughProfitStocks(array:[ProfitItem],row: Int) {
        var roughStocks: [RoughStock] = []
        for model in array {
            let roughStock = RoughStock(name: model.stockName, code: model.stockCode, aowID: model.aowId)
            roughStocks.append(roughStock)
        }
        //在这里进行跳转
        self.view?.skipToDetailView(roughStocks, index: row)
    }
    
    
    //new add
    func setContentToView(cell: ProfitCellDataSource, indexPath: NSIndexPath) {
        let item = self.profitItems[indexPath.row]
        cell.set(stockCode: item.stockCode)
        cell.set(stockName: item.stockName)
        cell.set(rowId: item.aowId)
        cell.set(strategy: item.strategy)
        cell.set(position: item.position)
        cell.set(percentage: item.profit)
    }
    
    //new add
    func getStrategyRank(option: String,period:String) {
        var items: [ProfitItem] = []
        repository?.getStrategyRank(option,period: period, completion: { (success, data) in
            if success {
                let status = data.valueForKeyPath("status") as! String
                if status == "success" {
                    let result = data.valueForKeyPath("data") as? [AnyObject]
                    for i in 0...result!.count-1 {
                        if (result![i] as! [AnyObject]).count == 6{
                          let item = ProfitItem.init(data: result![i] as! [AnyObject])
                           items.append(item)
                        }else {
                           let item = ProfitItem.init(result: result![i] as! [AnyObject])
                            items.append(item)
                        }
                        
                    }
                    self.profitItems = items
                    self.view?.notifyFetchSuccess()
                }
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
}