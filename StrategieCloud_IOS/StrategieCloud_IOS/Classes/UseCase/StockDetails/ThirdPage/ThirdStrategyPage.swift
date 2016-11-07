//
//  ThirdStrategyPage.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class ThirdStrategyPage: BasePageController {
	
	static let StrategyApplyChangedKey = "com.ringear.thirdstrategypage.strategyapply"

	private let CurrentPageID = Int(2)
	private var presenter: ThirdStrategyPresenterProtocol!
	private var requestAowDetailSuccess = false
	
	private enum Sections: Int {
		case ParamSet
		case PerformanceTest
	}
	
	private enum ParamSetItem: Int {
		case Style
		case Period
		case Adaptive
	}
	
	private enum PerformanceTestItem: Int {
		case TotalProfit
		case EachProfit
		case Chart
		case RecommendIdx
		case None
	}
	
	private struct NibName {
		static let HeaderView = "HeaderTitleView"
	}
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.dataSource = self
			tableView.delegate = self
			tableView.registerNib(UINib(nibName: NibName.HeaderView, bundle: nil), forHeaderFooterViewReuseIdentifier: NibName.HeaderView)
			tableView.backgroundColor = UIColor.whiteColor()
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		presenter = ThirdStrategyPresenter(view: self)
		
		print("self.frame--> \(self.view.frame), tableview.frame--> \(tableView.frame)")
		
		tableView.frame = self.view.frame
		
		if (pageNum == CurrentPageID) {
			if let aowId = roughStock.aowID {
				presenter.fetchProfitRankDetail(roughStock.code, aowId: aowId)
			} else {
				presenter.fetchAowDetailWithCode(roughStock.code)
			}
		}
    }

	override func setPageInfo(viewPagerNum num: Int, roughStock: RoughStock) {
		pageNum = num
		if (self.roughStock.code != roughStock.code) {
			self.roughStock = roughStock
			requestAowDetailSuccess = false
		}
		if (pageNum == CurrentPageID) {
			if !requestAowDetailSuccess {
				if let aowId = roughStock.aowID {
					presenter.fetchProfitRankDetail(roughStock.code, aowId: aowId)
				} else {
					presenter.fetchAowDetailWithCode(roughStock.code)
				}
			}
		}
	}

	private enum ModifyType {
		case AdaptiveParam
		case Style
		case Period
	}
	
	private func modifyParamAlert(type: ModifyType, value: AnyObject) {
		let alertController = UIAlertController(title: nil, message: "修改参数需要重新测试\n确认要修改参数设置吗？", preferredStyle: UIAlertControllerStyle.Alert)
		alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (_) in
			switch type {
			case .AdaptiveParam:
				let indexPath = NSIndexPath(forRow: ParamSetItem.Adaptive.rawValue, inSection: Sections.ParamSet.rawValue)
				self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
			case .Period:
				let indexPath = NSIndexPath(forRow: ParamSetItem.Period.rawValue, inSection: Sections.ParamSet.rawValue)
				self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
			case .Style:
				let indexPath = NSIndexPath(forRow: ParamSetItem.Style.rawValue, inSection: Sections.ParamSet.rawValue)
				self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
			}
		}))
		alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) in
			switch type {
			case .AdaptiveParam:
				if value is Int {
					let adaptiveVal = (value as! NSNumber).integerValue
					if let adaptiveType = StrategyBean.Adaptor(rawValue: adaptiveVal) {
						self.presenter.setAdaptive(adaptiveType)
					}
				}
			case .Period:
				if value is Int {
					let periodVal = (value as! NSNumber).integerValue
					if let periodType = StrategyBean.Period(rawValue: periodVal) {
						self.presenter.setPeriod(periodType)
					}
				}
			case .Style:
				if value is Int {
					let styleVal = (value as! NSNumber).integerValue
					if let styleType = StrategyBean.Style(rawValue: styleVal) {
						self.presenter.setStyle(styleType)
					}
				}
			}
			
		}))
		presentViewController(alertController, animated: true, completion: nil)
	}
	
	private func strategyApplyDialog(on: Bool) {
		var message: String
		on ? (message = "应用策略后打开BS开关，可接收推送消息") : (message = "取消应用后关闭BS开关，不能接收推送消息")
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (_) in
			let indexPath = NSIndexPath(forRow: PerformanceTestItem.TotalProfit.rawValue, inSection: Sections.PerformanceTest.rawValue)
			self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
		}))
		alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) in
			self.presenter.setAowSwitch(on, withCode: self.roughStock.code)
			
			if on {
				MobClick.event("回测点击事件")
			}
		}))
		presentViewController(alertController, animated: true, completion: nil)
		
		// 策略应用后通知kline界面刷新
		NSNotificationCenter.defaultCenter().postNotificationName(ThirdStrategyPage.StrategyApplyChangedKey, object: on)
	}
	
	private func addOptionalShareDialog() {
		let alertController = UIAlertController(title: nil, message: "添加到自选后才能应用策略", preferredStyle: UIAlertControllerStyle.Alert)
		alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (_) in
			let indexPath = NSIndexPath(forRow: PerformanceTestItem.TotalProfit.rawValue, inSection: Sections.PerformanceTest.rawValue)
			self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
		}))
		presentViewController(alertController, animated: true, completion: nil)
	}
}

