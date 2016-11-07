//
//  QuotationDetailPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
struct ConditionTag {
    static var riseTag = 0
}
class QuotationDetailPresenter: QuotationDetailPresenterProtocol {
    weak var view : QuotationDetailViewProtocol?
    var repository: QuotationDetailDataSourceProtocol?
    var detailItem : [[AnyObject]] = [[]]
    var title: String = ""
    init() {
        repository = QuotationDetailRepository()
    }
    
    func get(title:String) {
        self.title = title
    }
    
    func didSelectIncomeTopItem(indexPath: NSIndexPath) {
        var roughStocks: [RoughStock] = []
        let newDetailArray: [[AnyObject]] = getSortQuotationDetailStock(self.detailItem)
        for model in newDetailArray {
           let roughStock = RoughStock(name: model[1] as! String, code: model[0] as! String)
            roughStocks.append(roughStock)
        }
        self.view?.skipToDetailView(roughStocks, index: indexPath.row)
    }
    
    func numberOfItems(inSection section:Int) -> Int {
        if detailItem[0].count == 0 {
            return 0
        }
       return self.detailItem.count ?? 0
    }
    
    func setContentToView(cell: QuotationDataSource, indexPath: NSIndexPath,headName : String){
        let newDetailArray: [[AnyObject]] = getSortQuotationDetailStock(self.detailItem)
        if newDetailArray.count > 0 && newDetailArray[indexPath.row].count > 0 {
            let item = newDetailArray[indexPath.row]
            cell.set(stockName: item[1] as! String)
            cell.set(change: item[2] as! Double)
            cell.set(stockCode: item[0] as! String)
            cell.set(percentage: item[3] as! Double)
            cell.set(headName: headName)
        }
    }
    
    func setContentToIndustry(cell: IndustryDataSource, indexPath: NSIndexPath,headName : String) {
        let newDetailArray: [[AnyObject]] = getSortStock(self.detailItem)
        if newDetailArray.count > 0 && newDetailArray[indexPath.row].count > 0 {
            let item = newDetailArray[indexPath.row]
           
            cell.set(number: item[0] as! String)
            cell.set(industryName: item[1] as! String)
            cell.set(percentage: item[2] as! Double)
            cell.set(stockName: item[4] as! String)
            cell.set(headName: headName)
        }
    }
    
    func getSortStock(detailArray:[[AnyObject]]) -> [[AnyObject]] {
        var newArray : [[AnyObject]] = [[]]
        if ConditionTag.riseTag == PriceState.down.rawValue {
            newArray = self.detailItem.sort({ (left, right) -> Bool in
                left[2] as! Double > right[2] as! Double
            })
            return newArray
        }else {
            newArray = self.detailItem.sort({ (left, right) -> Bool in
                right[2] as! Double > left[2] as! Double
            })
            return newArray
        }
    }
    
    func getSortQuotationDetailStock(detailArray:[[AnyObject]]) -> [[AnyObject]] {
        var newArray : [[AnyObject]] = [[]]
        if ConditionTag.riseTag == RiseState.down.rawValue {
            if self.title == "equ_aes" {
                newArray = self.detailItem.sort({ (left, right) -> Bool in
                    fabs(left[3] as! Double) > fabs(right[3] as! Double)
                })
            }else{
                newArray = self.detailItem.sort({ (left, right) -> Bool in
                    left[3] as! Double > right[3] as! Double
                })
            }
            return newArray
        }else{
            if self.title == "equ_aes" {
                    newArray = self.detailItem.sort({ (left, right) -> Bool in
                        fabs(right[3] as! Double) > fabs(left[3] as! Double)
                    })
                }else{
                    newArray = self.detailItem.sort({ (left, right) -> Bool in
                        right[3] as! Double > left[3] as! Double
                    })
                }
                
            }
            return newArray
}

    //可以在这里加判断定时器的方法来区别显示
    func getMoreMarkInfo(option: String,auto: Bool) {
        repository?.getMoreMarKetInfo(option, completion: { (success, data) in
            if success {
                let status =  data!.valueForKeyPath("status") as! String
                if status == "success" {
                    let data = data!.valueForKeyPath("data") as! [[AnyObject]]
                    self.detailItem = data
                    if auto == true {
                        self.view?.notifyTimeSucess()
                    }else {
                        self.view?.notifyFetchSuccess()
                    }
                }else {
                    self.view?.notifyServerFailure()
                }
            }else {
               self.view?.notifyFetchFailure()
            }
        })
    }
}