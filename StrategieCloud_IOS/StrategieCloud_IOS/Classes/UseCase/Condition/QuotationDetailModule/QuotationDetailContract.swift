//
//  QuotationDetailContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol QuotationDetailViewProtocol: class {
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func notifyTimeSucess()
    func notifyServerFailure()
    func skipToDetailView(roughStocks: [RoughStock],index: Int)
}

protocol QuotationDetailPresenterProtocol : class {
    var view : QuotationDetailViewProtocol? {get set}
    func numberOfItems(inSection section:Int) -> Int
    func setContentToView(cell: QuotationDataSource, indexPath: NSIndexPath,headName : String)
    func setContentToIndustry(cell: IndustryDataSource, indexPath: NSIndexPath,headName : String)
    func getMoreMarkInfo(option: String,auto: Bool)
    func didSelectIncomeTopItem(indexPath: NSIndexPath)
    func get(title:String)
}

protocol QuotationDetailDataSourceProtocol  : class{
 //API
  func getIndustryInfo(info:String)
  func getMoreMarKetInfo(option:String,completion: (success: Bool, data: AnyObject?) -> ()) 
}

protocol IndustryDataSource {
    func set(stockName name: String)
    func set(stockCode code: String)
    func set(industryName name : String)
    func set(percentage percentage: Double)
    func set(headName name: String)
    func set(number number: String)
}