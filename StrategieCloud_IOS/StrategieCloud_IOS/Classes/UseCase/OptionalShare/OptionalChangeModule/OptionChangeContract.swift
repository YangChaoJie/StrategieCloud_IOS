//
//  OptionChangeContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol OptionChangeViewProtocol: class {
    // Presenter -> View
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func skipToDetailView(roughStocks: [RoughStock],index: Int)
}

protocol OptionChangePresenterProtocol:class {
    var view: OptionChangeViewProtocol?{get set}
    func getChangeDataSourceToServer()
    func numberOfSection()->Int
    func numberOfRow(section:Int)->Int
    func setDataToCell(cell:OptionChangeCellDataSource,indexPath:NSIndexPath)
    
    func setDataToHeaderView(view: OptionChangeHeaderViewDataSource,section: Int)
    func didSelectItem(indexPath:NSIndexPath)
}

protocol OptionChangeRespositoryProtocol: class {
    func getChosenAlert(completion: (data: [ChangeItem]?,success: Bool) -> ())
}