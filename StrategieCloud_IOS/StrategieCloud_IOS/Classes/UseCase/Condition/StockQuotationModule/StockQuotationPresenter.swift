//
//  StockQuotationPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/19.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class StockQuotationPresenter : StockQuotationPresenterProtocol{
    weak var view : StockQuotationViewProtocol?
    var repository: StockQuotationDataSourceProtocol?
    var optionalItem: [OptionalItem] = []
    var stockQuotationItem : StockQuotationItem!
 
    init() {
        repository = StockQuotationRepository()
    }
    
    func didSelectStockQuotationHeader(index: Int) {
        var roughStocks: [RoughStock] = []
        for model in self.optionalItem {
            let roughStock = RoughStock(name: model.stockName, code: model.stockCode)
            roughStocks.append(roughStock)
        }
        self.view?.skipToDetailView(roughStocks, index: index)
    }
    
    func didSelectStockQuotationItem(indexPath: NSIndexPath) {
        if self.stockQuotationItem != nil  {
            switch self.dataList[indexPath.section][1] {
            case "equ_desc":
                if self.stockQuotationItem.equ_desc.count > 0 {
                    getRoughStocks(self.stockQuotationItem.equ_desc, index: indexPath.row)
                }
            case "equ_aes" :
                if self.stockQuotationItem.equ_aes.count > 0 {
                     getRoughStocks(self.stockQuotationItem.equ_aes, index: indexPath.row)
                }
            case "five_min":
                if self.stockQuotationItem.five_min.count > 0 {
                    getRoughStocks(self.stockQuotationItem.five_min, index: indexPath.row)
                }
            case "turnover":
                if self.stockQuotationItem.turnover.count > 0 {
                    getRoughStocks(self.stockQuotationItem.turnover, index: indexPath.row)
                }
            default:
                if self.stockQuotationItem.volume_rate.count > 0 {
                    getRoughStocks(self.stockQuotationItem.volume_rate, index: indexPath.row)
                }
            }
        }
    }
    
    func getRoughStocks(array:[AnyObject],index: Int) {
        var roughStocks: [RoughStock] = []
        for model in array {
            let roughStock = RoughStock(name: model.objectAtIndex(1) as! String, code: model.objectAtIndex(0) as! String)
            roughStocks.append(roughStock)
        }
        self.view?.skipToDetailView(roughStocks, index: index)
    }
    
    
    func getDataList()->[[String]] {
        return self.dataList
    }
    
    func setDataOfHeader(view: QuotationHeaderDataSource ,index : Int) {
        if self.optionalItem.count > 0 {
        let item = self.optionalItem[index]
        view.set(trend: item.trend)
        view.set(change: item.change)
        view.set(status: item.status)
        view.set(changePct: item.changePct)
        view.set(stockName: item.stockName)
        view.set(lastPrice: item.lastPrice)
      }
    }
    
    func setDataOfIndustry(view: IndustrynDataSource ,index : Int, section: Int) {
        if self.stockQuotationItem != nil  {
         if self.stockQuotationItem.industry.count > 0 && section == 1{
            setDataToView(view, array: self.stockQuotationItem.industry, index: index)
         }else if  self.stockQuotationItem.concept.count > 0 && section == 2{
            setDataToView(view, array: self.stockQuotationItem.concept, index: index)
         }
      }
    }
    
    func setDataToView(view: IndustrynDataSource ,array : [AnyObject],index: Int) {
        let item = array[index] as! [AnyObject]
        view.set(stockName: item[4] as! String)
        view.set(change: item[2] as! Double)
        view.set(industryName: item[1] as! String)
        view.set(changePct: item[5] as! Double)
        view.set(percentage: item[6] as! Double)
        view.set(number: item[0] as! String)
    }
    
    func numberOfItems(inSection section:Int) -> Int {
        return 10
    }
    
    func setContentToView(cell: QuotationDataSource, indexPath: NSIndexPath) {
        if self.stockQuotationItem != nil  {
            switch self.dataList[indexPath.section][1] {
            case "equ_desc":
                if self.stockQuotationItem.equ_desc.count > 0 {
                    setDataToCell(cell, array: self.stockQuotationItem.equ_desc, index: indexPath.row,section: indexPath.section)
                }
            case "equ_aes" :
                if self.stockQuotationItem.equ_aes.count > 0 {
                    setDataToCell(cell, array: self.stockQuotationItem.equ_aes, index: indexPath.row,section: indexPath.section)
                }
            case "five_min":
                if self.stockQuotationItem.five_min.count > 0 {
                    setDataToCell(cell, array: self.stockQuotationItem.five_min, index: indexPath.row,section: indexPath.section)
                }
            case "turnover":
                if self.stockQuotationItem.turnover.count > 0 {
                    setDataToCell(cell, array: self.stockQuotationItem.turnover, index: indexPath.row,section: indexPath.section)
                }
            default:
                if self.stockQuotationItem.volume_rate.count > 0 {
                    setDataToCell(cell, array: self.stockQuotationItem.volume_rate, index: indexPath.row,section: indexPath.section)
                }
            }
        }
    }
    
    func setDataToCell(cell: QuotationDataSource ,array : [AnyObject],index: Int,section: Int) {
        let item = array[index] as! [AnyObject]
        cell.set(stockName: item[1] as! String)
        cell.set(change: item[2] as! Double)
        cell.set(stockCode: item[0] as! String)
        cell.set(percentage: item[3] as! Double)
        cell.set(headName: self.dataList[section][1])
    }
    
    func getMarketInfo(auto:Bool){
        repository?.getMarketInfo({ (success, data) in
            if success {
                self.stockQuotationItem = data
                if auto == true {
                    self.view?.notifyTimeSucess()
                }else {
                    self.view?.notifyFetchSuccess()
                }
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    func getHeaderStocks(auto:Bool)  {
        repository?.getHeaderStocks({ (success, data) in
            if success {
                self.optionalItem = data as! [OptionalItem]
                if auto == true {
                    self.view?.notifyTimeSucess()
                }else {
                    self.view?.notifyFetchSuccess()
                }
            }else {
                self.view?.notifyFetchFailure()
            }
        })
    }
    
    private lazy var dataList:[[String]] = {
        return self.repository!.getDataList()
    }()
}