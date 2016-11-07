//
//  ChartDataBean.swift
//  StockRemind
//
//  Created by dylan.zhang on 16/3/19.
//  Copyright © 2016年 dylan.zhang. All rights reserved.
//

import Foundation

struct DrawFeatureEnum {

	enum FunctionList: String {
		case DrawData = "DRAWDATA"		//使用数据字段中的数据绘制一条曲线
		case DrawBool = "DRAWBOOL"		//使用数据字段中的数据绘制布尔型值。可以对背景色彩的填充
		case DrawHLine = "DRAWHLINE"	//绘制一条水平线
		case DrawKLine = "DRAWKLINE"	//绘制k线
		case StickLine = "STICKLINE"	//有条件的绘制柱状图
		case DrawNumber = "DRAWNUMBER"	//绘制数字文本标注
		case DrawText = "DRAWTEXT"		//绘制文本标注
		case DrawVol = "DRAWVOL"		//绘制柱状图
		case DrawTicks = "DRAWTICKS"	//绘制分时图
		case DrawIcon = "DRAWICON"		//画icon
		case DrawPkline = "DRAWPKLINE"	//画pkline


		func desc() {
			switch self {
			case .DrawData:		print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制attr指定的图形")
			case .DrawBool:		print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制布尔型值，可以对背景色彩填充")
			case .DrawHLine:	print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制水平线")
			case .DrawKLine:	print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制蜡烛图")
			case .StickLine, .DrawVol:
								print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制柱状图")
			case .DrawNumber:	print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制数字文本标注")
			case .DrawText:		print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制文本标注")
			case .DrawTicks:	print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制分时图")
			case .DrawIcon:		print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制ICON")
			case .DrawPkline:	print(">>>>>>>>>>[ 绘图函数说明 ]: \(self.rawValue) 绘制带仓位的KLINE")
			}
		}
	}

	enum DrawAttr: String {
		case ColorStick = "COLORSTICK"	//绘制彩色的柱状图,如果颜色字段缺省，则以系统随机选定的颜色绘图
		case Stick = "STICK"
		case VolStick = "VOLSTICK"		//绘制与成交量柱状图相同的柱状图，如果上涨，显示红色，如果下跌，显示绿色
		case DotLine = "DOTLINE"		//绘制点划线的曲线图
		case CrossLine = "CROSSLINE"	//绘制交叉点形式的曲线图
		case CircleDot = "CIRCLEDOT"	//绘制圆点形式的曲线图
		case LineThick = "LINETHICK(N)"	//用数字标明的线宽绘制曲线图。N的取值为：0~9
		case PointDot = "POINTDOT"		//绘制虚线的曲线图
		case Default = "Curve"			//默认绘制曲线

		func desc() {
			switch self {
			case .ColorStick, .Stick, .VolStick:
				print(" [绘图属性]: \(self.rawValue) 绘制彩色的柱状图")
			case .DotLine:
				print(" [绘图属性]: \(self.rawValue) 绘制点划线的曲线图")
			case .CrossLine:
				print(" [绘图属性]: \(self.rawValue) 绘制交叉点形式的曲线图")
			case .CircleDot:
				print(" [绘图属性]: \(self.rawValue) 绘制圆点形式的曲线图")
			case .LineThick:
				print(" [绘图属性]: \(self.rawValue) 用数字标明的线宽绘制曲线图")
			case .PointDot:
				print(" [绘图属性]: \(self.rawValue) 绘制虚线的曲线图")
			case .Default:
				print(" [绘图属性]: \(self.rawValue) 绘制曲线图")
			}
		}
	}

