//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

class MineInteractor: MineInteractorInputProtocol
{
    weak var presenter: MineInteractorOutputProtocol?
    var APIDataManager: MineAPIDataManagerInputProtocol?
    var localDatamanager: MineLocalDataManagerInputProtocol?
    
    init() {}
   
    func getUserInfo(completion:(success: Bool , nickName : String, avatarUrl : String)->()) {
       APIDataManager?.getUserInfo({ (success, nickName, avatarUrl) in
           if success {
              completion(success: true, nickName: nickName, avatarUrl : avatarUrl)
           }
       })
    }
}