//
//  LoadingButton.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/10.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import SnapKit
class LoadingButton: UIButton {
    var block : InputClosureType?
    typealias InputClosureType = (Bool) -> ()
    var auto: Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.aActivityIndicator.hidden = true
        self.addTarget(self, action: #selector(loadingMore), forControlEvents: .TouchUpInside)
        addSubview(self.aActivityIndicator)
        addcomposition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadingMore(sender:UIControl,auto: Bool) {
        sender.enabled = false
        self.auto = auto
        self.setImage(nil, forState: .Normal)
        self.aActivityIndicator.hidden = false
        self.aActivityIndicator.startAnimating()
        //self.performSelector(#selector(performBlock), withObject: nil, afterDelay: 1)
        self.performSelector(#selector(performBlock), withObject: nil, afterDelay: 0.0)
        //performBlock(auto)
    }
    
    func addcomposition() {
        self.aActivityIndicator.snp_makeConstraints { (make) in
            make.width.equalTo(20)
            make.height.equalTo(20)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
    
    func performBlock() {
        if((self.block) != nil){
           self.block!(self.auto)
        }
         //sleep(1)
    }
    
    func lodingNot() {
        if (self.aActivityIndicator.isAnimating()) {
           self.aActivityIndicator.stopAnimating()
        }
        
        if (!self.aActivityIndicator.hidden) {
            self.aActivityIndicator.hidden = true
        }
        
        if (!self.enabled) {
            self.enabled = true;
        }

        self.setImage(UIImage.init(named: "iconfont-shuaxin"), forState: .Normal)
    }
    
    private lazy var aActivityIndicator : UIActivityIndicatorView =  {
        let activity = UIActivityIndicatorView()
        return activity
    }()
}
