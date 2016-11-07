//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation
import Alamofire
class MineAPIDataManager: MineAPIDataManagerInputProtocol
{
    init() {}
    func getUserInfo(completion:(success: Bool , nickName : String, avatarUrl : String)->()){
        Alamofire.request(Router.getUserInfo).validate().responseJSON{response in
            switch response.result {
            case .Success(let value):
                let data = value.objectForKey("data")
                let   nickName = data!.objectForKey("nick_name") as? String ?? ""
                let   avatarUrl = data!.objectForKey("avatar_url") as? String ?? ""
                completion(success: true, nickName: nickName, avatarUrl : avatarUrl)
            case .Failure(let error):
                print("\(#function) error: \(error)")
            }
        }
    }
}