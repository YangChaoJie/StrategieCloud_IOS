//
//  ScatterChartRenderer.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 4/3/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

import Foundation
import CoreGraphics

#if !os(OSX)
    import UIKit
#endif


public class ScatterChartRenderer: LineScatterCandleRadarChartRenderer
{
    public weak var dataProvider: ScatterChartDataProvider?

	enum IconType: Double {
		case BuyPoint = 1
		case SellPoint = 2
		case UnconfirmedBuyPoint = 3
		case UnconfirmedSellPoint = 4
		case BuyLine = 5
		case SellLine = 6
		case RapidlyRise = 24
		case LargeVolume = 25

		func iconName() -> String {
			switch self {
			case .BuyPoint:
				return "BuyPoint"
			case .UnconfirmedBuyPoint:
				return "UnconfirmedBuyPoint"
			case .SellPoint:
				return "SellPoint"
			case .UnconfirmedSellPoint:
				return "UnconfirmedSellPoint"
			case .BuyLine:
				return "BuyLine"
			case .SellLine:
				return "SellLine"
			case .RapidlyRise:
				return "rapidlyRise"
			case .LargeVolume:
				return "largeVolume"
			}
		}
	}
    
    public init(dataProvider: ScatterChartDataProvider?, animator: ChartAnimator?, viewPortHandler: ChartViewPortHandler)
    {
        super.init(animator: animator, viewPortHandler: viewPortHandler)
        
        self.dataProvider = dataProvider
    }
    
    public override func drawData(context context: CGContext)
    {
        guard let scatterData = dataProvider?.scatterData else { return }
        
        for (var i = 0; i < scatterData.dataSetCount; i++)
        {
            guard let set = scatterData.getDataSetByIndex(i) else { continue }
            
            if set.isVisible
            {
                if !(set is IScatterChartDataSet)
                {
                    fatalError("Datasets for ScatterChartRenderer must conform to IScatterChartDataSet")
                }
                
                drawDataSet(context: context, dataSet: set as! IScatterChartDataSet)
            }
        }
    }
    
    private var _lineSegments = [CGPoint](count: 2, repeatedValue: CGPoint())
    
