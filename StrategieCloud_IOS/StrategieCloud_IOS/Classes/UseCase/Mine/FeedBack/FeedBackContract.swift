//
//  FeedBackContract.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
protocol FeedBackViewProtocol:class {
    func comeBackToMineView()
}

protocol FeedBackPresenterProtocol:class {
    weak var view: FeedBackViewProtocol? {get set}
    func suggest(text: String)
}

protocol FeedBackRepositoryProtocol:class {
    func suggest(text: String,completion:(success: Bool, data: AnyObject)->())
}