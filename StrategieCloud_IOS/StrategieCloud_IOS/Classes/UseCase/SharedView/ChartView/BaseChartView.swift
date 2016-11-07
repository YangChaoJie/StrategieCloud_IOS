//
//  BaseChartView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

enum StrategyType: Int {
	case None
	case Steady		//稳健
	case Radical	//激进

	func color() -> UIColor {
		switch self {
		case .None:
			return UIColor.colorWith(150, green: 166, blue: 178, alpha: 0.8)
		case .Radical:
			return UIColor.colorWith(254, green: 40, blue: 81, alpha: 0.8)
		case .Steady:
			return UIColor.colorWith(84, green: 199, blue: 252, alpha: 0.8)
		}
	}
}

protocol BaseChartViewDelegate: class {
	func shieldViewClick()
	func strategyBtnClick()
}

class BaseChartView: UIView {
	private static let TopInfoViewHeight = CGFloat(20)
	private let ShieldWidth = CGFloat(80)
	
	private var topViewType: BaseTopInfoView.ViewType!
	private var mKlineIndexView: TopDisplayWithTitleView!
	
	weak var delegate: BaseChartViewDelegate?
	
	var chartViewData: CombinedChartData? {
		didSet {
			combinedChartView.data = chartViewData
			combinedChartView.notifyDataSetChanged()
		}
	}

