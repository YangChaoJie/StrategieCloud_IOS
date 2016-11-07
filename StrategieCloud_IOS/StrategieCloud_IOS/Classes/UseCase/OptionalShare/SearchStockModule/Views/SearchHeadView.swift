//
//  SearchHeadView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class SearchHeadView: UIView {
    @IBOutlet var view: UIView!
    @IBOutlet weak var hotLabel: UILabel!

   	override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        view.translatesAutoresizingMaskIntoConstraints = true
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: String(self.dynamicType), bundle: bundle)
        let nibView = nib.instantiateWithOwner(self, options: nil).first as! UIView
        
        return nibView
    }
}

