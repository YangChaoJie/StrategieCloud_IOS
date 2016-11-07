//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation

class MinePresenter: MinePresenterProtocol, MineInteractorOutputProtocol
{
    weak var view: MineViewProtocol?
    var interactor: MineInteractorInputProtocol?
    var wireFrame: MineWireFrameProtocol?
	
	private var ItemTitle = [
		["设置"],
		["分享APP", "给个好评", "意见反馈", "用户协议","一键加QQ群", "版本"]
	]
	
	enum SectionType: Int {
		case Set
		case Other
	}
	
	enum OtherType: Int {
		case ShareApp
		case GoodComment
		case FeedBack
		case UserAgreement
        case QqGroup
        case Version
	}
	
    
    init() {}
	
	func getSections() -> Int {
		return ItemTitle.count
	}
	
	func numberOfRowsInSection(section: Int) -> Int {
		return ItemTitle[section].count
	}
	
	func setCellContent(cell: MineViewCellDataSource, indexPath: NSIndexPath) {
		cell.setTitle(ItemTitle[indexPath.section][indexPath.row])
		cell.setImg(UIImage(named: ItemTitle[indexPath.section][indexPath.row]))
		
		if indexPath.section == 1 && indexPath.row == ItemTitle[1].count - 1 {
			cell.setSubTitle(SysUtils.appVersionNumber())
		}
	}
	
	func getVersionItemIndexPath() -> (section: Int, row: Int) {
		return (1, ItemTitle[1].count - 1)
	}
	
	func setNickNametoHeaderView(headerView: UserLoginViewDataSource) {
		if UserMannager.instance.getLoginStatues() {
			headerView.userLoginView(nickName: UserMannager.instance.getUserName())
		} else {
			headerView.userLoginView(nickName: nil)
		}
	}
    
    func presentLoginModule(controller: UINavigationController){
       if UserMannager.instance.getLoginStatues() == true {
            self.wireFrame?.presentUserInfoModule(controller)
        }else{
            self.wireFrame?.presentLoginModule(controller)
        }
        
    }
    
    func getUserInfo(headerView: UserLoginView) {
        interactor?.getUserInfo({ (success, nickName, avatarUrl) in
            if success {
                self.view?.setUserInfo(nickName, url: avatarUrl)
            }else {
                
            }
        })
    }
}