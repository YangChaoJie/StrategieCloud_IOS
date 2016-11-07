//
//  DrawBar.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/23.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

class DrawBar: BaseDrawFunc {

	var chartData: CombinedChartData?
	var indexs: [String]?
	
	private let TimeSharedVolume = "ticksvolume"

	required init(jsonDic: NSDictionary, withIndex index: Int) {
		let chartColor = self.color(jsonDic["color"] as? String, index: index)
		let name = jsonDic["indicator"] as? String

		if let figure = jsonDic["figure"] as? String {
			if let json = Converts.serializationStringToDic(figure) {
				if let _ = json["columns"] as? [String] {
					let dataFrameJson = VolDataFrameJson(dic: json)
					if let datas = dataFrameJson.data, indexs = dataFrameJson.index, columns = dataFrameJson.columns {
						if datas.count > 0 && columns.count == 2 {
							
							let valueIndex = 0
							let fillIndex = 1

							let barData = BarChartData()
							var entries = [BarChartDataEntry]()
							for i in 0 ..< datas.count {
								if columns[0] == "VOL" {
									let value = Double(datas[i][valueIndex]) / 100 //单位: 手
									entries.append(BarChartDataEntry(value: value, xIndex: i, data: Bool(datas[i][fillIndex])))
								} else {
									entries.append(BarChartDataEntry(value: Double(datas[i][valueIndex]), xIndex: i, data: Bool(datas[i][fillIndex])))
								}
							}
							
							var xVals = indexs

							if let _name = name {
								if _name == TimeSharedVolume {
									if maxTimeSharedDataCount > entries.count {
										for _ in entries.count ..< maxTimeSharedDataCount {
											xVals.append("")
										}
									}

								}
							}
							
							if self.chartData == nil {
								self.chartData = CombinedChartData(xVals: xVals)
							}

							let dataSet = BarChartDataSet(yVals: entries, label: columns[0])
							dataSet.setColor(chartColor)
							dataSet.axisDependency = ChartYAxis.AxisDependency.Left
							dataSet.drawValuesEnabled = false
							dataSet.increasingColor = UIColor.KLineUpColor()
							dataSet.decreasingColor = UIColor.KLineDownColor()
							barData.addDataSet(dataSet)
							self.chartData?.barData = barData
						}
					}
				} else {
					let seriesJson = SeriesJson(dic: json)
					if let datas = seriesJson.data, indexs = seriesJson.index {
						self.indexs = indexs
						if datas.count > 0 {
							if self.chartData == nil {
								self.chartData = CombinedChartData(xVals: indexs)
							}
							let barData = BarChartData()
							var entries = [BarChartDataEntry]()
							for i in 0 ..< datas.count {
								entries.append(BarChartDataEntry(value: datas[i], xIndex: i))
							}
							
							let dataSet = BarChartDataSet(yVals: entries, label: name)
							dataSet.setColor(chartColor)
							dataSet.axisDependency = ChartYAxis.AxisDependency.Left
							dataSet.drawValuesEnabled = false
							dataSet.increasingColor = UIColor.KLineUpColor()
							dataSet.decreasingColor = UIColor.KLineDownColor()
							barData.addDataSet(dataSet)
							self.chartData?.barData = barData
						}
					}
				}
			}
		}
	}
}