	init(frame: CGRect, viewType: BaseTopInfoView.ViewType) {
		super.init(frame: frame)
		self.topViewType = viewType
		self.commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func enableDrawXLabels(enable: Bool) {
		let xAxis = combinedChartView.xAxis
		xAxis.drawLabelsEnabled = enable
	}

	func zoom(scaleX: CGFloat, scaleY: CGFloat, dX: CGFloat, dY: CGFloat) {
		self.combinedChartView.zoom(scaleX, scaleY: scaleY, x: dX, y: dY)
	}

	func setHighlightValue(highlight highlight: ChartHighlight?, callDelegate: Bool) {
		if let _ = chartViewData {
			if let _highlight = highlight {
				self.combinedChartView.highlightValue(xIndex: _highlight.xIndex, dataSetIndex: 0, callDelegate: callDelegate)
			} else {
				self.combinedChartView.highlightValue(highlight: nil, callDelegate: callDelegate)
			}
		}
	}
	
	func chartViewStartAtZero() {
		let leftAxis = combinedChartView.leftAxis
		let rightAxis = combinedChartView.rightAxis
		
		leftAxis.startAtZeroEnabled = true
		rightAxis.startAtZeroEnabled = true
	}
	
	func customRightAxisVal(value: [Double]) {
		let rightAxis = self.combinedChartView.rightAxis
		if value.count == 2 {
			rightAxis.customAxisMin = value[0]
			rightAxis.customAxisMax = value[1]
			combinedChartView.notifyDataSetChanged()
		}
	}
	
	func setLabelCount(count: Int) {
		let leftAxis = self.combinedChartView.leftAxis
		let rightAxis = self.combinedChartView.rightAxis
		
		leftAxis.setLabelCount(count, force: true)
		rightAxis.setLabelCount(count, force: true)
	}
	
	func enableScaleX(enable: Bool) {
		combinedChartView.scaleXEnabled = enable
	}
	
	func setTopBottomSpaceToZero() {
		let leftAxis = self.combinedChartView.leftAxis
		let rightAxis = self.combinedChartView.rightAxis

		leftAxis.spaceTop = 0
		leftAxis.spaceBottom = 0
		rightAxis.spaceTop = 0
		rightAxis.spaceBottom = 0
	}

	func setCustomYAxis(state: Bool) {
		let leftAxis = self.combinedChartView.leftAxis
		let rightAxis = self.combinedChartView.rightAxis
		
		leftAxis.customAxis = state
		rightAxis.customAxis = state
	}
	
	func customXAxisLabelModules(labelCount: Int) {
		let xAxis = combinedChartView.xAxis
		xAxis.setLabelsToSkip(labelCount)
	}
	
	func setTopInfoView(withData data: [ExternalData]) {
		topDisplayInfoView.setLabels(data)
	}
	
	func disableRightAxis() {
		let rightAxis = combinedChartView.rightAxis
		rightAxis.enabled = false
	}
	
	func showViewWithAnimate(show: Bool, view: UIView) {
		if show {
			UIView.animateWithDuration(0.25, animations: {
				view.frame.origin.x -= self.ShieldWidth
			})
		} else {
			UIView.animateWithDuration(0.25, animations: {
				view.frame.origin.x += self.ShieldWidth
			})
		}
	}
	
	func clickShieldView(sender: UIButton) {
		delegate?.shieldViewClick()
	}
	
	func needScaleToDefault() {
		combinedChartView.needScaleToDefault = true;
	}
	
	func notifyRefresh() {
		if let _ = combinedChartView.data {
			combinedChartView.notifyDataSetChanged()
		}
	}
	
	func restoreToDefaultScaleFactor() {
		combinedChartView.restoreToDefaultScaleFactor()
		combinedChartView.setNeedsLayout()
	}

	func setViewPortBottomOffsets(bottom: CGFloat) {
		combinedChartView.setViewPortOffsets(left: CGFloat(10), top: CGFloat(10), right: CGFloat(10), bottom: bottom)
	}
	
	// MARK: - Private Method
	private let btnWH = CGFloat(32)

	private func commonInit() {
		self.addSubview(topDisplayInfoView)
		self.addSubview(combinedChartView)

		combinedChartView.snp_makeConstraints { (make) in
			make.edges.equalTo(self).inset(UIEdgeInsets(top: BaseChartView.TopInfoViewHeight, left: 0, bottom: 0, right: 0))
		}

		topDisplayInfoView.snp_makeConstraints { (make) in
			make.leading.top.trailing.equalTo(self)
			make.height.equalTo(BaseChartView.TopInfoViewHeight)
		}

		if self.topViewType == BaseTopInfoView.ViewType.KLine {
			self.addSubview(strategyBtn)

			strategyBtn.snp_makeConstraints(closure: { (make) in
				make.bottom.trailing.equalTo(combinedChartView).offset(-14)
				make.width.height.equalTo(btnWH)
			})
//			self.addSubview(shieldView)
		}
	}

	func strategyBtnClick() {
		delegate?.strategyBtnClick()
	}

	func setStrategyBtnType(type: StrategyType) {
		strategyBtn.backgroundColor = type.color()
		switch type {
		case .None:
			strategyBtn.setImage(UIImage(named: "icon_strategy_btn_white_1"), forState: UIControlState.Normal)
		case .Radical:
			fallthrough
		case .Steady:
			strategyBtn.setImage(UIImage(named: "icon_strategy_btn_white"), forState: UIControlState.Normal)
		}
	}

	func setKlineIndexTitle(indexType: CompositeChartView.KLineIndexType) {
		if (indexType == CompositeChartView.KLineIndexType.Volume) {
			mKlineIndexView.titleBtn.setTitle("成交量", forState: UIControlState.Normal)
		} else {
			mKlineIndexView.titleBtn.setTitle(indexType.rawValue, forState: UIControlState.Normal)
		}
	}

	// MARK: - Setter And Getter
	private lazy var strategyBtn: UIButton = {
		let btn = UIButton()
		let margin = CGFloat(14)
		btn.layer.cornerRadius =  self.btnWH / 2
		btn.backgroundColor = StrategyType.None.color()
		btn.setImage(UIImage(named: "icon_strategy_btn_white_1"), forState: UIControlState.Normal)
//		btn.setTitle("策略", forState: UIControlState.Normal)
//		btn.titleLabel?.font = UIFont.systemFontOfSize(12)
		btn.addTarget(self, action: #selector(BaseChartView.strategyBtnClick), forControlEvents: UIControlEvents.TouchUpInside);
		return btn;
	}()

	private lazy var topDisplayInfoView: BaseTopInfoView = {
		if self.topViewType == BaseTopInfoView.ViewType.TimeSharedLine {
			let _topDisplayInfoView = TopDisplayInfoView()
			_topDisplayInfoView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: BaseChartView.TopInfoViewHeight)
			return _topDisplayInfoView
		} else {
			let _topDisplayInfoView = TopDisplayWithTitleView()
			_topDisplayInfoView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: BaseChartView.TopInfoViewHeight)
			if self.topViewType == BaseTopInfoView.ViewType.KLine {
				_topDisplayInfoView.titleBtn.setTitle("日线", forState: UIControlState.Normal)
			}
			if self.topViewType == BaseTopInfoView.ViewType.KLineVolume {
				_topDisplayInfoView.titleBtn.setTitle("成交量", forState: UIControlState.Normal)
			}
			self.mKlineIndexView = _topDisplayInfoView
			return _topDisplayInfoView
		}
	}()