    public func drawDataSet(context context: CGContext, dataSet: IScatterChartDataSet)
    {
        guard let
            dataProvider = dataProvider,
            animator = animator
            else { return }
        
        let trans = dataProvider.getTransformer(dataSet.axisDependency)
        
        let phaseY = animator.phaseY
        
        let entryCount = dataSet.entryCount
        
        let shapeSize = dataSet.scatterShapeSize
        let shapeHalf = shapeSize / 2.0
        let shapeHoleSizeHalf = dataSet.scatterShapeHoleRadius
        let shapeHoleSize = shapeHoleSizeHalf * 2.0
        let shapeHoleColor = dataSet.scatterShapeHoleColor
        let shapeStrokeSize = (shapeSize - shapeHoleSize) / 2.0
        let shapeStrokeSizeHalf = shapeStrokeSize / 2.0
        
        var point = CGPoint()
        
        let valueToPixelMatrix = trans.valueToPixelMatrix
        
        let shape = dataSet.scatterShape
        
        CGContextSaveGState(context)
        
        for (var j = 0, count = Int(min(ceil(CGFloat(entryCount) * animator.phaseX), CGFloat(entryCount))); j < count; j++)
        {
            guard let e = dataSet.entryForIndex(j) else { continue }
            
            point.x = CGFloat(e.xIndex)
            point.y = CGFloat(e.value) * phaseY
            point = CGPointApplyAffineTransform(point, valueToPixelMatrix);            
            
            if (!viewPortHandler.isInBoundsRight(point.x))
            {
                break
            }
            
            if (!viewPortHandler.isInBoundsLeft(point.x) || !viewPortHandler.isInBoundsY(point.y))
            {
                continue
            }
            
            if (shape == .Square)
            {
                if shapeHoleSize > 0.0
                {
                    CGContextSetStrokeColorWithColor(context, dataSet.colorAt(j).CGColor)
                    CGContextSetLineWidth(context, shapeStrokeSize)
                    var rect = CGRect()
                    rect.origin.x = point.x - shapeHoleSizeHalf - shapeStrokeSizeHalf
                    rect.origin.y = point.y - shapeHoleSizeHalf - shapeStrokeSizeHalf
                    rect.size.width = shapeHoleSize + shapeStrokeSize
                    rect.size.height = shapeHoleSize + shapeStrokeSize
                    CGContextStrokeRect(context, rect)
                    
                    if let shapeHoleColor = shapeHoleColor
                    {
                        CGContextSetFillColorWithColor(context, shapeHoleColor.CGColor)
                        rect.origin.x = point.x - shapeHoleSizeHalf
                        rect.origin.y = point.y - shapeHoleSizeHalf
                        rect.size.width = shapeHoleSize
                        rect.size.height = shapeHoleSize
                        CGContextFillRect(context, rect)
                    }
                }
                else
                {
                    CGContextSetFillColorWithColor(context, dataSet.colorAt(j).CGColor)
                    var rect = CGRect()
                    rect.origin.x = point.x - shapeHalf
                    rect.origin.y = point.y - shapeHalf
                    rect.size.width = shapeSize
                    rect.size.height = shapeSize
                    CGContextFillRect(context, rect)
                }
            }
            else if (shape == .Circle)
            {
                if shapeHoleSize > 0.0
                {
                    CGContextSetStrokeColorWithColor(context, dataSet.colorAt(j).CGColor)
                    CGContextSetLineWidth(context, shapeStrokeSize)
                    var rect = CGRect()
                    rect.origin.x = point.x - shapeHoleSizeHalf - shapeStrokeSizeHalf
                    rect.origin.y = point.y - shapeHoleSizeHalf - shapeStrokeSizeHalf
                    rect.size.width = shapeHoleSize + shapeStrokeSize
                    rect.size.height = shapeHoleSize + shapeStrokeSize
                    CGContextStrokeEllipseInRect(context, rect)
                    
                    if let shapeHoleColor = shapeHoleColor
                    {
                        CGContextSetFillColorWithColor(context, shapeHoleColor.CGColor)
                        rect.origin.x = point.x - shapeHoleSizeHalf
                        rect.origin.y = point.y - shapeHoleSizeHalf
                        rect.size.width = shapeHoleSize
                        rect.size.height = shapeHoleSize
                        CGContextFillEllipseInRect(context, rect)
                    }
                }
                else
                {
                    CGContextSetFillColorWithColor(context, dataSet.colorAt(j).CGColor)
                    var rect = CGRect()
                    rect.origin.x = point.x - shapeHalf
                    rect.origin.y = point.y - shapeHalf
                    rect.size.width = shapeSize
                    rect.size.height = shapeSize
                    CGContextFillEllipseInRect(context, rect)
                }
            }
            else if (shape == .Triangle)
            {
                CGContextSetFillColorWithColor(context, dataSet.colorAt(j).CGColor)
                
                // create a triangle path
                CGContextBeginPath(context)
                CGContextMoveToPoint(context, point.x, point.y - shapeHalf)
                CGContextAddLineToPoint(context, point.x + shapeHalf, point.y + shapeHalf)
                CGContextAddLineToPoint(context, point.x - shapeHalf, point.y + shapeHalf)
                
                if shapeHoleSize > 0.0
                {
                    CGContextAddLineToPoint(context, point.x, point.y - shapeHalf)
                    
                    CGContextMoveToPoint(context, point.x - shapeHalf + shapeStrokeSize, point.y + shapeHalf - shapeStrokeSize)
                    CGContextAddLineToPoint(context, point.x + shapeHalf - shapeStrokeSize, point.y + shapeHalf - shapeStrokeSize)
                    CGContextAddLineToPoint(context, point.x, point.y - shapeHalf + shapeStrokeSize)
                    CGContextAddLineToPoint(context, point.x - shapeHalf + shapeStrokeSize, point.y + shapeHalf - shapeStrokeSize)
                }
                
                CGContextClosePath(context)
                
                CGContextFillPath(context)
                
                if shapeHoleSize > 0.0 && shapeHoleColor != nil
                {
                    CGContextSetFillColorWithColor(context, shapeHoleColor!.CGColor)
                    
                    // create a triangle path
                    CGContextBeginPath(context)
                    CGContextMoveToPoint(context, point.x, point.y - shapeHalf + shapeStrokeSize)
                    CGContextAddLineToPoint(context, point.x + shapeHalf - shapeStrokeSize, point.y + shapeHalf - shapeStrokeSize)
                    CGContextAddLineToPoint(context, point.x - shapeHalf + shapeStrokeSize, point.y + shapeHalf - shapeStrokeSize)
                    CGContextClosePath(context)
                    
                    CGContextFillPath(context)
                }
            }
            else if (shape == .Cross)
            {
                CGContextSetStrokeColorWithColor(context, dataSet.colorAt(j).CGColor)
                _lineSegments[0].x = point.x - shapeHalf
                _lineSegments[0].y = point.y
                _lineSegments[1].x = point.x + shapeHalf
                _lineSegments[1].y = point.y
                CGContextStrokeLineSegments(context, _lineSegments, 2)
                
                _lineSegments[0].x = point.x
                _lineSegments[0].y = point.y - shapeHalf
                _lineSegments[1].x = point.x
                _lineSegments[1].y = point.y + shapeHalf
                CGContextStrokeLineSegments(context, _lineSegments, 2)
            }
            else if (shape == .X)
            {
                CGContextSetStrokeColorWithColor(context, dataSet.colorAt(j).CGColor)
                _lineSegments[0].x = point.x - shapeHalf
                _lineSegments[0].y = point.y - shapeHalf
                _lineSegments[1].x = point.x + shapeHalf
                _lineSegments[1].y = point.y + shapeHalf
                CGContextStrokeLineSegments(context, _lineSegments, 2)
                
                _lineSegments[0].x = point.x + shapeHalf
                _lineSegments[0].y = point.y - shapeHalf
                _lineSegments[1].x = point.x - shapeHalf
                _lineSegments[1].y = point.y + shapeHalf
                CGContextStrokeLineSegments(context, _lineSegments, 2)
            }
            else if (shape == .Custom)
            {
                CGContextSetFillColorWithColor(context, dataSet.colorAt(j).CGColor)
                
                let customShape = dataSet.customScatterShape
                
                if customShape == nil
                {
                    return
                }
                
                // transform the provided custom path
                CGContextSaveGState(context)
                CGContextTranslateCTM(context, point.x, point.y)
                
                CGContextBeginPath(context)
                CGContextAddPath(context, customShape)
                CGContextFillPath(context)
                
                CGContextRestoreGState(context)
			} else if (shape == .Text) {
				CGContextSaveGState(context)
				let attrs = [
					NSForegroundColorAttributeName: dataSet.colorAt(j),
					NSFontAttributeName: UIFont.systemFontOfSize(8)
				]
				if let data = e.data as? String {
					let drawData = data as NSString
					drawData.drawAtPoint(point, withAttributes: attrs)
				}
				CGContextRestoreGState(context)
			} else if (shape == .Number) {
				CGContextSaveGState(context)
				let attrs = [
					NSForegroundColorAttributeName: dataSet.colorAt(j),
					NSFontAttributeName: UIFont.systemFontOfSize(8)
				]
				if let data = e.data as? Double {
					let drawData = NSString(format: "%.2f", data)
					drawData.drawAtPoint(point, withAttributes: attrs)
				}
				CGContextRestoreGState(context)
			} else if (shape == .Icon) {
				CGContextSaveGState(context)
				if let data = e.data as? Double {
					if let iconType = IconType(rawValue: data) {

						let img = UIImage(named: iconType.iconName())!
						let aspectRatio = img.size.width / img.size.height

						let bsswitchStatus = NSUserDefaults.standardUserDefaults().boolForKey(KLineTopInfoView.BSSwitchKey)
						switch iconType {
						case .BuyPoint, .UnconfirmedBuyPoint:
							if bsswitchStatus {
								let defaultWidth = CGFloat(15)
								let size = CGSizeMake(defaultWidth, defaultWidth / aspectRatio)
								let imgPoint = CGPointMake(point.x - defaultWidth / 2, point.y)
								img.drawInRect(CGRect(origin: imgPoint, size: size))
							}
						case .SellPoint, .UnconfirmedSellPoint:
							if bsswitchStatus {
								let defaultWidth = CGFloat(15)
								let size = CGSizeMake(defaultWidth, defaultWidth / aspectRatio)
								let imgPoint = CGPointMake(point.x - defaultWidth / 2, point.y - size.height)
								img.drawInRect(CGRect(origin: imgPoint, size: size))
							}
						case .BuyLine, .SellLine:
							let defaultWidth = CGFloat(12)
//							if bsswitchStatus {
								let attrs = [
									NSForegroundColorAttributeName: UIColor.blackColor(),
									NSFontAttributeName: UIFont.boldSystemFontOfSize(10),
									NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue
								]
								let drawDataStr = " \(String(format: "%.2f", e.value)) " as NSString
								let textSize = drawDataStr.boundingRectWithSize(CGSizeMake(100, 60), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attrs, context: nil)
								let strPoint = CGPointMake(viewPortHandler.contentRight - textSize.width + 1, point.y - textSize.height + 1)
								drawDataStr.drawAtPoint(strPoint, withAttributes: attrs)

								let size = CGSizeMake(defaultWidth, defaultWidth)
								let imgPoint = CGPointMake(viewPortHandler.contentRight - 2, point.y - 6)
								img.drawInRect(CGRect(origin: imgPoint, size: size))
						case .LargeVolume:
							let defaultWidth = CGFloat(26)
							let size = CGSizeMake(defaultWidth, defaultWidth / aspectRatio)
							let imgPoint = CGPointMake(point.x - size.width / 2, point.y - size.height / 2)
							img.drawInRect(CGRect(origin: imgPoint, size: size))
						case .RapidlyRise:
							let defaultWidth = CGFloat(26)
							let size = CGSizeMake(defaultWidth, defaultWidth / aspectRatio)
							let imgPoint = CGPointMake(point.x - size.width / 2, point.y - size.height / 2)
							img.drawInRect(CGRect(origin: imgPoint, size: size))
						}
					}
				}
				CGContextRestoreGState(context)
			}
        }
        
        CGContextRestoreGState(context)
    }
    
