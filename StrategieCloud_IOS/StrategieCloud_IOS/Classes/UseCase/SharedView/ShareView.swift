//
//  ShareView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import MonkeyKing
protocol ShareViewProtocol: NSObjectProtocol {
    func setTabbarState()
}

class ShareView: UIView {
    weak var shareVC: SetterViewController?
    var delegate: ShareViewProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        shareVC?.hidesBottomBarWhenPushed = true
        self.backgroundColor = UIColor.whiteColor()
        self.alpha = 1.0
        addSubview(cancleBtn)
        addSubview(qqShare)
        addSubview(wXShare)
        addSubview(qZoneShare)
        addSubview(frendShare)
        addSubview(shareLabel)
        addmakeConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addmakeConstraints()  {
        let width = CGFloat(55)
        let padding = (AppWidth - 4*width)/5

        cancleBtn.snp_makeConstraints { (make) in
           // make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
            make.width.equalTo(AppWidth)
            make.height.equalTo(30)
        }
        
        shareLabel.snp_makeConstraints { (make) in
            // make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self.cancleBtn.snp_top).offset(-1)
            make.width.equalTo(AppWidth)
            make.height.equalTo(0.5)
        }
        
         qqShare.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self).offset(padding)
            make.width.equalTo(width)
            make.height.equalTo(width)
        }
        
        qZoneShare.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self.qqShare.snp_right).offset(padding)
            make.width.equalTo(width)
            make.height.equalTo(width)
        }
        
        wXShare.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(self.qZoneShare.snp_right).offset(padding)
            make.width.equalTo(width)
            make.height.equalTo(width)
        }
        
        frendShare.snp_makeConstraints { (make) in
            make.top.equalTo(self).offset(15)
            make.left.equalTo(wXShare.snp_right).offset(padding)
            make.width.equalTo(width)
            make.height.equalTo(width)
        }
        
        self.qqShare.layoutButtonEdgeInsets(.MKButtonEdgeInsetsStyleTop, space: 10)
        self.wXShare.layoutButtonEdgeInsets(.MKButtonEdgeInsetsStyleTop, space: 10)
        self.qZoneShare.layoutButtonEdgeInsets(.MKButtonEdgeInsetsStyleTop, space: 10)
        self.frendShare.layoutButtonEdgeInsets(.MKButtonEdgeInsetsStyleTop, space: 10)
        
    }
	
	
	//============== added by dylan==
	func show() {
		self.superview?.insertSubview(bgBtn, belowSubview: self)
		UIView.animateWithDuration(0.2, animations: { () -> Void in
			self.frame.origin.y -= self.frame.size.height
		})
	}
	
	private lazy var bgBtn: UIButton = {
		let _bgBtn = UIButton(frame: CGRectMake(0, 0, AppWidth, AppHeight))
		_bgBtn.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
		_bgBtn.addTarget(self, action: #selector(ShareView.closeView), forControlEvents: UIControlEvents.TouchUpInside)
		return _bgBtn
	}()
	
	
	@objc private func closeView() {
		bgBtn.removeFromSuperview()
		UIView.animateWithDuration(0.2, animations: {
			self.frame.origin.y = AppHeight
			}) { (_) in
				self.removeFromSuperview()
		}
	}
	//==============
	
	
	
    func showShareView(rect: CGRect) {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.frame = rect
			
        })
         self.superview?.insertSubview(coverBtn, belowSubview: self)
    }
    
    func coverClick()  {
        hideShareView()
    }
    
    func hideShareView() {
        coverBtn.removeFromSuperview()
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.frame = CGRectMake(0, AppHeight, AppWidth, 200)
        }) { (finsch) -> Void in
            self.removeFromSuperview()
        }
        delegate?.setTabbarState()
        
    }
    //MainBounds
    private lazy var coverBtn: UIButton! = {
        let coverBtn = UIButton(frame: CGRectMake(0, 0, AppWidth, AppHeight-120))
        coverBtn.backgroundColor = UIColor.blackColor()
        coverBtn.alpha = 0.2
        coverBtn.addTarget(self, action: #selector(ShareView.coverClick), forControlEvents: UIControlEvents.TouchUpInside)
        return coverBtn
    }()
    
    private lazy var qqShare : UIButton = {
       let button = self.createButton("QQ好友")
        button.addTarget(self, action: #selector(shareToQq), forControlEvents: .TouchUpInside)
        button.setImage(UIImage.init(named: "qq@2x.png"), forState: .Normal)
        return button
    }()
    
    private lazy var wXShare : UIButton = {
        let button = self.createButton("微信好友")
        button.addTarget(self, action: #selector(shareToWx), forControlEvents: .TouchUpInside)
        button.setImage(UIImage.init(named: "ic_share_wx@2x.png"), forState: .Normal)
        return button
    }()
    
    private lazy var qZoneShare : UIButton = {
        let button = self.createButton("QQ空间")
        button.addTarget(self, action: #selector(shareToQqZone), forControlEvents: .TouchUpInside)
        button.setImage(UIImage.init(named: "qq_zone"), forState: .Normal)
        return button
    }()
    
    private lazy var frendShare : UIButton = {
        let button = self.createButton("朋友圈")
        let titleSize = button.titleLabel?.bounds.size
        let imageSize = button.imageView!.bounds.size
        let interval =  CGFloat(1.0)
        button.setImage(UIImage.init(named: "friends"), forState: .Normal)
        button.addTarget(self, action: #selector(shareToFriends), forControlEvents: .TouchUpInside)
        return button
    }()
    
    private lazy var qqShareLabel : UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var cancleBtn : UIButton = {
        let button = self.createButton("取消")
        button.setImage(UIImage.init(named: ""), forState: .Normal)
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.backgroundColor = UIColor.lightTextColor()
        button.addTarget(self, action: #selector(test), forControlEvents: .TouchUpInside)
        return button
    }()

    private lazy var shareLabel : UILabel = {
        let label = UILabel()
        //label.text = "分享至·····"
        label.backgroundColor = UIColor.lightGrayColor()
        return label
    }()
    
    func createButton(title: String)->UIButton{
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFontOfSize(13)
        btn.titleLabel?.textAlignment = .Center
        btn.setTitle(title, forState: .Normal)
         //btn.imageView?.contentMode = .Center
        //btn.imageView?.clipsToBounds = false
        btn.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        return btn
    }
    
    func createlabel(title:String)->UILabel {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        label.text = title
        label.textColor = UIColor.colorWith(30, green: 144, blue: 255, alpha: 1)
        return label
    }
    
    func test() {
        print(#function)
        hideShareView()
    }
    
    func shareToQq() {
        ShareTool.instance.shareToQq()
    }
    
    func shareToQqZone() {
        ShareTool.instance.shareToQqZone()
    }
    
    func shareToWx() {
        ShareTool.instance.shareToWeoXin()
    }
    
    func shareToFriends() {
        ShareTool.instance.shareToFriends()
    }
}
