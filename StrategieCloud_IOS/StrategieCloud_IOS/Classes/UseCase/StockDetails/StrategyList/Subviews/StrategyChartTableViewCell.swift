//
//  StrategyChartTableViewCell.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/9/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

protocol StrategyChartTableViewCellDataSource: class {
	func backTestChartViewData(bean: BackTestBean?)
}

class StrategyChartTableViewCell: UITableViewCell, StrategyChartTableViewCellDataSource {

	override func awakeFromNib() {
		super.awakeFromNib()
		self.addSubview(chartView)
	}
	
	func backTestChartViewData(bean: BackTestBean?) {
		chartView.frame = self.bounds
		if let bean = bean {
			let combinedChartData = CombinedChartData(xVals: bean.chartIndex)
			
			var assetEntries = [ChartDataEntry]()
			var baseEntries = [ChartDataEntry]()
			var buyEntries = [ChartDataEntry]()
			var sellEntries = [ChartDataEntry]()
			
			for i in 0 ..< bean.chartData.count {
				assetEntries.append(ChartDataEntry(value: bean.chartData[i][bean.getDataIndex(byName: BackTestBean.ColumnsName.Asset)], xIndex: i))
				baseEntries.append(ChartDataEntry(value: bean.chartData[i][bean.getDataIndex(byName: BackTestBean.ColumnsName.Base)], xIndex: i))
				
				if let signalType = BackTestBean.Signal(rawValue: bean.chartData[i][bean.getDataIndex(byName: BackTestBean.ColumnsName.Signal)]) {
					switch signalType {
					case .None: print("")
					case .Buy:
						buyEntries.append(ChartDataEntry(value: bean.chartData[i][bean.getDataIndex(byName: BackTestBean.ColumnsName.Base)], xIndex: i))
					case .Sell:
						sellEntries.append(ChartDataEntry(value: bean.chartData[i][bean.getDataIndex(byName: BackTestBean.ColumnsName.Base)], xIndex: i))
					}
				}
			}
			
			let lineData = LineChartData()
			let assetSet = LineChartDataSet(yVals: assetEntries, label: "资产总额")
			assetSet.setColor(UIColor.BacktestAssetColor())
			assetSet.drawCubicEnabled = false
			assetSet.drawCircleHoleEnabled = false
			assetSet.drawCirclesEnabled = false
			assetSet.drawValuesEnabled = false
			assetSet.lineWidth = 0.8
			
			let baseSet = LineChartDataSet(yVals: baseEntries, label: "基准值")
			baseSet.setColor(UIColor.BacktestBaseColor())
			baseSet.drawCirclesEnabled = false
			baseSet.drawValuesEnabled = false
			baseSet.lineWidth = 0.8
			lineData.addDataSet(baseSet)
			lineData.addDataSet(assetSet)
			
			
			let ScatterSize = CGFloat(6)
			let scatterData = ScatterChartData()
			let buySet = ScatterChartDataSet(yVals: buyEntries, label: "买入")
			buySet.setColor(UIColor.BacktestBuyColor().colorWithAlphaComponent(0.8))
			buySet.scatterShape = ScatterChartDataSet.ScatterShape.Circle
			buySet.scatterShapeSize = ScatterSize
			buySet.drawValuesEnabled = false
			
			let sellSet = ScatterChartDataSet(yVals: sellEntries, label: "卖出")
			sellSet.setColor(UIColor.BacktestSellColor().colorWithAlphaComponent(0.8))
			sellSet.scatterShape = ScatterChartDataSet.ScatterShape.Circle
			sellSet.scatterShapeSize = ScatterSize
			sellSet.drawValuesEnabled = false
			
			scatterData.addDataSet(buySet)
			scatterData.addDataSet(sellSet)
			
			combinedChartData.lineData = lineData
			combinedChartData.scatterData = scatterData
			chartView.data = combinedChartData
//			chartView.animate(xAxisDuration: 2, easingOption: ChartEasingOption.EaseOutQuart)
            
            chartView.setActivityViewHide(hide: true)
		}
	}

	private lazy var chartView: CombinedChartView = {
		let _chartView = CombinedChartView()
		_chartView.drawOrder = [
			CombinedChartView.CombinedChartDrawOrder.Line.rawValue,
			CombinedChartView.CombinedChartDrawOrder.Bubble.rawValue,
			CombinedChartView.CombinedChartDrawOrder.Scatter.rawValue
		]
		
        _chartView.frame = self.bounds
        _chartView.setActivityViewHide(hide: false)
        
		_chartView.drawGridBackgroundEnabled = false
		_chartView.drawBordersEnabled = true
		_chartView.borderColor = UIColor(red: 210/255.0, green: 210/255.0, blue: 210/255.0, alpha: 1.0)
		_chartView.descriptionText = ""
		_chartView.legend.form = ChartLegend.ChartLegendForm.Circle
		_chartView.legend.textColor = UIColor(red: 53/255.0, green: 67/255.0, blue: 70/255.0, alpha: 1.0)
		_chartView.highlightPerTapEnabled = false
		_chartView.longPressHighlighted = false
		
		let rightAxis = _chartView.rightAxis
		rightAxis.enabled = false
		
		let leftAxis = _chartView.leftAxis
		leftAxis.drawGridLinesEnabled = true
		leftAxis.drawAxisLineEnabled = false
		leftAxis.startAtZeroEnabled = false
		leftAxis.setLabelCount(4, force: true)
		leftAxis.gridColor = UIColor(red: 232/255.0, green: 238/255.0, blue: 243/255.0, alpha: 1.0)
		leftAxis.labelTextColor = UIColor(red: 53/255.0, green: 67/255.0, blue: 70/255.0, alpha: 1.0)
		leftAxis.drawZeroLineEnabled = false
		
		let xAxis = _chartView.xAxis
		xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
		xAxis.drawAxisLineEnabled = false
		xAxis.drawGridLinesEnabled = true
		xAxis.gridColor = UIColor(red: 232/255.0, green: 238/255.0, blue: 243/255.0, alpha: 1.0)
		xAxis.labelTextColor = UIColor(red: 146/255.0, green: 160/255.0, blue: 173/255.0, alpha: 1.0)
		return _chartView
	}()
}
