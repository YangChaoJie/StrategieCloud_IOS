//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation
import UIKit
import MonkeyKing
import Kingfisher

class MineView: BaseVC, MineViewProtocol {
	
	var presenter: MinePresenterProtocol?
	
	struct Nib {
		static let CellName = "MineViewCell"
	}
	
	struct Cell {
		static let CellID = "MineViewCellID"
	}
	
	let TableInsetHeight = CGFloat(160)
	var titleLabelAlpha = CGFloat(0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		let image = UIImage(named: "ic_mine_line")
		self.navigationController?.navigationBar.setBackgroundImage(image!, forBarMetrics: .Default)
		self.navigationController?.navigationBar.shadowImage = image
		self.navigationItem.titleView = titleLabel
		view.backgroundColor = UIColor.colorWith(240, green: 244, blue: 255, alpha: 1.0)
		view.addSubview(tableView)
		tableView.addSubview(headerView)
		titleLabel.alpha = titleLabelAlpha
        self.pageName = "我的"
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		titleLabel.hidden = true
		headerView.avatarImg.kf_setImageWithURL(NSURL(string: UserMannager.instance.getAvatarUrl())!, placeholderImage: Image(named: "默认头像"), optionsInfo: [.TargetCache(StrategyCloudAvatarCache)])
		
		presenter?.setNickNametoHeaderView(headerView)
        if UserMannager.instance.getLoginStatues() {
           presenter?.getUserInfo(headerView)
        }
	}
	
	// MARK: - MineViewProtocol
	func setUserInfo(name: String, url: String) {
		UserMannager.instance.setUserName(name)
		headerView.nickNameLabel.text = name
		if url != UserMannager.instance.getAvatarUrl() {
			UserMannager.instance.setAvatarUrl(url)
			headerView.avatarImg.kf_setImageWithURL(NSURL(string: url)!, placeholderImage: Image(named: "默认头像"), optionsInfo: [.TargetCache(StrategyCloudAvatarCache), .ForceRefresh ])
		}
	}
	
	// MARK: - Private Method
	private func showShareView() {
		view.window?.addSubview(shareView)
		shareView.show()
	}
    
	private func goAppStore() {
		UIApplication.sharedApplication().openURL(NSURL(string: "itms://itunes.apple.com/cn/app/id1126244276?mt=8")!)
	}
	
	private func feedback() {
		self.navigationController?.pushViewController(FeedBackView(), animated: true)
	}
	
	private func userAgreement() {
		self.navigationController?.pushViewController(ProtocolView(), animated: true)
	}
	
	private func enterSetting() {
		let settingVC = SetterViewController()
		settingVC.title = "设置"
		self.navigationController?.pushViewController(settingVC, animated: true)
	}
    
    private func addQqGroup() {
        joinGroup("583214401", key: "ded3bbde5d64dac79d30ae2b9423951ee18baf673d9e288a02869a6407d2ea6b")
    }
    
    private func joinGroup(groupUin: String, key:String) {
        let string = String(format: "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external",groupUin,key)
        let urlString = NSURL(string: string)
        
        if UIApplication.sharedApplication().canOpenURL(urlString!) {
            UIApplication.sharedApplication().openURL(urlString!)
		} else {
			helper.alertShow("请添加\(groupUin)QQ群！")
		}
    }
	
	private lazy var tableView: UITableView = {
		let frame = CGRectMake(0, 0, AppWidth, AppHeight-NavigationH-TabH)
		let _tableView = UITableView(frame: frame, style: UITableViewStyle.Grouped)
		_tableView.separatorStyle = .None
		_tableView.registerNib(UINib(nibName: Nib.CellName, bundle: nil), forCellReuseIdentifier: Cell.CellID)
		_tableView.contentInset = UIEdgeInsetsMake(self.TableInsetHeight, 0, 0, 0)
		_tableView.dataSource = self
		_tableView.delegate = self
		return _tableView
	}()

