//
//  DrawKLine.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/23.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

class DrawKLine: BaseDrawFunc {
	
	enum TradePosition: Int {
		case ZeroPos = 0		//	空仓
		case OneThreePos = 1	//	1/3仓位
		case TwoThreePos = 2	//	2/3仓位
		case FullPos = 3		//  满仓
	}
	

	private enum KLineValueType: String {
		case Open = "OPEN"
		case Close = "CLOSE"
		case High = "HIGH"
		case Low = "LOW"
		case Position = "POSITION"

		func desc() -> String {
			switch self {
			case .High:		return "高"
			case .Low:		return "低"
			case .Open:		return "开"
			case .Close:	return "收"
			case .Position: return "仓位"
			}
		}
	}

	var chartData: CombinedChartData?
	var indexs: [String]?

	required init(jsonDic: NSDictionary, withIndex index: Int) {
		_ = jsonDic["indicator"] as? String
		
		if let figure = jsonDic["figure"] as? String {
			if let json = Converts.serializationStringToDic(figure) {
				let dataFrameJson = KLineDataFrameJson(dic: json)
				if let datas = dataFrameJson.data, indexs = dataFrameJson.index, columns = dataFrameJson.columns {
					self.indexs = indexs
					if datas.count > 0 {
						if self.chartData == nil {
							self.chartData = CombinedChartData(xVals: indexs)
						}

						var openIndex = Int(0)
						var closeIndex = Int(0)
						var highIndex = Int(0)
						var lowIndex = Int(0)
						var posIndex: Int?

						
						for (index, item) in columns.enumerate() {
							if let type = KLineValueType(rawValue: item) {
								switch type {
								case .Open: openIndex = index
								case .Close:closeIndex = index
								case .High:	highIndex = index
								case .Low:	lowIndex = index
								case .Position: posIndex = index
								}
							}
						}

						let candleData = CandleChartData()
						var entries = [CandleChartDataEntry]()
						for i in 0 ..< datas.count {
							if let _posIndex = posIndex {
								let posValue = String(datas[i][_posIndex])
								entries.append(CandleChartDataEntry(xIndex: i,
									shadowH: Double(datas[i][highIndex]),
									shadowL: Double(datas[i][lowIndex]),
									open: Double(datas[i][openIndex]),
									close: Double(datas[i][closeIndex]),
									data: [indexs[i], posValue]))
							} else {
								entries.append(CandleChartDataEntry(xIndex: i,
									shadowH: Double(datas[i][highIndex]),
									shadowL: Double(datas[i][lowIndex]),
									open: Double(datas[i][openIndex]),
									close: Double(datas[i][closeIndex]),
									data: indexs[i]))
							}
						}

						let itemsName = KLineValueType.High.desc() + "," +
							KLineValueType.Low.desc() + "," +
							KLineValueType.Open.desc()
						
						let dataSet = CandleChartDataSet(yVals: entries, label: itemsName)
						dataSet.axisDependency = ChartYAxis.AxisDependency.Left
						dataSet.shadowWidth = 0.6
						dataSet.decreasingColor = UIColor.KLineDownColor()
						dataSet.decreasingFilled = true
						dataSet.increasingColor = UIColor.KLineUpColor()
						dataSet.increasingFilled = false
						dataSet.neutralColor = UIColor.KLineUpColor()
						dataSet.drawValuesEnabled = false
						dataSet.shadowColorSameAsCandle = true
						dataSet.highlightEnabled = true

						candleData.addDataSet(dataSet)
						self.chartData?.candleData = candleData
					}
				}
			}
		}
	}
}