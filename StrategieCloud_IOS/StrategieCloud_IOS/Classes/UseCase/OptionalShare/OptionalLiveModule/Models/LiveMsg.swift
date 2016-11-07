//
//  OptionalLiveItem.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

class LiveMsg: ResponseObjectSerializable {
	
	var date: String?
	var msgItems: [LiveMsgItem]?
	
	required init?(response: NSHTTPURLResponse, representation: AnyObject) {
		print("represention----\(representation)")
        if let data = representation.valueForKeyPath("data") as? NSDictionary {
            self.date = data.valueForKeyPath("create_date") as? String
            if let messageList = data.valueForKeyPath("message_list") {
                msgItems = LiveMsgItem.collection(response: response, representation: messageList)
            }
        }
		
        if date == nil && msgItems == nil {
            return nil
        }
	}
}

final class LiveMsgItem: ResponseCollectionSerializable, ResponseObjectSerializable {
	
	var time: String
	var msgText: String
	var msgType: Int
	
	init?(response: NSHTTPURLResponse, representation: AnyObject) {
		self.time = representation.valueForKeyPath("create_time") as? String ?? ""
		self.msgText = representation.valueForKeyPath("message_text") as? String ?? ""
		self.msgType = representation.valueForKeyPath("message_type") as? Int ?? 0
	}
	
	static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [LiveMsgItem] {
		var liveMsgItems = [LiveMsgItem]()
		if let representation_ = representation as? [NSDictionary] {
			for item in representation_ {
				liveMsgItems.append(LiveMsgItem(response: response, representation: item)!)
			}
		}
		
		return liveMsgItems
	}
}
