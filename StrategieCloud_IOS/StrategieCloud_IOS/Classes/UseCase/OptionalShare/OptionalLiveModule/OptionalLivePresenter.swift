//
//  OptionalLivePresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class OptionalLivePresenter:OptionalLivePresenterProtocol {
    weak var view: OptionalLiveViewProtocol?
    var respository: OptionalLiveRepositoryProtocol?
	var liveMsg: LiveMsg?
	
	init(view: OptionalLiveViewProtocol){
        self.view = view
        respository = OptionalLiveRepository()
    }
    
    func numberOfRow()->Int {
		if let liveMsg_ = liveMsg {
            if let msgItems = liveMsg_.msgItems {
                return msgItems.count
            }
		}
        return 0
    }
    
    func setContentView(view:OptionalLiveDataSource,indexPath:NSIndexPath){
		if let liveMsg_ = liveMsg {
            if let msgItems = liveMsg_.msgItems {
                let item = msgItems[indexPath.row]
                view.setMessages(item.msgText)
                view.setTimeText(item.time)
                view.setMessageType(item.msgType)
            }
		}
    }
    
    func setContentToHeaderView(view:OptionalLiveHeaderViewDataSource){
		if let liveMsg_ = liveMsg {
            if let date = liveMsg_.date {
                view.set(date)
            }
		}
    }
    
    func getInventorymessage() {
        respository?.getInventorymessage({ (success, data) in
            if success {
				self.liveMsg = data
				self.view?.notifyFetchSuccess()
            }else{
                self.view?.notifyFetchFailure()
            }
        })
    }
}