    public override func drawValues(context context: CGContext)
    {
        guard let
            dataProvider = dataProvider,
            scatterData = dataProvider.scatterData,
            animator = animator
            else { return }
        
        // if values are drawn
        if (scatterData.yValCount < Int(ceil(CGFloat(dataProvider.maxVisibleValueCount) * viewPortHandler.scaleX)))
        {
            guard let dataSets = scatterData.dataSets as? [IScatterChartDataSet] else { return }
            
            let phaseX = animator.phaseX
            let phaseY = animator.phaseY
            
            var pt = CGPoint()
            
            for (var i = 0; i < scatterData.dataSetCount; i++)
            {
                let dataSet = dataSets[i]
                
                if !dataSet.isDrawValuesEnabled || dataSet.entryCount == 0
                {
                    continue
                }
                
                let valueFont = dataSet.valueFont
                
                guard let formatter = dataSet.valueFormatter else { continue }
                
                let trans = dataProvider.getTransformer(dataSet.axisDependency)
                let valueToPixelMatrix = trans.valueToPixelMatrix
                
                let entryCount = dataSet.entryCount
                
                let shapeSize = dataSet.scatterShapeSize
                let lineHeight = valueFont.lineHeight
                
                for (var j = 0, count = Int(ceil(CGFloat(entryCount) * phaseX)); j < count; j++)
                {
                    guard let e = dataSet.entryForIndex(j) else { break }
                    
                    pt.x = CGFloat(e.xIndex)
                    pt.y = CGFloat(e.value) * phaseY
                    pt = CGPointApplyAffineTransform(pt, valueToPixelMatrix)
                    
                    if (!viewPortHandler.isInBoundsRight(pt.x))
                    {
                        break
                    }
                    
                    // make sure the lines don't do shitty things outside bounds
                    if ((!viewPortHandler.isInBoundsLeft(pt.x)
                        || !viewPortHandler.isInBoundsY(pt.y)))
                    {
                        continue
                    }
                    
                    let text = formatter.stringFromNumber(e.value)
                    
                    ChartUtils.drawText(
                        context: context,
                        text: text!,
                        point: CGPoint(
                            x: pt.x,
                            y: pt.y - shapeSize - lineHeight),
                        align: .Center,
                        attributes: [NSFontAttributeName: valueFont, NSForegroundColorAttributeName: dataSet.valueTextColorAt(j)]
                    )
                }
            }
        }
    }
    
