//
//  OptionChangePresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class OptionChangePresenter :OptionChangePresenterProtocol{
    var view: OptionChangeViewProtocol?
    var respository: OptionChangeRespositoryProtocol?
    var optionChangeItem:[OptionChangeItem] = []
    var items: [ChangeItem] = []
    init() {
        respository = OptionChangeRespository()
    }
    
    func getChangeDataSourceToServer() {
                respository?.getChosenAlert({ (data, success) in
            if success {
                self.items = data!
                    //.reverse()
                self.view?.notifyFetchSuccess()
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func convertToItem(items: [ChangeItem],section:Int)->[OptionChangeItem]  {
            var optionItems:[OptionChangeItem] = []
            for optionItem in items[section].message {
                let optionChangeItem = OptionChangeItem.init(data: optionItem as! [AnyObject])
                optionItems.append(optionChangeItem)
            }
            self.optionChangeItem = optionItems
        return self.optionChangeItem
    }
    
    func didSelectItem(indexPath:NSIndexPath) {
        let item =  convertToItem(self.items,section: indexPath.section)
        getRoughStocks(item, row: indexPath.row)
    }
    
    func getRoughStocks(array:[OptionChangeItem],row: Int) {
        var roughStocks: [RoughStock] = []
        for model in array {
            let roughStock = RoughStock(name: model.stockName, code: model.stockCode)
            roughStocks.append(roughStock)
        }
        //在这里进行跳转
        self.view?.skipToDetailView(roughStocks, index: row)
    }
    
    func convertToHeaderItem(items: [ChangeItem],section:Int)->String {
        return items[section].date
    }
    
    
    func numberOfRow(section:Int)->Int {
        return self.items[section].message.count
        
    }
    
    func numberOfSection()->Int {
        return self.items.count
    }
    
    func setDataToHeaderView(view: OptionChangeHeaderViewDataSource,section: Int) {
        let date = convertToHeaderItem(self.items, section: section)
        view.setDataToView(date)
    }
    
    func setDataToCell(cell:OptionChangeCellDataSource,indexPath:NSIndexPath) {
        let item =  convertToItem(self.items,section: indexPath.section)[indexPath.row]
        
        cell.set(name: item.stockName)
        cell.set(time: item.date)
        cell.set(message: item.strategyMessage)
    }
}