// MARK: - ThirdStrategyViewProtocol
extension ThirdStrategyPage: ThirdStrategyViewProtocol {
	
	func notifyRefresh() {
		self.tableView.reloadData()
	}
	
	func fetchAowDetailSuccess() {
		tableView.reloadData()
		requestAowDetailSuccess = true;
	}
}

// MARK: - StartTestViewCellDelegate
extension ThirdStrategyPage: StartTestViewCellDelegate {
	func startTestClick() {
		presenter.fetchBacktestData(withCode: self.roughStock.code)
	}
}

// MARK: - AdaptiveOptionalCellDelegate
extension ThirdStrategyPage: AdaptiveOptionalCellDelegate {
	func adaptiveSwitchValueChanged(on: Bool) {
		if on {
			if presenter.showChart() {
				modifyParamAlert(ThirdStrategyPage.ModifyType.AdaptiveParam, value: StrategyBean.Adaptor.On.rawValue)
			} else {
				presenter.setAdaptive(StrategyBean.Adaptor.On)
			}
		} else {
			if presenter.showChart() {
				modifyParamAlert(ThirdStrategyPage.ModifyType.AdaptiveParam, value: StrategyBean.Adaptor.Off.rawValue)
			} else {
				presenter.setAdaptive(StrategyBean.Adaptor.Off)
			}
		}
	}
}

// MARK: - OptionalParamViewCellDelegate
extension ThirdStrategyPage: OptionalParamViewCellDelegate {
	func optionalParamStyleValueChanged(style: StrategyBean.Style) {
		if presenter.showChart() {
			modifyParamAlert(ThirdStrategyPage.ModifyType.Style, value: style.rawValue)
		} else {
			presenter.setStyle(style)
		}
	}
	
	func optionalParamPeriodValueChanged(period: StrategyBean.Period) {
		if presenter.showChart() {
			modifyParamAlert(ThirdStrategyPage.ModifyType.Period, value: period.rawValue)
		} else {
			presenter.setPeriod(period)
		}
	}
}

extension ThirdStrategyPage: TotalProfitDelegate {
	func totalProfitSwithValueChanged(on: Bool) {
		//先判断是否加自选，只有加自选后才能开启应用
		if presenter.codeInOpitonalShare(self.roughStock.code) {
			strategyApplyDialog(on)
		} else {
			addOptionalShareDialog()
		}
	}
}

