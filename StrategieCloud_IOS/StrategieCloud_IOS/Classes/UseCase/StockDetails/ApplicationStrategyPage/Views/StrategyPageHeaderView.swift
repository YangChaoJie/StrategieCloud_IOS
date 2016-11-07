//
//  StrategyPageHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit


protocol  StrategyPageHeaderViewDelegate:class{
    func strategyPageHeaderViewDidClickBtn(headerView : StrategyPageHeaderView, isOpen: Bool,aowId:Int)
    func changeDataSource(aowId:Int,code:String)
}

protocol  StrategyPageHeaderViewDataSource{
    func setStarNumber(number number:Int)
    func setProfit(profit profit:Double)
    func set(name name: String)
    func set(use use:Bool)
    func set(aowId aowId:Int)
}

class StrategyPageHeaderView: UIView, StrategyPageHeaderViewDataSource{
    @IBOutlet var view: UIView!
    let defalutColor = UIColor.colorWith(70, green: 136, blue: 241, alpha: 1)
    @IBOutlet weak var useBtn: UIButton!
    @IBOutlet weak var starBar: RatingBar!

    @IBOutlet weak var upBtn: UIButton!
    @IBOutlet weak var strategyLabel: UILabel!
    @IBOutlet weak var persentageLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    var isExpend : Bool?
    var isOpen:NSMutableArray!
    var delegate: StrategyPageHeaderViewDelegate?
    
    var name: String = "" {
        didSet{
            self.strategyLabel.text = name
        }
    }
    
    var profit: Double = 0 {
        didSet{
            self.persentageLabel.text = String(format: "%.2f",profit*100) + "%"
            if profit > 0 {
                self.persentageLabel.textColor = UIColor.TextUpColor()
            }else {
                self.persentageLabel.textColor = UIColor.TextDownColor()
            }
        }
    }
  
    var star: Int = 0 {
        didSet{
            starBar.ratingMax = CGFloat(star)
           
        }
    }
    
    var isUsing : Bool = false {
        didSet{
            self.useBtn.enabled = !isUsing
            setUseBtnState(useBtn)
        }
    }
    
    var aowId: Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        setBtnStatus()
        addTapAddGestureRecognizer()
    }
    
    func addTapAddGestureRecognizer() {
        let tap = UITapGestureRecognizer(target:self, action:#selector(ConditionTableHeadView.headerBtnClick(_:)))
        self.userInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    func setBtnStatus() {
        //setUseBtnState(useBtn)
        upBtn.imageView?.contentMode = .Center
        upBtn.imageView?.clipsToBounds = false
        starBar.userInteractionEnabled = false
    }
    
    func setUseBtnState(button: UIButton) {
        useBtn.titleLabel?.textAlignment = .Center
        useBtn.layer.cornerRadius = 6.0
        useBtn.layer.borderWidth = 1.0
        if useBtn.enabled == true {
            useBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
            useBtn.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            useBtn.setTitle("应用", forState: .Normal)
        }else {
            useBtn.layer.borderColor = defalutColor.CGColor
            useBtn.setTitleColor(defalutColor, forState: .Disabled)
            useBtn.setTitle("应用中", forState: .Disabled)
        }
    }
    
    func headerBtnClick(sender: UIButton)  {
       clickAction()
        
    }
    
    @IBAction func upAction(sender: AnyObject) {
       clickAction()
    }
    
    @IBAction func userAction(sender: AnyObject) {
        if useBtn.enabled == true {
            delegate?.changeDataSource(aowId, code: "")
            useBtn.enabled = false
        }
        setUseBtnState(useBtn)
    }
    
    func clickAction() {
        let index = self.tag
        isExpend = isOpen[index] as? Bool
        isExpend = !isExpend!
        delegate?.strategyPageHeaderViewDidClickBtn(self , isOpen: isExpend!,aowId: aowId)
    }
    
    func setBtnClick(isOpen : Bool) {
        if isOpen == false {
          self.upBtn.imageView?.transform = CGAffineTransformMakeRotation(0)
        } else {
          self.upBtn.imageView?.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
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
    //MARK: DataSourcedelegate
    func set(use use: Bool) {
        self.isUsing = use
    }
    
    func set(aowId aowId: Int) {
        self.aowId = aowId
    }
    
    func set(name name: String) {
        self.name = name
    }
    
    func setProfit(profit profit: Double) {
        self.profit = profit
    }
    
    func setStarNumber(number number: Int) {
        self.star = number
    }
    
}
