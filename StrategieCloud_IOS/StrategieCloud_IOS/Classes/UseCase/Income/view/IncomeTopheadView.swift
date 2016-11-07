//
//  IncomeTopheadView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/29.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol IncomeTopHeadViewDelegate:class {
    func skipToDetailView(title: String)
}
class IncomeTopHeadView : UIView{
    
    struct RankName {
      static let rank_10 = "10日收益榜"
      static let rank_60 = "60日收益榜"
      static let rank_250 = "250日收益榜"
    }
    
    struct StrategyName {
        static let one  = "H333稳健策略收益榜"
        static let two  =  "H333激进策略收益榜"
    }
    
    struct ImageName {
       static let rank_10 = "3"
       static let rank_60 = "2"
       static let rank_250 = "1"
    }
    
    var section: Int  = 0
    
    weak var delegate: IncomeTopHeadViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        addSubview(imageView)
        addSubview(rankName)
        addSubview(moreBtn)
        addmakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addmakeConstraints()  {
        imageView.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self)
            make.width.equalTo(6)
            make.height.equalTo(8)
        }
        
        rankName.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
            make.width.equalTo(150)
        }
        
        moreBtn.snp_makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(0)
            make.width.equalTo(40)
        }
    }
    
    func moreBtnClick(sender: UIButton) {
        if section == 0 {
           delegate?.skipToDetailView(StrategyName.one)
        }else {
           delegate?.skipToDetailView(StrategyName.two)
        }
    }
    
    func setContentToView(section: Int) {
        switch section {
        case 0:
            self.rankName.text = StrategyName.one
            self.imageView.image = UIImage.init(named: ImageName.rank_250)
        case 1:
            self.rankName.text = StrategyName.two
            self.imageView.image = UIImage.init(named: ImageName.rank_60)
        default:
            self.rankName.text = RankName.rank_10
            self.imageView.image = UIImage.init(named: ImageName.rank_10)
        }
        
        self.section = section
    }
    
    //MARK: - 懒加载控件
    private lazy var imageView : UIImageView = {
        let image = UIImageView()
        image.image = nil
        return image
    }()
    
    private lazy var rankName: UILabel = {
        let label = UILabel()
		label.textColor = UIColor.colorWith(53, green: 67, blue: 70, alpha: 1.0)
        label.font = UIFont.systemFontOfSize(13)
        return label
    }()
    
    private lazy var moreBtn: UIButton = {
        let btn = UIButton ()
        btn.setImage(UIImage.init(named: "ic_more"), forState: .Normal)
        btn.addTarget(self, action: #selector(moreBtnClick(_:)), forControlEvents: .TouchUpInside)
        return btn
    }()
}