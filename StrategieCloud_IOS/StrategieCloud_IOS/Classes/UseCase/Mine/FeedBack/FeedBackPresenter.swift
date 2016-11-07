//
//  FeedBackPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class FeedBackPresenter: FeedBackPresenterProtocol{
    var view: FeedBackViewProtocol?
    var repository: FeedBackRepositoryProtocol?
    init() {
        repository  = FeedBacKRepsitory()
    }
    
    func suggest(text: String) {
        repository?.suggest(text, completion: { (success, data) in
            if success {
                let status = data.valueForKey("status") as! String
                if status  == "success" {
                    // let result = data.valueForKey("data")
                    self.view?.comeBackToMineView()
                }
            }else {
                
            }
        })
    }
}