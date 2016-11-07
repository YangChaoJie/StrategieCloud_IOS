//
//  OptionShareEmptyView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/10.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit


protocol SearchStockDelegate: class {
    func SearchStock()
}
class OptionShareEmptyView: UIView {
    weak var delegate: SearchStockDelegate?
    @IBOutlet var view: UIView!
  
    @IBAction func addStock(sender: AnyObject) {
        delegate?.SearchStock()
    }
    
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
