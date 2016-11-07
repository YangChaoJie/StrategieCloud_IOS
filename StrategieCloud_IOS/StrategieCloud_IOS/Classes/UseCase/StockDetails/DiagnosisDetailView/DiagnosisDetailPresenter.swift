//
//  DiagnosisDetailPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class DiagnosisDetailPresenter:DiagnosisDetailPresenterProtocol {
    weak var view: DiagnosisDetailViewProtocol?
    var respository: DiagnosisDetailRepositoryProtocol?
    var diagnoseItem:DiagnoseItem?
    init(view:DiagnosisDetailViewProtocol){
        self.view = view
        respository = DiagnosisDetailRepository()
    }
    
    func isStragety()->Bool{
        if self.diagnoseItem?.dataform == "" {
            return false
        }
        return true
    }
    
    func numberOfSection()->Int{
        if let item = self.diagnoseItem {
            if item.dataform != ""{
                return 2
            }else{
                return 0
            }
        }else{
            return 0
        }
    }
    
    func setContentToView(view:StarBarDataSource){
        if let item = self.diagnoseItem {
            view.set(item.star)
            view.set(stragety: item.strategyName)
        }
    }
    
    func setContentToProfitView(section: Int, dataSource: ProfitTableViewCellDataSource){
        if let item = self.diagnoseItem {
            dataSource.profitValue(item.profit10, profit60: item.profit60, profit250: item.profit250)
        }
    }
    
    func setContentToChartView(section: Int, dataSource: StrategyChartTableViewCellDataSource){
        if let item = self.diagnoseItem {
            dataSource.backTestChartViewData(BackTestBean(data: item.dataform))
        }else{
            dataSource.backTestChartViewData(nil)
        }
    }
    
    func diagnosestock(stockCode:String){
        respository?.diagnosestock(stockCode, completion: { (success, data) in
            if success{
                let status = data!.valueForKeyPath("status") as! String
                if status == "success"{
                    let dataSource = data!.valueForKeyPath("data")
                    self.diagnoseItem = DiagnoseItem.init(data: dataSource!)
                    self.view?.notifyFetchSuccess()
                }else{
                    self.view?.notifyFetchFailure()
                }
            }else{
                self.view?.notifyFetchFailure()
            }
        })
    }
}