	private lazy var headerView: UserLoginView = {
		let _headerView = UserLoginView(frame: CGRectMake(0, -self.TableInsetHeight, self.view.frame.width, self.TableInsetHeight))
		_headerView.delegate = self
		_headerView.contentMode = .ScaleAspectFill
		_headerView.tag = 1001
		_headerView.backgroundColor = UIColor.NavBarColor()
		return _headerView
	}()
	
	private lazy var titleLabel: UILabel = {
		let _label = UILabel()
		_label.frame = CGRectMake(0, 0, 100, 30)
		_label.textColor = UIColor.whiteColor()
		_label.textAlignment = .Center
		_label.text = "我的"
		return _label
	}()
	
	private lazy var shareView: PopupShareView = {
		let view = PopupShareView(frame: CGRectMake(0, AppHeight, AppWidth, CGFloat(120)))
		view.delegate = self
		return view
	}()
}

extension MineView: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		if section == 0 {
			return CGFloat(15)
		}
		return CGFloat.min
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		if section == 0 {
			return CGFloat(15)
		}
		return CGFloat.min
	}
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return (presenter?.getSections())!
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return (presenter?.numberOfRowsInSection(section))!
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(Cell.CellID, forIndexPath: indexPath) as! MineViewCell
		presenter?.setCellContent(cell, indexPath: indexPath)
		let versionIndexPath = presenter?.getVersionItemIndexPath()
		if indexPath.section == versionIndexPath?.section && indexPath.row == versionIndexPath?.row {
			cell.selectionStyle = UITableViewCellSelectionStyle.None
		}
		return cell
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		switch indexPath.section {
		case MinePresenter.SectionType.Set.rawValue:
			self.enterSetting()
		case MinePresenter.SectionType.Other.rawValue:
			switch indexPath.row {
			case MinePresenter.OtherType.ShareApp.rawValue:
				self.showShareView()
			case MinePresenter.OtherType.GoodComment.rawValue:
				self.goAppStore()
			case MinePresenter.OtherType.FeedBack.rawValue:
				self.feedback()
			case MinePresenter.OtherType.UserAgreement.rawValue:
				self.userAgreement()
            case MinePresenter.OtherType.QqGroup.rawValue:
                self.addQqGroup()
			default:
				break
			}
		default:
			break
		}
	}
}

// MARK: -PopupShareViewDelegate
extension MineView: PopupShareViewDelegate {
	func popupShareViewShare(platformType: PopupShareView.PlatformType) {
		let shareInfo = MonkeyKing.Info(
			title: "兵法云－运筹帷幄，决胜千里",
			description: "赚钱的炒股兵法",
			thumbnail: UIImage(named: "shareAppIcon")!,
			media: .URL(NSURL(string: "\(Router.baseShareImgUrl)2222223.jpg")!)
		)

		var message: MonkeyKing.Message?
		switch platformType {
		case .QQfriend:
			message = MonkeyKing.Message.QQ(.Friends(info: shareInfo))
		case .QQZone:
			message = MonkeyKing.Message.QQ(.Zone(info: shareInfo))
		case .WXfriend:
			message = MonkeyKing.Message.WeChat(.Session(info: shareInfo))
		case .WXCircleFriend:
			message = MonkeyKing.Message.WeChat(.Timeline(info: shareInfo))
		}

		if let msg = message {
			MonkeyKing.shareMessage(msg, completionHandler: { (result) in
				if !result {
					print("分享失败")
				}
			})
		}
	}
}

extension MineView: UserLoginViewDelegate {
	func userLoginViewDelegateClick() {
		presenter?.presentLoginModule(self.navigationController!)
	}
}

extension MineView: UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if titleLabel.hidden {
			titleLabel.hidden = false
		}
		
		let point = scrollView.contentOffset
		if point.y < -self.TableInsetHeight {
			var rect = self.tableView.viewWithTag(1001)?.frame
			rect?.origin.y = point.y
			rect?.size.height = -point.y
			self.tableView.viewWithTag(1001)?.frame = rect!
		}
		
		titleLabelAlpha = (point.y + 64) / (self.TableInsetHeight - 64) + 1
		self.titleLabel.alpha = titleLabelAlpha
	}
}
    
