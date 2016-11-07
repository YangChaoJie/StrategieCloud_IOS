//
//  DiagnosisDetailContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol DiagnosisDetailViewProtocol:class{
    // Presenter -> View
    func notifyFetchSuccess()
    func notifyFetchFailure()
}

protocol DiagnosisDetailPresenterProtocol:class{
    var view:DiagnosisDetailViewProtocol?{get set}
    
    func diagnosestock(stockCode:String)
    func setContentToView(view:StarBarDataSource)
    func setContentToProfitView(section: Int, dataSource: ProfitTableViewCellDataSource)
    func setContentToChartView(section: Int, dataSource: StrategyChartTableViewCellDataSource)
    func isStragety()->Bool
    func numberOfSection()->Int
}

protocol DiagnosisDetailRepositoryProtocol:class{
    func diagnosestock(stockCode:String,completion: (success: Bool, data: AnyObject?) -> ())
}