//
//  FirstTimeSharingPage.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class FirstTimeSharedPage: BasePageController {

	private let CurrentPageID = Int(0)
	private var popopViewHeight = CGFloat(0)
	private var requestDetailInfoSuccess = false
	private var requestMinuteTickSuccess = false
	private var requestMinuteVolumeSuccess = false
	var presenter: FirstTimeSharedPresenterProtocol?
	
	@IBOutlet weak var timeShareTopInfoView: TimeSharingTopInfoView! {
		didSet {
			timeShareTopInfoView.delegate = self
		}
	}
	@IBOutlet weak var topShareHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = FirstTimeSharedPresenter(view: self)
		self.view.addSubview(chartView)
		self.view.addSubview(popopView)

		chartView.snp_makeConstraints { (make) in
			make.top.equalTo(timeShareTopInfoView.snp_bottom)
			make.leading.trailing.bottom.equalTo(view)
		}

		if (pageNum == CurrentPageID) {
			presenter?.fetchStockDetailsInfo(withCode: roughStock.code)
			presenter?.fetchMinuteTickData(withCode: roughStock.code)
			presenter?.fetchMinuteVolumeData(withCode: roughStock.code)
		}
    }

	override func viewWillTransitionToSizeWithLandscape(landscape: Bool) {
		if landscape {
			timeShareTopInfoView.hidden = true
			topShareHeightConstraint.constant = 0
			clickHiddenView()
			popopView.setShow(false)
		} else {
            timeShareTopInfoView.hidden = false
			topShareHeightConstraint.constant = 90
		}

		requestMinuteTickSuccess = false
		requestMinuteVolumeSuccess = false
		requestChartData()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	override func setPageInfo(viewPagerNum num: Int, roughStock: RoughStock) {
		pageNum = num
		if (self.roughStock.code != roughStock.code) {
			self.roughStock = roughStock
			requestDetailInfoSuccess = false
			requestMinuteTickSuccess = false
			requestMinuteVolumeSuccess = false
		}
		
		if (pageNum == CurrentPageID) {
			if !requestDetailInfoSuccess {
				presenter?.fetchStockDetailsInfo(withCode: roughStock.code)
			}
			requestChartData()
		}
	}

	private func requestChartData() {
		if !requestMinuteTickSuccess {
			chartView.setAboveViewIndicatorHide(false)
			presenter?.fetchMinuteTickData(withCode: roughStock.code)
		}
		
		if !requestMinuteVolumeSuccess {
			chartView.setBelowViewIndicatorHide(false)
			presenter?.fetchMinuteVolumeData(withCode: roughStock.code)
		}
	}

	override func getShareImage(view: UIView?) -> UIImage? {
		return super.getShareImage(chartView)
	}
	
	@objc private func clickHiddenView() {
		timeShareTopInfoView.returnToTransformIdentity()
	}

	private lazy var chartView: CompositeChartView = {
		let height = StockDetailsView.PageControlHeight + self.timeShareTopInfoView.frame.height + CGFloat(64)
		let _chartView = CompositeChartView(frame: CGRect(x: 0, y: self.timeShareTopInfoView.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - height), aboveViewType: BaseTopInfoView.ViewType.TimeSharedLine, belowViewType: BaseTopInfoView.ViewType.TimeSharedVolume)
		_chartView.customXAxisLabelModules(59) //将分时图x轴4等份
		_chartView.enableScaleX(false)
		_chartView.customAboveViewYAxis(true)
		_chartView.setTopBottomSpaceToZero()
		_chartView.setAboveViewLabelCount(3)
		_chartView.setBelowViewLabelCount(3)
		_chartView.belowViewStartAtZero()
		_chartView.belowViewDisableRightAxis()
		return _chartView
	}()
	
	private lazy var popopView: TimeSharedInfoPopupView = {
		let _popopView = TimeSharedInfoPopupView(frame: CGRect(x: 0, y: self.timeShareTopInfoView.bounds.height, width: self.view.bounds.width, height: self.view.bounds.height - self.timeShareTopInfoView.frame.height + CGFloat(64)))
		_popopView.hidden = true
		_popopView.addTarget(self, action: #selector(FirstTimeSharedPage.clickHiddenView), forControlEvents: UIControlEvents.TouchUpInside)
		return _popopView
	}()
}

// MARK: - FirstTimeSharedViewProtocol
extension FirstTimeSharedPage: FirstTimeSharedViewProtocol {

	func setAboveViewDatas(chartData: CombinedChartData?, value: [Double]?) {
		if let _chartData = chartData {
			requestMinuteTickSuccess = true
			self.chartView.setAboveView(withData: _chartData)
		}
		if let _value = value {
			self.chartView.aboveViewCustomRightAxisVal(_value)
		}
	}
	
	func setBelowViewDatas(chartData: CombinedChartData?) {
		if let _chartData = chartData {
			requestMinuteVolumeSuccess = true
			self.chartView.setBelowView(withData: _chartData)
		}
	}
	
	func setStockDetailsInfo(stockDetailsItem: StockDetailsItem) {
		requestDetailInfoSuccess = true
		self.timeShareTopInfoView.latestPriceLabel.attributedText = stockDetailsItem.revLastPrice
		self.timeShareTopInfoView.changeAndChangepctLabel.attributedText = stockDetailsItem.revChange
		self.timeShareTopInfoView.volumeLabel.attributedText = stockDetailsItem.revVolume
		self.timeShareTopInfoView.highPriceLabel.attributedText = stockDetailsItem.revHighPrice
		self.timeShareTopInfoView.lowPriceLabel.attributedText = stockDetailsItem.revLowPrice
		self.timeShareTopInfoView.turnoverRateLabel.attributedText = stockDetailsItem.revTurnoverRate
		self.popopView.setDatas(stockDetailsItem.revAmplitude, attrStr2: stockDetailsItem.revStaticPE, attrStr3: stockDetailsItem.revValue, attrStr4: stockDetailsItem.revNegMarketValue)
	}
}

// MARK: - TimeSharingTopInfoViewDelegate
extension FirstTimeSharedPage: TimeSharingTopInfoViewDelegate {
	func timeSharingTopInfoViewShowOrHide(show: Bool) {
		popopView.setShow(show)
	}
}