    public override func drawExtras(context context: CGContext)
    {
        
    }
	
	public override func drawExternalData(context context: CGContext, withIndices indices: [ChartHighlight], completionHandle: ([ExternalData]) -> Void) {
		
	}
    
    private var _highlightPointBuffer = CGPoint()
    
    public override func drawHighlighted(context context: CGContext, indices: [ChartHighlight])
    {
        guard let
            dataProvider = dataProvider,
            scatterData = dataProvider.scatterData,
            animator = animator
            else { return }
        
        let chartXMax = dataProvider.chartXMax
        
        CGContextSaveGState(context)
        
        for (var i = 0; i < indices.count; i++)
        {
            guard let set = scatterData.getDataSetByIndex(indices[i].dataSetIndex) as? IScatterChartDataSet else { continue }
            
            if !set.isHighlightEnabled
            {
                continue
            }
            
            CGContextSetStrokeColorWithColor(context, set.highlightColor.CGColor)
            CGContextSetLineWidth(context, set.highlightLineWidth)
            if (set.highlightLineDashLengths != nil)
            {
                CGContextSetLineDash(context, set.highlightLineDashPhase, set.highlightLineDashLengths!, set.highlightLineDashLengths!.count)
            }
            else
            {
                CGContextSetLineDash(context, 0.0, nil, 0)
            }
            
            let xIndex = indices[i].xIndex; // get the x-position
            
            if (CGFloat(xIndex) > CGFloat(chartXMax) * animator.phaseX)
            {
                continue
            }
            
            let yVal = set.yValForXIndex(xIndex)
            if (yVal.isNaN)
            {
                continue
            }
            
            let y = CGFloat(yVal) * animator.phaseY; // get the y-position
            
            _highlightPointBuffer.x = CGFloat(xIndex)
            _highlightPointBuffer.y = y
            
            let trans = dataProvider.getTransformer(set.axisDependency)
            
            trans.pointValueToPixel(&_highlightPointBuffer)
            
            // draw the lines
            drawHighlightLines(context: context, point: _highlightPointBuffer, set: set)
        }
        
        CGContextRestoreGState(context)
    }
}
