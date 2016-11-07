//
//  ProfitTableHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/26.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol  ProfitTableHeaderViewDelegate:NSObjectProtocol{
    func skipSearchStockView()
}
class ProfitTableHeaderView: UIView {
    @IBOutlet weak var diaBtn: UIButton!
    @IBOutlet var view: UIView!
    weak var delegate: ProfitTableHeaderViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        setButtonState()
    }
    
    private func  setButtonState() {
        self.diaBtn.setTitle("诊股", forState: .Normal)
        self.diaBtn.setTitleColor(UIColor.NavBarColor(), forState: .Normal)
        self.diaBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.diaBtn.layoutButtonEdgeInsets(.MKButtonEdgeInsetsStyleLeft , space: 7)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    @IBAction func clickedAction(sender: AnyObject) {
        delegate?.skipSearchStockView()
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