	enum DrawColor: String {
		case Black = "BLACK"		//黑色
		case Gray = "GRAY"			//灰色
		case DarkGray = "DARKGRAY"	//暗灰
		case LightGray = "LIGHTGRAY"//浅灰
		case White = "WHITE"		//白色
		case Red = "RED"			//红色
		case Blue = "BLUE"			//蓝色
		case LiBlue = "LIBLUE"		//浅蓝色
		case LiRed = "LIRED"		//浅红色
		case Cyan = "CYAN"			//蓝绿色
		case LiCyan = "LICYAN"		//浅蓝绿色
		case Yellow = "YELLOW"		//黄色
		case Magenta = "MAGENTA"	//洋红色
		case LiMagenta = "LIMAGENTA"//浅洋红色
		case Orange = "ORANGE"		//橙色
		case Purple = "PURPLE"		//紫色
		case Brown = "BROWN"		//棕色
		case Green = "GREEN"		//绿色
		case LiGreen = "LIGREEN"	//浅绿色

		func colorValue() -> UIColor {
			switch self {
			case .Black:	return UIColor.blackColor()
			case .Gray:		return UIColor.grayColor()
			case .DarkGray:	return UIColor.darkGrayColor()
			case .LightGray:return UIColor.lightGrayColor()
			case .White:	return UIColor.whiteColor()
			case .Red:		return UIColor.redColor()
			case .Blue:		return UIColor.blueColor()
			case .LiBlue:	return UIColor(red: 30/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1.0)
			case .LiRed:	return UIColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1.0)
			case .Cyan:		return UIColor.cyanColor()
			case .LiCyan:	return UIColor.cyanColor().colorWithAlphaComponent(0.4)
			case .Yellow:	return UIColor.yellowColor()
			case .Magenta:	return UIColor.magentaColor()
			case .LiMagenta:return UIColor.magentaColor().colorWithAlphaComponent(0.4)
			case .Orange:	return UIColor.orangeColor()
			case .Purple:	return UIColor.purpleColor()
			case .Brown:	return UIColor.brownColor()
			case .Green:	return UIColor.greenColor()
			case .LiGreen:	return UIColor.greenColor().colorWithAlphaComponent(0.4)
			}
		}
	}

	enum DrawColorIndex: Int {
		case Black = 0
		case Purple = 1
		case Orange = 2
		case LiBlue = 3
		case Brown = 4
		case Green = 5
		case LiGreen = 6
		case Red = 7
		case Blue = 8
		case Gray = 9
		case DarkGray = 10
		case LightGray = 11
		case White = 12
		case LiRed = 13
		case Cyan = 14
		case LiCyan = 15
		case Yellow = 16
		case Magenta = 17
		case LiMagenta = 18

		func value() -> UIColor {
			switch self {
			case .Red:
				return UIColor.redColor()
			case .Blue:
				return UIColor.blueColor()
			case .Black:
				return UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
			case .Gray:
				return UIColor.grayColor()
			case .DarkGray:
				return UIColor.darkGrayColor()
			case .LightGray:
				return UIColor.lightGrayColor()
			case .White:
				return UIColor.whiteColor()
			case .LiBlue:
				return UIColor(red: 30/255.0, green: 144/255.0, blue: 255/255.0, alpha: 1.0)
			case .LiRed:
				return UIColor(red: 255/255.0, green: 99/255.0, blue: 71/255.0, alpha: 1.0)
			case .Cyan:
				return UIColor.cyanColor()
			case .LiCyan:
				return UIColor.cyanColor().colorWithAlphaComponent(0.4)
			case .Yellow:
				return UIColor.yellowColor()
			case .Magenta:
				return UIColor.magentaColor()
			case .LiMagenta:
				return UIColor.magentaColor().colorWithAlphaComponent(0.4)
			case .Orange:
				return UIColor(red: 255/255.0, green: 144/255.0, blue: 0/255.0, alpha: 1.0)
			case .Purple:
				return UIColor(red: 214/255.0, green: 67/255.0, blue: 227/255.0, alpha: 1.0)
			case .Brown:
				return UIColor.brownColor()
			case .Green:
				return UIColor.greenColor()
			case .LiGreen:
				return UIColor.greenColor().colorWithAlphaComponent(0.4)
			}
		}
	}
}
