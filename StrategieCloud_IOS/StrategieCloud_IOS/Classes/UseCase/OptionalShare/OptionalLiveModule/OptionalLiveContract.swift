//
//  OptionalLiveContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol  OptionalLivePresenterProtocol: class{
    var view:OptionalLiveViewProtocol?{get set}
    // View -> Presenter
    func getInventorymessage()
    func numberOfRow()->Int
    func setContentView(view:OptionalLiveDataSource,indexPath:NSIndexPath)
    func setContentToHeaderView(view:OptionalLiveHeaderViewDataSource)
}

protocol  OptionalLiveViewProtocol:class{
    // Presenter -> View
    
    func notifyFetchSuccess()
    func notifyFetchFailure()
}

protocol OptionalLiveRepositoryProtocol:class {
    // Presenter -> Respository
    func getInventorymessage(completion: (success: Bool, data: LiveMsg?) -> ())
}