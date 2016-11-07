//
//  RatingBar.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/21.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

//@IBDesignable
class RatingBar: UIView {

	@IBInspectable var  ratingMax: CGFloat = 10	//总分
	@IBInspectable var starNums: Int = 5		//星星总数
	//分数
	@IBInspectable var rating: CGFloat = 0 {
		didSet {
			if 0 > rating { rating = 0 }
			else if ratingMax < rating { rating = ratingMax }
			//回调给代理
			self.setNeedsLayout()
		}
	}
	
	@IBInspectable var imageLight: UIImage = UIImage(named: "ratingbar_star_light")!
	@IBInspectable var imageDark: UIImage = UIImage(named: "ratingbar_star_dark")!
	
	@IBInspectable var canAnimation: Bool = false	//是否开启动画模式
	@IBInspectable var animationTimeInterval: NSTimeInterval = 0.2 //动画时间
	@IBInspectable var isIndicator: Bool = false	//是否是一个指示器 (用户无法进行更改)
	
	private var foregroundRatingView: UIView!
	private var backgroundRatingView: UIView!
	
	private var isDrew = false	//是否创建过

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.buildView()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.buildView()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		buildView()
		let animationTimeInterval = self.canAnimation ? self.animationTimeInterval : 0
		UIView.animateWithDuration(animationTimeInterval) { 
			self.animationRatingChange()
		}
	}
	
	// 根据图片名，创建一列RatingBar
	private func createRatingView(image: UIImage) -> UIView {
		let view = UIView(frame: self.bounds)
		view.clipsToBounds = true
		view.backgroundColor = UIColor.clearColor()
		
		for position in 0 ..< starNums {
			let imageView = UIImageView(image: image)
			imageView.frame = CGRectMake(CGFloat(position) * self.bounds.size.width / CGFloat(starNums), 0,
			                             self.bounds.size.width / CGFloat(starNums), self.bounds.size.height)
			imageView.contentMode = UIViewContentMode.ScaleAspectFit
			view.addSubview(imageView)
		}
		return view
	}
	
	private func buildView() {
		if isDrew {
			return
		}
		isDrew = true
		self.backgroundRatingView = self.createRatingView(imageDark)
		self.foregroundRatingView = self.createRatingView(imageLight)
		animationRatingChange()
		self.addSubview(self.backgroundRatingView)
		self.addSubview(self.foregroundRatingView)
		//加入单击手势
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RatingBar.tapRateView(_:)))
		tapGesture.numberOfTapsRequired = 1
		self.addGestureRecognizer(tapGesture)
	}
	
	//改变foregroundRatingView可见范围
	private func animationRatingChange() {
		let realRatingScore = self.rating / self.ratingMax
		self.foregroundRatingView.frame = CGRectMake(0, 0, self.bounds.size.width * realRatingScore, self.bounds.size.height)
	}
	
	@objc private func tapRateView(sender: UITapGestureRecognizer) {
		if isIndicator { return }
		let tapPoint = sender.locationInView(self)
		let offset = tapPoint.x
		//通过x坐标判断分数
		let realRatingScore = offset / (self.bounds.size.width / self.ratingMax)
		self.rating = round(realRatingScore)
	}
}
