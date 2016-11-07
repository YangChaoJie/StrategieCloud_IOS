//
//  DrawDataFunc.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/22.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

class DrawData: BaseDrawFunc {

	var chartData: CombinedChartData?
	var indexs: [String]?

	required init(jsonDic: NSDictionary, withIndex index: Int) {
		let chartColor = self.color(jsonDic["color"] as? String, index: index)
		let name = jsonDic["indicator"] as? String

		if let figure = jsonDic["figure"] as? String  {
			if let json = Converts.serializationStringToDic(figure) {
				let seriesJson = SeriesJson(dic: json)
				if let datas = seriesJson.data, indexs = seriesJson.index, valids = seriesJson.valid {
					if datas.count > 0 {
						self.indexs = indexs
						if self.chartData == nil {
							self.chartData = CombinedChartData(xVals: indexs)
						}

						var entries = [ChartDataEntry]()
						for i in 0 ..< indexs.count {
							entries.append(ChartDataEntry(value: datas[i], xIndex: i, data: valids[i]))
						}
						let indexCount = entries.count

						if seriesJson.name == "MEAN" && maxTimeSharedDataCount > entries.count {
							for index in entries.count ..< maxTimeSharedDataCount {
								entries.append(ChartDataEntry(value: 0, xIndex: index, data: false))
							}
						}

						var set: LineChartDataSet!
						if seriesJson.name == "MEAN" {
							set = LineChartDataSet(yVals: entries, label: "均价")
							set.setColor(DrawFeatureEnum.DrawColorIndex.Orange.value())
						} else {
							set = LineChartDataSet(yVals: entries, label: name)
							set.setColor(chartColor)
						}
						set.drawCirclesEnabled = false
						set.drawValuesEnabled = false
						set.highlightEnabled = true
						set.maxIndex = indexCount - 1
						set.drawHorizontalHighlightIndicatorEnabled = false
						set.lineWidth = 0.8
						let lineChartData = LineChartData()
						lineChartData.addDataSet(set)
						self.chartData?.lineData = lineChartData
					}
				}
			}
		}
	}

	convenience init(jsonDic: NSDictionary, withIndex index: Int, attr: DrawFeatureEnum.DrawAttr) {
		self.init(jsonDic: jsonDic, withIndex: index)
		if let chartData_ = self.chartData {
			if chartData_.lineData != nil {
				let set = chartData_.lineData.getDataSetByIndex(0) as! LineChartDataSet
				switch attr {
				case .PointDot:
					set.lineDashLengths = [4, 4]
				case .CircleDot:
					set.lineDashLengths = [ 1.2, 8 ]
					set.lineWidth = CGFloat(1.2)
				default: break
				}
			}
		}
	}
}
