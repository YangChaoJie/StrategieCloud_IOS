//
//  ApplicationStrategyContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol ApplicationStrategyPageProtocol: class {
    // Presenter -> View
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func getDataToServer()
}

protocol ApplicationStrategyPresenterProtocol:class {
    var view:  ApplicationStrategyPageProtocol?{get set}
    func getStrategyWinInfo(stockCode:String)
    func numberOfSection()->Int
    func setDataToHeaderView(view:StrategyPageHeaderViewDataSource,section:Int)
    func settingUse(aowId:Int,code:String)
    
    func getStrategyChartInfo(aowId:Int)
    
    func setEachProfitContentToView(cell: StrategyIncomeCellDataSource,indexPath:NSIndexPath)
    func setBacktestChartContentToView(cell: StrategyChartCellDataSource,index:NSIndexPath)
}

protocol ApplicationStrategyRespositoryProtocol: class {
    func getStrategyWinInfo(option:String,completion: (success: Bool, data: AnyObject?) -> ())
    func settingStrategy(stocksCode: String,aowId: Int,completion: (success: Bool) -> ())
    func getStrategyAoeDetail(aowId:Int,completion: (success: Bool, data: StrategyChartItem?) -> ())
}