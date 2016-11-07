//
//  DrawTicks.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/24.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

class DrawTicks: BaseDrawFunc {

	private enum Type: String {
		case Close = "CLOSE"
		case ChangePct = "CHANGEPCT"
	}
	
	var chartData: CombinedChartData?
	var indexs: [String]?
	
	required init(jsonDic: NSDictionary, withIndex index: Int) {
		
		if let figure = jsonDic["figure"] as? String {
			if let json = Converts.serializationStringToDic(figure) {
				let dataFrameJson = DataFrameJson(dic: json)
				if let datas = dataFrameJson.data, indexs = dataFrameJson.index, columns = dataFrameJson.columns {
					self.indexs = indexs
					if datas.count > 0 {
						
						var closeIndex = Int(0)
						var changePctIndex = Int(0)
						
						for (index, item) in columns.enumerate() {
							if let type = Type(rawValue: item) {
								switch type {
								case .Close:	closeIndex = index
								case .ChangePct:changePctIndex = index
								}
							}
						}
						
						var entries = [ChartDataEntry]()
						for i in 0 ..< indexs.count {
							let data = [ "\(datas[i][changePctIndex])", indexs[i] ]
							entries.append(ChartDataEntry(value: datas[i][closeIndex], xIndex: i, data: data))
						}
						
						var xVals = indexs
						if maxTimeSharedDataCount > entries.count {
							for _ in entries.count ..< maxTimeSharedDataCount {
								xVals.append("")
							}
						}
						
						if self.chartData == nil {
							self.chartData = CombinedChartData(xVals: xVals)
						}
						
						let set = LineChartDataSet(yVals: entries, label: "现价")
						set.setColor(UIColor.TimeSharedPriceColor())
						set.drawCirclesEnabled = false
						set.drawValuesEnabled = false
						set.drawFilledEnabled = false
						set.customChart = true
						set.lineWidth = 0.8
						
						let lineChartData = LineChartData()
						lineChartData.addDataSet(set)
						self.chartData?.lineData = lineChartData
					}
				}
			}
		}
	}
}