	lazy var combinedChartView: CombinedChartView = {
		let _combinedChartView = CombinedChartView()
		_combinedChartView.frame = CGRect(x: 0, y: BaseChartView.TopInfoViewHeight,
		                                  width: self.bounds.width,
		                                  height: self.bounds.height - BaseChartView.TopInfoViewHeight)
		_combinedChartView.drawOrder = [
			CombinedChartView.CombinedChartDrawOrder.Bar.rawValue,
			CombinedChartView.CombinedChartDrawOrder.Candle.rawValue,
			CombinedChartView.CombinedChartDrawOrder.Line.rawValue,
			CombinedChartView.CombinedChartDrawOrder.Bubble.rawValue,
			CombinedChartView.CombinedChartDrawOrder.Scatter.rawValue
		]

		_combinedChartView.autoScaleMinMaxEnabled = true
		_combinedChartView.doubleTapToZoomEnabled = false
		_combinedChartView.descriptionText = ""
		_combinedChartView.drawBordersEnabled = true
		_combinedChartView.drawBarShadowEnabled = false
		_combinedChartView.scaleYEnabled = false

		let leftAxis = _combinedChartView.leftAxis
		leftAxis.labelPosition = ChartYAxis.YAxisLabelPosition.InsideChart
		leftAxis.drawGridLinesEnabled = true
		leftAxis.drawAxisLineEnabled = false
		leftAxis.zeroLineWidth = 0.4
		leftAxis.zeroLineColor = UIColor.lightGrayColor()
		leftAxis.zeroLineDashLengths = [ 2, 2 ]
		leftAxis.gridLineDashLengths = [ 2, 2 ]

		let rightAxis = _combinedChartView.rightAxis
		rightAxis.labelPosition = ChartYAxis.YAxisLabelPosition.InsideChart
		rightAxis.drawGridLinesEnabled = false
		rightAxis.drawAxisLineEnabled = false
		rightAxis.drawZeroLineEnabled = false

		let xAxis = _combinedChartView.xAxis
		xAxis.drawAxisLineEnabled = false
		xAxis.gridLineDashLengths = [ 2, 2 ]
		xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom

		_combinedChartView.legend.enabled = false

		return _combinedChartView
	}()
	
	lazy var shieldView: UIButton = {
		let chartY = BaseChartView.TopInfoViewHeight + CGFloat(9)
		let chartX = self.bounds.width - self.ShieldWidth
		let _shieldView = UIButton()
		_shieldView.frame = CGRect(x: chartX, y: chartY,
		                           width: self.ShieldWidth,
		                           height: self.bounds.height - BaseChartView.TopInfoViewHeight - 19)
		_shieldView.backgroundColor = UIColor.ShieldColor()
		_shieldView.setImage(UIImage(named: "问号"), forState: UIControlState.Normal)
		_shieldView.addTarget(self, action: #selector(BaseChartView.clickShieldView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
		return _shieldView
	}()
}
