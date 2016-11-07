//
//  OptionalBsContact.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/9/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol OptionBsViewProtocol: class {
    // Presenter -> View
    func notifyFetchSuccess()
    func notifyFetchFailure()
    func skipToDetailView(roughStocks: [RoughStock],index: Int)
}

protocol OptionBsPresenterProtocol:class {
    var view: OptionBsViewProtocol?{get set}
    func getChangeDataSourceToServer()
    func numberOfSection()->Int
    func numberOfRow(section:Int)->Int
    func setDataToCell(cell:OptionBsCellDataSource,indexPath:NSIndexPath)
    
    func setDataToHeaderView(view: OptionBsHeaderViewDataSource,section: Int)
    func didSelectItem(indexPath:NSIndexPath)
}




protocol OptionBsRespositoryProtocol: class {
    func getChosenAlert(completion: (data: [BsItem]?,success: Bool) -> ())
}