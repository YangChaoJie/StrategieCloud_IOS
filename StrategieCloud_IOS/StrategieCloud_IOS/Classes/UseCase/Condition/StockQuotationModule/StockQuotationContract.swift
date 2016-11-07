//
//  StockQuotationContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/19.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol StockQuotationViewProtocol: class {
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func notifyTimeSucess()
    func skipToDetailView(roughStocks: [RoughStock],index: Int)
}

protocol StockQuotationPresenterProtocol : class {
    var view : StockQuotationViewProtocol? {get set}
    func numberOfItems(inSection section:Int) -> Int
    func setContentToView(cell: QuotationDataSource, indexPath: NSIndexPath)
    func setDataOfHeader(view: QuotationHeaderDataSource ,index : Int)
    func setDataOfIndustry(view: IndustrynDataSource ,index : Int,section: Int)
    func getMarketInfo(auto:Bool)
    func getHeaderStocks(auto:Bool)
    func getDataList()->[[String]]
    
    func didSelectStockQuotationItem(indexPath: NSIndexPath)
    func didSelectStockQuotationHeader(index: Int)
}


protocol StockQuotationDataSourceProtocol  : class{
    //API
    func getMarketInfo(completion: (success: Bool, data: StockQuotationItem?) -> ())
    
    func getHeaderStocks(completion: (success: Bool, data: AnyObject) -> ())
    
    func getDataList()->[[String]]
}

protocol  QuotationHeaderDataSource : class{
    func set(stockName name: String)
    func set(change change: String)
    func set(trend trend: Int)
    func set(status status: Int)
    func set(changePct changePct: String)
    func set(lastPrice price: String)
}

protocol IndustrynDataSource {
    func set(stockName name: String)
    func set(change change: Double)
    func set(industryName name: String)
    func set(changePct changePct: Double)
    func set(percentage percentage: Double)
    func set(number number:String)
}

protocol QuotationDataSource {
    func set(stockName name: String)
    func set(stockCode code: String)
    func set(change change: Double)
    func set(percentage percentage: Double)
    func set(headName name: String)
}