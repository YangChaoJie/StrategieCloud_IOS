//
//  incomeTopContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol IncomeTopViewProtocol:class {
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func skipToDetailView(roughStocks: [RoughStock],index: Int)
}

protocol IncomeTopPresenterProtocol:class {
    weak var view : IncomeTopViewProtocol? {get set}
    func getProfitRank()
    func numberOfRow(section: Int)-> Int
   // func setContentToCell(cell: IncomeTopDataSource,IndexPath: NSIndexPath)
    //func numberOfSection()-> Int
    
    func didSelectProfitItem(indexPath: NSIndexPath)
    //func didSelectIncomeDetailItem(indexPath: NSIndexPath)
    func getProfitRank(option:String)
    
    //func  numberOfRowOfMore(section: Int) -> Int
    //func setDataSourceToCellForMore(cell: IncomeTopDataSource,IndexPath: NSIndexPath)
    
    func getStrategyRank(option: String,period:String)
    
    func setContentToView(cell: ProfitCellDataSource, indexPath: NSIndexPath)
}

protocol IncomeTopRepositoryProtocol:class {
    func getProfitRank(completion: (success: Bool, data: AnyObject) -> ())
    
    func getProfitRankMore(option: String,completion: (success: Bool, data: AnyObject) -> ())
    
    func getStrategyRank(option: String,period:String,completion: (success: Bool, data: AnyObject) -> ())
   
}

protocol IncomeTopDataSource {
    func set(stockName name: String)
    func set(stockCode code: String)
    func set(percentage percentage: Double)
    func set(position position: Int)
    func set(rowId rowId: Int)
}