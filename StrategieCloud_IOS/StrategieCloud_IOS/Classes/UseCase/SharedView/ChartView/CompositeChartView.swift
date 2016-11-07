//
//  CompositeChartView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol CompositeChartViewDelegate: class {
	func showOpenCloseDatas(datas: [ExternalData])
	func belowChartViewTap(indexType: CompositeChartView.KLineIndexType)
}

class CompositeChartView: UIView, ChartViewDelegate {
	
	enum KLineIndexType: String {
		case Volume = "volume"
		case MACD = "MACD"
		case KDJ = "KDJ"
		case DMI = "DMI"
//		case SAR = "SAR"
		case BOLL = "BOLL"
		case TRIX = "TRIX"
		
		func next() -> KLineIndexType {
			switch self {
			case .Volume:	return .MACD
			case .MACD:		return .KDJ
			case .KDJ:		return .DMI
			case .DMI:		return .BOLL
//			case .SAR:		return .BOLL
			case .BOLL:		return .TRIX
			default:		return .Volume
			}
		}
	}
	
	private var indexType = KLineIndexType.Volume
	
	var aboveViewType = BaseTopInfoView.ViewType.TimeSharedLine
	var belowViewType = BaseTopInfoView.ViewType.TimeSharedVolume
	
	weak var delegate: CompositeChartViewDelegate?
	
	init(frame: CGRect, aboveViewType: BaseTopInfoView.ViewType, belowViewType: BaseTopInfoView.ViewType) {
		super.init(frame: frame)
		self.aboveViewType = aboveViewType
		self.belowViewType = belowViewType
		self.commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setAboveView(withData data: CombinedChartData?) {
		aboveChartView.enableDrawXLabels(false)
		aboveChartView.chartViewData = data
	}

	func setBelowView(withData data: CombinedChartData?) {
		belowChartView.chartViewData = data
	}
	
	func belowViewStartAtZero() {
		belowChartView.chartViewStartAtZero()
	}
	
	func aboveViewCustomRightAxisVal(value: [Double]) {
		aboveChartView.customRightAxisVal(value)
	}
	
	func setAboveViewLabelCount(count: Int) {
		aboveChartView.setLabelCount(count)
	}
	
	func setBelowViewLabelCount(count: Int) {
		belowChartView.setLabelCount(count)
	}
	
	func enableScaleX(enable: Bool) {
		aboveChartView.enableScaleX(enable)
		belowChartView.enableScaleX(enable)
	}
	
	func setTopBottomSpaceToZero() {
		aboveChartView.setTopBottomSpaceToZero()
		belowChartView.setTopBottomSpaceToZero()
	}
	
	func customAboveViewYAxis(state: Bool) {
		aboveChartView.setCustomYAxis(state)
	}
	
	func customXAxisLabelModules(labelCount: Int) {
		aboveChartView.customXAxisLabelModules(labelCount)
		belowChartView.customXAxisLabelModules(labelCount)
	}
	
	func belowViewDisableRightAxis() {
		belowChartView.disableRightAxis()
	}
	
	func aboveViewDisableRightAxis() {
		aboveChartView.disableRightAxis()
	}
	
	func aboveViewShowShield(showShield show: Bool) {
		for view in aboveChartView.subviews {
			if view is UIButton {
				aboveChartView.showViewWithAnimate(show, view: view)
			}
		}
	}
	
	func setAboveShieldView(delegate delgate: BaseChartViewDelegate) {
		aboveChartView.delegate = delgate
	}
	
	func needScaleToDefault() {
		aboveChartView.needScaleToDefault()
		belowChartView.needScaleToDefault()
	}
	
	func notifyAboveViewRefresh() {
		aboveChartView.notifyRefresh()
	}

	func restoreToDefaultScaleFactor() {
		aboveChartView.restoreToDefaultScaleFactor()
		belowChartView.restoreToDefaultScaleFactor()
	}

	func setAboveViewIndicatorHide(hide: Bool) {
		aboveChartView.combinedChartView.setActivityViewHide(hide: hide)
	}
	
	func setBelowViewIndicatorHide(hide: Bool) {
		belowChartView.combinedChartView.setActivityViewHide(hide: hide)
	}

	func setStrategyBtnType(type: StrategyType) {
		aboveChartView.setStrategyBtnType(type)
	}

	// MARK: - ChartViewDelegate
	func chartTap(chartView: ChartViewBase) {
		if chartView == belowChartView.combinedChartView && belowViewType == BaseTopInfoView.ViewType.KLineVolume {
			if (delegate != nil) {
				
				indexType = indexType.next()
				belowChartView.setKlineIndexTitle(indexType)
				delegate?.belowChartViewTap(indexType)
			}
		}
	}
	
	func chartScaled(chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat, dX: CGFloat, dY: CGFloat) {
		if chartView == aboveChartView.combinedChartView {
			belowChartView.zoom(scaleX, scaleY: scaleY, dX: dX, dY: dY)
		} else {
			aboveChartView.zoom(scaleX, scaleY: scaleY, dX: dX, dY: dY)
		}
	}

	func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
		if chartView === aboveChartView.combinedChartView {
			belowChartView.setHighlightValue(highlight: highlight, callDelegate: false)
		} else {
			
			aboveChartView.setHighlightValue(highlight: highlight, callDelegate: false)
		}
	}
	
