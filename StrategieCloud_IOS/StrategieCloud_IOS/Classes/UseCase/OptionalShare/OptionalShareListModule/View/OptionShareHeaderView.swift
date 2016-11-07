//
//  OptionShareHeaderView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/8/23.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol  OptionShareHeaderViewDelegate: class{
    func goToChangeView()
    func skipToDetailView(index:Int)
    func goToBsView()
}

protocol OptionalShareHeaderDataSources: class{
    func setItems(item:[OptionalItem])
    func setChangeState(state: Bool)
    func setBsState(state: Bool)
}

class OptionShareHeaderView: UIView,OptionalShareHeaderDataSources {
    @IBOutlet var view: UIView!
 //   @IBOutlet weak var changeLabel: UILabel!

   // @IBOutlet weak var bsView: UIView!
   // @IBOutlet weak var bsCircle: UIImageView!
    @IBOutlet weak var circle: UIImageView!
  
   // @IBOutlet weak var bsLabel: UILabel!
    @IBOutlet weak var changelabel: UILabel!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var shView: UIView!
    
    @IBOutlet weak var szView: UIView!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var shChangeLabel: UILabel!
    @IBOutlet weak var szNewPrice: UILabel!
    @IBOutlet weak var szChangeLabel: UILabel!
    
    @IBOutlet weak var changeView: UIView!
    weak var delegate: OptionShareHeaderViewDelegate?
    var items : [OptionalItem]?  {
        didSet {
         if items?.count > 0 {
            shChangeLabel.text =  String(format: "%.2f",(items![0].changePct as NSString).floatValue*100) + "%"
            
            newPriceLabel.text =  String(format: "%.2f",(items![0].lastPrice as NSString).floatValue)
            
            szNewPrice.text = String(format: "%.2f",(items![1].lastPrice as NSString).floatValue)
        
            szChangeLabel.text = String(format: "%.2f",(items![1].changePct as NSString).floatValue*100) + "%"
            
           //
            }
            setState()
        }
    }

    @IBAction func goToChangeView(sender: AnyObject) {
        delegate?.goToChangeView()
    }
    
    @IBOutlet weak var changeBtn: UIButton!
  
    @IBAction func bsTapAction(sender: AnyObject) {
      //  self.bsCircle.hidden = true
        delegate?.goToBsView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
        addTapAddGestureRecognizer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //layoutView()
    }
    
    func setState() {
       // bsLabel.adjustsFontSizeToFitWidth = true
        changelabel.adjustsFontSizeToFitWidth = true
        if let array = items {
         if array.count > 0 {
            if (array[0].changePct as NSString).floatValue  < 0 {
                shChangeLabel.textColor = UIColor.TextDownColor()
                newPriceLabel.textColor = UIColor.TextDownColor()
            }else {
                shChangeLabel.textColor = UIColor.TextUpColor()
                newPriceLabel.textColor = UIColor.TextUpColor()
            }
            
            if (array[1].changePct as NSString).floatValue  < 0 {
                szChangeLabel.textColor = UIColor.TextDownColor()
                szNewPrice.textColor = UIColor.TextDownColor()
            }else {
                szChangeLabel.textColor = UIColor.TextUpColor()
                szNewPrice.textColor = UIColor.TextUpColor()
            }
          }
        }
       
    }
    
    func addTapAddGestureRecognizer() {
        let tap = UITapGestureRecognizer(target:self, action:#selector(tapActionSh))
        let tap1 = UITapGestureRecognizer(target:self, action:#selector(tapActionSz))
        let changeTap =  UITapGestureRecognizer(target:self, action:#selector(tapActionChangeView))
        //let bsTap = UITapGestureRecognizer(target:self, action:#selector(tapActionBsView))
            
        self.userInteractionEnabled = true
        self.shView.addGestureRecognizer(tap1)
        self.szView.addGestureRecognizer(tap)
        self.changeView.addGestureRecognizer(changeTap)
        //self.bsView.addGestureRecognizer(bsTap)
    }
    
    func tapActionSh() {
        delegate?.skipToDetailView(1)
        print("\(#function) ")
    }
    
    func tapActionSz() {
        delegate?.skipToDetailView(0)
        print("\(#function) ")
    }
    
    func tapActionChangeView() {
         self.circle.hidden = true
         delegate?.goToChangeView()
    }
    
    func tapActionBsView() {
        //self.bsCircle.hidden = true
        delegate?.goToBsView()
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
    
    func setItems(item: [OptionalItem]) {
        self.items = item
    }
    
    func setChangeState(state: Bool){
        self.circle.hidden = !state
    }
    
    func setBsState(state: Bool) {
      //  self.bsCircle.hidden = !state
    }

}
