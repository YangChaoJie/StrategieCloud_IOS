//
//  OptionBsPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class OptionBsPresenter : OptionBsPresenterProtocol{
    var view: OptionBsViewProtocol?
    var respository : OptionBsRespositoryProtocol?
    
    init() {
        respository = OptionBsRespository()
    }
    
    var items: [BsItem] = []
    var optionBsItem:[OptionBsItem] = []
    
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
    
    func convertToItem(items: [BsItem],section:Int)->[OptionBsItem]  {
        var optionItems:[OptionBsItem] = []
        for optionItem in items[section].message {
            let optionChangeItem = OptionBsItem.init(data: optionItem as! [AnyObject])
            optionItems.append(optionChangeItem)
        }
        self.optionBsItem = optionItems
        return self.optionBsItem
    }
    
    func didSelectItem(indexPath:NSIndexPath) {
        let item =  convertToItem(self.items,section: indexPath.section)
        getRoughStocks(item, row: indexPath.row)
    }
    
    func getRoughStocks(array:[OptionBsItem],row: Int) {
        var roughStocks: [RoughStock] = []
        for model in array {
            let roughStock = RoughStock(name: model.stockName, code: model.stockCode)
            roughStocks.append(roughStock)
        }
        //在这里进行跳转
        self.view?.skipToDetailView(roughStocks, index: row)
    }
    
    func convertToHeaderItem(items: [BsItem],section:Int)->String {
        return items[section].date
    }
    
    
    func numberOfRow(section:Int)->Int {
        return self.items[section].message.count
        
    }
    
    func numberOfSection()->Int {
        return self.items.count
    }
    
    func setDataToHeaderView(view: OptionBsHeaderViewDataSource,section: Int) {
        let date = convertToHeaderItem(self.items, section: section)
        view.setDataToView(date)
    }
    
    func setDataToCell(cell:OptionBsCellDataSource,indexPath:NSIndexPath) {
        let item =  convertToItem(self.items,section: indexPath.section)[indexPath.row]
        
        cell.set(name: item.stockName)
        cell.set(time: item.date)
        cell.set(message: item.strategyMessage)
        cell.set(bs: item.bs)
    }
}