// MARK: - UITableViewDataSource
extension ThirdStrategyPage: UITableViewDataSource {
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return Sections.PerformanceTest.rawValue + 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let section = Sections(rawValue: section) {
			switch section {
			case .ParamSet:
				return ParamSetItem.Adaptive.rawValue + 1
			case .PerformanceTest:
				if presenter.showChart() {
					if StockDetailsView.FromProfitRank {
						return PerformanceTestItem.RecommendIdx.rawValue
					} else {
						return PerformanceTestItem.RecommendIdx.rawValue + 2
					}
				} else {
					return 1
				}
			}
		}
		return 0
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if (indexPath.section == Sections.ParamSet.rawValue && indexPath.row == ParamSetItem.Adaptive.rawValue) {
			if !StockDetailsView.FromProfitRank {
				return CGFloat(77)
			}
		}
		if (indexPath.section == Sections.PerformanceTest.rawValue) {
			
			if presenter.showChart() {
				if let row = PerformanceTestItem(rawValue: indexPath.row) {
					switch row {
					case .EachProfit:
						return CGFloat(77)
					case .Chart:
						return CGFloat(200)
					case .None:
						return CGFloat(60)
					default:
						break
					}
				}
			} else {
				return CGFloat(200)
			}
		}
		return CGFloat(44)
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let section = Sections(rawValue: indexPath.section) {
			switch section {
			case .ParamSet:
				if let row = ParamSetItem(rawValue: indexPath.row) {
					switch row {
					case .Style:
						if StockDetailsView.FromProfitRank {
							let cell = tableView.dequeueReusableCellWithIdentifier("showCellID", forIndexPath: indexPath) as! ShowParamViewCell
							presenter.setShowStyleContentToView(cell)
							return cell
						} else {
							let cell = tableView.dequeueReusableCellWithIdentifier("optinalBtnCellID", forIndexPath: indexPath) as! OptionalParamViewCell
							presenter.setStyleContentToView(cell)
							cell.delegate = self
							return cell
						}
					case .Period:
						if StockDetailsView.FromProfitRank {
							let cell = tableView.dequeueReusableCellWithIdentifier("showCellID", forIndexPath: indexPath) as! ShowParamViewCell
							presenter.setShowPeiodContentToView(cell)
							return cell
						} else {
							let cell = tableView.dequeueReusableCellWithIdentifier("optinalBtnCellID", forIndexPath: indexPath) as! OptionalParamViewCell
							presenter.setPeriodContentToView(cell)
							cell.delegate = self
							return cell
						}
					case .Adaptive:
						if StockDetailsView.FromProfitRank {
							let cell = tableView.dequeueReusableCellWithIdentifier("parameterSetedCellID", forIndexPath: indexPath) as! AdaptiveShowCell
							presenter.setAdaptiveContentTextToView(cell)
							return cell
						} else {
							let cell = tableView.dequeueReusableCellWithIdentifier("optionalParameterSetCellID", forIndexPath: indexPath) as! AdaptiveOptionalCell
							presenter.setAdaptiveContentToView(cell)
							cell.delegate = self
							return cell
						}
					}
				}
			case .PerformanceTest:
				if presenter.showChart() {
					if let row = PerformanceTestItem(rawValue: indexPath.row) {
						switch row {
						case .TotalProfit:
							let cell = tableView.dequeueReusableCellWithIdentifier("performanceShowCell1ID", forIndexPath: indexPath) as! TotalProfitViewCell
							cell.showTotalProfitRightLl(!StockDetailsView.FromProfitRank)
							cell.delegate = self
							presenter.setTotalProfitContentToView(cell)
							return cell
						case .EachProfit:
							let cell = tableView.dequeueReusableCellWithIdentifier("performanceShowCell2ID", forIndexPath: indexPath) as! EachProfitViewCell
							presenter.setEachProfitContentToView(cell)
							return cell
						case .Chart:
							let cell = tableView.dequeueReusableCellWithIdentifier("chartID", forIndexPath: indexPath) as! BackTestChartViewCell
							presenter.setBacktestChartContentToView(cell)
							return cell
						case .RecommendIdx:
							let cell = tableView.dequeueReusableCellWithIdentifier("performanceShowCell4ID", forIndexPath: indexPath) as! RecommendIdxViewCell
							presenter.setRecommendIdxContentToView(cell)
							return cell
						case .None:
							return UITableViewCell()
						}
					}
				} else {
					let cell = tableView.dequeueReusableCellWithIdentifier("performanceShowCell3ID", forIndexPath: indexPath) as! StartTestViewCell
					if StockDetailsView.FromProfitRank {
						cell.startTestViewShow(false)
					} else {
						cell.startTestViewShow(true)
					}
					cell.delegate = self
					return cell
				}
			}
		}
		return UITableViewCell()
	}
}

// MARK: - UITableViewDelegate
extension ThirdStrategyPage: UITableViewDelegate {
	
	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		if (section == Sections.ParamSet.rawValue) {
			let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: CGFloat(10)))
			view.backgroundColor = UIColor(red: 240/255.0, green: 244/255.0, blue: 250/255.0, alpha: 1.0)
			return view
		}
		return nil
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat(10)
	}
	
	func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat(30)
	}
	
	func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(NibName.HeaderView) as! HeaderTitleView
		if let sectionType = Sections(rawValue: section) {
			switch sectionType {
			case .ParamSet:
				view.setTitle("H333策略参数设置")
			case .PerformanceTest:
				view.setTitle("H333策略性能测试")
			}
		}
		return view;
	}
}
