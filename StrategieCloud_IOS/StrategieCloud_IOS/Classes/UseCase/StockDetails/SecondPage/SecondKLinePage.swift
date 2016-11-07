//
//  SecondKLinePage.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class SecondKLinePage: BasePageController {

	private let CurrentPageID = Int(1)
	private let margin = CGFloat(10)
	private var requestKLineSuccess = false
	private var requestVolumeSuccess = false
	var presenter: SecondKLinePresenterProtocol?
	private var strategyApplyChanged = false
	private var switchIndex = false
	
	@IBOutlet weak var topInfoView: KLineTopInfoView! {
		didSet {
			topInfoView.delegate = self
		}
	}
	@IBOutlet weak var topInfoViewHeightConstraint: NSLayoutConstraint!
	var currentIndexType = CompositeChartView.KLineIndexType.Volume
	
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SecondKLinePresenter(view: self)
		self.view.addSubview(chartView)

		chartView.snp_makeConstraints { (make) in
			make.top.equalTo(topInfoView.snp_bottom)
			make.leading.trailing.bottom.equalTo(self.view)
		}
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SecondKLinePage.strategyApplyChanged(_:)), name: ThirdStrategyPage.StrategyApplyChangedKey, object: nil)
    }

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		requestData()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: ThirdStrategyPage.StrategyApplyChangedKey, object: nil)
	}

	override func viewWillTransitionToSizeWithLandscape(landscape: Bool) {
		if landscape {
			topInfoViewHeightConstraint.constant = 34
		} else {
			topInfoViewHeightConstraint.constant = 60
		}
		chartView.restoreToDefaultScaleFactor()
		requestData()
	}
	
	func strategyApplyChanged(notification: NSNotification) {
		self.strategyApplyChanged = true
	}

	private func requestData() {
		if (pageNum == CurrentPageID) {
			requestKLineSuccess = false
			requestVolumeSuccess = false
			requestKLine()
			requestIndex()
		}
	}

	override func setPageInfo(viewPagerNum num: Int, roughStock: RoughStock) {
		pageNum = num
		if (self.roughStock.code != roughStock.code) {
			self.roughStock = roughStock
			requestKLineSuccess = false
			requestVolumeSuccess = false
		}
		
		if self.strategyApplyChanged {
			self.strategyApplyChanged = false
			requestKLineSuccess = false
			requestVolumeSuccess = false
		}
		
		if (pageNum == CurrentPageID) {
			requestKLine()
			requestIndex()
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func getShareImage(view: UIView?) -> UIImage? {
		return super.getShareImage(chartView)
	}
	
	private func requestKLine() {
		if !requestKLineSuccess {
			chartView.setAboveViewIndicatorHide(false)
			presenter?.fetchKLine(withCode: roughStock.code)
		}
	}
	
	private func requestIndex() {
		if !requestVolumeSuccess {
			chartView.setBelowViewIndicatorHide(false)
			presenter?.fetchKLineIndex(withCode: roughStock.code, option: currentIndexType.rawValue)
		}
	}
	
	private lazy var chartView: CompositeChartView = {
		let chartY = self.topInfoView.bounds.height + self.margin
		let height = StockDetailsView.PageControlHeight + self.topInfoView.frame.height + CGFloat(64)

		let _chartView = CompositeChartView(frame: CGRect(x: 0, y: chartY,
			width: self.view.bounds.width, height: self.view.bounds.height - height - self.margin),
		                                    aboveViewType: BaseTopInfoView.ViewType.KLine, belowViewType: BaseTopInfoView.ViewType.KLineVolume)
		_chartView.setAboveViewLabelCount(5)
		_chartView.setBelowViewLabelCount(3)
		_chartView.setTopBottomSpaceToZero()
		_chartView.belowViewDisableRightAxis()
		_chartView.aboveViewDisableRightAxis()
		_chartView.needScaleToDefault()
		_chartView.belowViewStartAtZero()
		_chartView.setAboveShieldView(delegate: self)
		_chartView.delegate = self
		return _chartView
	}()
}

extension SecondKLinePage: CompositeChartViewDelegate {
	
	func showOpenCloseDatas(datas: [ExternalData]) {
		for data in datas {
			if data.name.containsString(CandleStickChartRenderer.DataLabel.Change) {
				topInfoView.setFirstChange(data)
			}
			if data.name.containsString(CandleStickChartRenderer.DataLabel.High) {
				topInfoView.setHigh(data)
			}
			if data.name.containsString(CandleStickChartRenderer.DataLabel.Low) {
				topInfoView.setLow(data)
			}
			if data.name.containsString(CandleStickChartRenderer.DataLabel.Open) {
				topInfoView.setOpen(data)
			}
		}
	}

	func belowChartViewTap(indexType: CompositeChartView.KLineIndexType) {
		switchIndex = true
		currentIndexType = indexType
		requestVolumeSuccess = false
		requestIndex()
	}
}

// MARK: - BaseChartViewDelegate
extension SecondKLinePage: BaseChartViewDelegate {
	func shieldViewClick() {
		print(#function)
//		let alert = UIAlertView(title: "专业版", message: "支付宝、微信支付", delegate: self, cancelButtonTitle: "确定")
//		alert.show()
	}

	func strategyBtnClick() {
		let strategyListVC = StrategyListViewController()
		strategyListVC.stockCode = roughStock.code
		strategyListVC.title = "“" + roughStock.name + "”" + "适用策略"
		let nav = MainNavigationController(rootViewController: strategyListVC)
		self.navigationController?.presentViewController(nav, animated: true, completion: nil)
	}
}

// MARK: - KLineTopInfoViewDelegate
extension SecondKLinePage: KLineTopInfoViewDelegate {
	func bsSwitchOn(on: Bool) {
		chartView.notifyAboveViewRefresh()
//		chartView.aboveViewShowShield(showShield: !on)
	}
}

// MARK: - SecondKLineViewProtocol
extension SecondKLinePage: SecondKLineViewProtocol {
	func setKLineData(withData data: CombinedChartData?, strategyType: Int) {
		if let _data = data {
			chartView.restoreToDefaultScaleFactor()
			chartView.setAboveView(withData: nil)
			requestKLineSuccess = true
			chartView.setAboveViewIndicatorHide(true)
			chartView.setAboveView(withData: _data)

			if let type = StrategyType(rawValue: strategyType) {
				if type == StrategyType.None {
					topInfoView.setBSSwitchEnable(false)
				} else {
					topInfoView.setBSSwitchEnable(true)
				}
				chartView.setStrategyBtnType(type)
			}
		}
	}
	
	func setKLineIndexData(withData data: CombinedChartData?) {
		if let _data = data {
			if switchIndex {
				switchIndex = false
			} else {
				chartView.restoreToDefaultScaleFactor()
			}
			requestVolumeSuccess = true
			chartView.setBelowView(withData: nil)
			chartView.setBelowViewIndicatorHide(true)
			chartView.setBelowView(withData: _data)
		}
	}
}