	func chartMatrixTranslate(chartView: ChartViewBase, transform: CGAffineTransform) {
		if chartView === aboveChartView.combinedChartView {
			belowChartView.combinedChartView.translated(transform)
		} else {
			aboveChartView.combinedChartView.translated(transform)
		}
	}

	func chartValueNothingSelected(chartView: ChartViewBase) {
		if chartView == aboveChartView.combinedChartView {
			belowChartView.setHighlightValue(highlight: nil, callDelegate: false)
		} else {
			aboveChartView.setHighlightValue(highlight: nil, callDelegate: false)
		}
	}
	
	func chartExternalDatas(chartView: ChartViewBase, datas: [ExternalData]) {
		if chartView === self.aboveChartView.combinedChartView {
			if aboveViewType == BaseTopInfoView.ViewType.KLine {
			
				var klineTopBasicDatas = [ExternalData]()
				var klineMADatas = [ExternalData]()
				
				for data in datas {
					if (data.name.containsString(CandleStickChartRenderer.DataLabel.Prefix)) {
						klineTopBasicDatas.append(data)
					} else {
						klineMADatas.append(data)
					}
				}
				delegate?.showOpenCloseDatas(klineTopBasicDatas)
				aboveChartView.setTopInfoView(withData: klineMADatas)
				
			} else {
				aboveChartView.setTopInfoView(withData: datas)
			}
			
		} else {
			belowChartView.setTopInfoView(withData: datas)
		}
	}

	override func layoutSubviews() {
		belowChartView.snp_updateConstraints { (make) in
			make.leading.trailing.bottom.equalTo(self)
			make.height.equalTo(self.bounds.height / 3)
		}

		aboveChartView.snp_updateConstraints { (make) in
			make.leading.top.trailing.equalTo(self)
			make.bottom.equalTo(belowChartView.snp_top)
		}
	}

	// MARK: - Private Method

	private func commonInit() {
		self.addSubview(aboveChartView)
		self.addSubview(belowChartView)
	}

	private lazy var aboveChartView: BaseChartView = {
		let _aboveChartView = BaseChartView(frame: CGRect(x: 0, y: 0, width: self.bounds.width,
			height: self.bounds.height * 2 / 3), viewType: self.aboveViewType)
		_aboveChartView.combinedChartView.delegate = self
		_aboveChartView.setViewPortBottomOffsets(CGFloat(10))
		return _aboveChartView
	}()

	private lazy var belowChartView: BaseChartView = {
		let _belowChartView = BaseChartView(frame: CGRect(x: 0, y: self.bounds.height * 2 / 3,
			width: self.bounds.width, height: self.bounds.height / 3), viewType: self.belowViewType)
		_belowChartView.combinedChartView.delegate = self
		_belowChartView.setViewPortBottomOffsets(CGFloat(20))
		return _belowChartView
	}()
}
