//
//  DrawIconText.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/24.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

class DrawIconText: BaseDrawFunc {

	var chartData: CombinedChartData?
	var indexs: [String]?

	private enum Type: String {
		case Number = "NUMBER"
		case Text = "TEXT"
		case Icon = "ICON"
	}

	required init(jsonDic: NSDictionary, withIndex index: Int) {
	}

	convenience init(jsonDic: NSDictionary, withIndex index: Int, indexSequence indexs: [String]) {
		self.init(jsonDic: jsonDic, withIndex: index)

		if let figure = jsonDic["figure"] as? String {
			
			if let json = Converts.serializationStringToDic(figure) {
				let dataFrameJson = DataFrameJson1(dic: json)
				if let data_ = dataFrameJson.data, index_ = dataFrameJson.index, columns_ = dataFrameJson.columns {
					if data_.count > 0 {
						if self.chartData == nil {
							self.chartData = CombinedChartData(xVals: indexs)
						}
						
						let scatterData = ScatterChartData()
						var entries = [ChartDataEntry]()
						var shape = ScatterChartDataSet.ScatterShape.Text
						
						for i in 0 ..< indexs.count {
							let basicIndex = indexs[i]
							for j in 0 ..< index_.count {
								let strIndex = index_[j]
								
								if basicIndex == strIndex {
									if let price = data_[j][0] as? Double {
										
										if let type = Type(rawValue: columns_[1]) {
											switch type {
											case .Number:
												shape = .Number
												let data = data_[j][1] as! Int
												entries.append(ChartDataEntry(value: price, xIndex: i, data: data))
											case .Text:
												shape = .Text
												let data = data_[j][1] as! String
												entries.append(ChartDataEntry(value: price, xIndex: i, data: data))
											case .Icon:
												shape = .Icon
												let data = data_[j][1] as! Int
												entries.append(ChartDataEntry(value: price, xIndex: i, data: data))
											}
										}
									}
								}
							}
						}

						let set = ScatterChartDataSet(yVals: entries, label: columns_[1])
						set.setColor(UIColor.redColor())
						set.scatterShape = shape
						set.scatterShapeSize = 6
						set.highlightEnabled = false
						set.drawValuesEnabled = false
						scatterData.addDataSet(set)
						self.chartData?.scatterData = scatterData
					}
				}
			}
		}
	}
}