//
//  ParseChartData.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/6/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

public struct ParseChartData {

	static var isTimeSharedData = false
	static var mainXAxisIndex: [String]?
	
	public var chartData: CombinedChartData?
	var changePct: [Double]?

	init(jsonStr: String) {
//		print("jsonStr----------> \(jsonStr)")

		if let dics = Converts.serializationStringToDics(jsonStr) {
			for index in 0 ..< dics.count {
				let dic = dics[index]
//				print("dic-----------> \(dic)")
				self.parseDictionary(dic, withIndex: index)
			}
		}
	}

	private mutating func parseDictionary(dic: NSDictionary, withIndex index: Int) {
		if let function = dic["function"] as? String {
			if let drawFunc = DrawFeatureEnum.FunctionList(rawValue: function) {
				drawFunc.desc()

				var data: CombinedChartData?
				switch drawFunc {
				case .DrawData:
					switch self.parseAttr(dic["attr"] as? String) {
					case .ColorStick, .Stick, .VolStick:
						let drawBar = DrawBar(jsonDic: dic, withIndex: index)
						data = drawBar.chartData
					case .DotLine:
						print("")
					case .CrossLine:
						print("")
					case .CircleDot:
						let drawData = DrawData(jsonDic: dic, withIndex: index, attr: DrawFeatureEnum.DrawAttr.CircleDot)
						data = drawData.chartData
					case .LineThick:
						print("")
					case .PointDot:
						let drawData = DrawData(jsonDic: dic, withIndex: index, attr: DrawFeatureEnum.DrawAttr.PointDot)
						data = drawData.chartData
					case .Default:
						print("")
						let drawData = DrawData(jsonDic: dic, withIndex: index)
						data = drawData.chartData
					}
				case .DrawKLine, .DrawPkline:
					let drawKLine = DrawKLine(jsonDic: dic, withIndex: index)
					data = drawKLine.chartData
					ParseChartData.mainXAxisIndex = drawKLine.indexs
				case .DrawVol:
					let drawBar = DrawBar(jsonDic: dic, withIndex: index)
					data = drawBar.chartData
					ParseChartData.isTimeSharedData = false
				case .DrawTicks:
					ParseChartData.isTimeSharedData = true
					let drawTicks = DrawTicks(jsonDic: dic, withIndex: index)
					data = drawTicks.chartData
					ParseChartData.mainXAxisIndex = drawTicks.indexs
					let dataSet = drawTicks.chartData?.lineData.getDataSetByIndex(0) as? LineChartDataSet
					if let customMax = dataSet?.customMaxVal, customMin = dataSet?.customMinVal {
						changePct = [Double]()
						changePct?.append(customMin)
						changePct?.append(customMax)
					}
				case .DrawIcon, .DrawText, .DrawNumber:
					if let _mainXAxisIndexs = ParseChartData.mainXAxisIndex {
						let drawIcon = DrawIconText(jsonDic: dic, withIndex: index, indexSequence: _mainXAxisIndexs)
						data = drawIcon.chartData
					}
				default:
					break
				}

				if let requestData = data {
					if let currChartData = self.chartData {

						if let requestLineData = requestData.lineData {
							if let lineData = currChartData.lineData {
								if ParseChartData.isTimeSharedData {
									self.chartData?.lineData.addDataSet(requestLineData.getDataSetByIndex(0))
								} else {
									lineData.addDataSet(requestLineData.getDataSetByIndex(0))
									self.chartData?.lineData = lineData
								}
							} else {
								self.chartData?.lineData = requestLineData
							}
						}
						
						if let requestCandleData = requestData.candleData {
							if let candleData = currChartData.candleData {
								candleData.addDataSet(requestCandleData.getDataSetByIndex(0))
								self.chartData?.candleData = candleData
							} else {
								self.chartData?.candleData = requestCandleData
							}
						}
						
						if let requestBarData = requestData.barData {
							if let barData = currChartData.barData {
								barData.addDataSet(requestBarData.getDataSetByIndex(0))
								self.chartData?.barData = barData
							} else {
								self.chartData?.barData = requestBarData
							}
						}
						
						if let requestScatterData = requestData.scatterData {
							if let scatterData = currChartData.scatterData {
								scatterData.addDataSet(requestScatterData.getDataSetByIndex(0))
								self.chartData?.scatterData = scatterData
							} else {
								self.chartData?.scatterData = requestScatterData
							}
						}
						
					} else {
						self.chartData = requestData
					}
				}
			}
		}
	}
	
	private func parseAttr(jsonStr: String?) -> DrawFeatureEnum.DrawAttr {
		if let attr = jsonStr {
			if let drawAttr = DrawFeatureEnum.DrawAttr(rawValue: attr) {
				drawAttr.desc()
				return drawAttr
			}
		}
		let defaultAttr = DrawFeatureEnum.DrawAttr.Default
		defaultAttr.desc()
		return defaultAttr
	}
}
