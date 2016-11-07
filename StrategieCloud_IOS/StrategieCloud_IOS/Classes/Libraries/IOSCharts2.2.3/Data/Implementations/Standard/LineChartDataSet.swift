//
//  LineChartDataSet.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 26/2/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/ios-charts
//

import Foundation
import CoreGraphics


public class LineChartDataSet: LineRadarChartDataSet, ILineChartDataSet
{
	public var customMaxVal: Double?
	public var customMinVal: Double?
	public var maxIndex: Int?
	
    private func initialize()
    {
        // default color
        circleColors.append(NSUIColor(red: 140.0/255.0, green: 234.0/255.0, blue: 255.0/255.0, alpha: 1.0))
    }
    
    public required init()
    {
        super.init()
        initialize()
    }
    
    public override init(yVals: [ChartDataEntry]?, label: String?)
    {
        super.init(yVals: yVals, label: label)
        initialize()
    }
	
	public override func calcMinMax(start start: Int, end: Int) {
		if self.customChart {
			let yValCount = _yVals.count
			if yValCount == 0 {
				return
			}
			
			var endValue : Int
			if end == 0 || end >= yValCount {
				endValue = yValCount - 1
			} else {
				endValue = end
			}
			
			_lastStart = start
			_lastEnd = endValue
			
			_yMin = DBL_MAX
			_yMax = -DBL_MAX
			
			var minChange: Double = DBL_MAX
			var maxChange: Double = -DBL_MAX
			var maxVal = Double(0)
			
			var tempMaxChange = Double(0)
			var tempMinChange = Double(0)
			
			for i in start ... endValue {
				let e = _yVals[i]
				if !e.value.isNaN {
					if let data = e.data as? [String] {
						let changePct = (data[0] as NSString).doubleValue
						if changePct < minChange {
							minChange = changePct
						}
						if changePct > maxChange {
							maxChange = changePct
							maxVal = e.value
						}
						
						if minChange == DBL_MAX {
							minChange = 0.0
							maxChange = 0.0
						}
						
						tempMaxChange = max(abs(maxChange), abs(minChange))
						tempMinChange = -tempMaxChange
						
						let baseVal = maxVal / ( 1 + maxChange / 100)
						
						_yMax = (1 + tempMaxChange / 100) * baseVal
						_yMin = (1 + tempMinChange / 100) * baseVal
						
						self.customMaxVal = tempMaxChange
						self.customMinVal = tempMinChange
					} else {
						if e.value < _yMin {
							_yMin = e.value
						}
						if e.value > _yMax {
							_yMax = e.value
						}
					}
				}
			}
		} else {
			super.calcMinMax(start: start, end: end)
		}
	}
    
    // MARK: - Data functions and accessors
    
    // MARK: - Styling functions and accessors
    
    private var _cubicIntensity = CGFloat(0.2)
    
    /// Intensity for cubic lines (min = 0.05, max = 1)
    ///
    /// **default**: 0.2
    public var cubicIntensity: CGFloat
    {
        get
        {
            return _cubicIntensity
        }
        set
        {
            _cubicIntensity = newValue
            if (_cubicIntensity > 1.0)
            {
                _cubicIntensity = 1.0
            }
            if (_cubicIntensity < 0.05)
            {
                _cubicIntensity = 0.05
            }
        }
    }
    
    /// If true, cubic lines are drawn instead of linear
    public var drawCubicEnabled = false
    
    /// - returns: true if drawing cubic lines is enabled, false if not.
    public var isDrawCubicEnabled: Bool { return drawCubicEnabled }
    
    /// The radius of the drawn circles.
    public var circleRadius = CGFloat(8.0)
    
    public var circleColors = [NSUIColor]()
    
    /// - returns: the color at the given index of the DataSet's circle-color array.
    /// Performs a IndexOutOfBounds check by modulus.
    public func getCircleColor(var index: Int) -> NSUIColor?
    {
        let size = circleColors.count
        index = index % size
        if (index >= size)
        {
            return nil
        }
        return circleColors[index]
    }
    
    /// Sets the one and ONLY color that should be used for this DataSet.
    /// Internally, this recreates the colors array and adds the specified color.
    public func setCircleColor(color: NSUIColor)
    {
        circleColors.removeAll(keepCapacity: false)
        circleColors.append(color)
    }
    
    /// Resets the circle-colors array and creates a new one
    public func resetCircleColors(index: Int)
    {
        circleColors.removeAll(keepCapacity: false)
    }
    
    /// If true, drawing circles is enabled
    public var drawCirclesEnabled = true
    
    /// - returns: true if drawing circles for this DataSet is enabled, false if not
    public var isDrawCirclesEnabled: Bool { return drawCirclesEnabled }
    
    /// The color of the inner circle (the circle-hole).
    public var circleHoleColor = NSUIColor.whiteColor()
    
    /// True if drawing circles for this DataSet is enabled, false if not
    public var drawCircleHoleEnabled = true
    
    /// - returns: true if drawing the circle-holes is enabled, false if not.
    public var isDrawCircleHoleEnabled: Bool { return drawCircleHoleEnabled }
    
    /// This is how much (in pixels) into the dash pattern are we starting from.
    public var lineDashPhase = CGFloat(0.0)
    
    /// This is the actual dash pattern.
    /// I.e. [2, 3] will paint [--   --   ]
    /// [1, 3, 4, 2] will paint [-   ----  -   ----  ]
    public var lineDashLengths: [CGFloat]?
	
	public var customChart = false
    
    /// formatter for customizing the position of the fill-line
    private var _fillFormatter: ChartFillFormatter = ChartDefaultFillFormatter()
    
    /// Sets a custom FillFormatter to the chart that handles the position of the filled-line for each DataSet. Set this to null to use the default logic.
    public var fillFormatter: ChartFillFormatter?
    {
        get
        {
            return _fillFormatter
        }
        set
        {
            if newValue == nil
            {
                _fillFormatter = ChartDefaultFillFormatter()
            }
            else
            {
                _fillFormatter = newValue!
            }
        }
    }
    
    // MARK: NSCopying
    
    public override func copyWithZone(zone: NSZone) -> AnyObject
    {
        let copy = super.copyWithZone(zone) as! LineChartDataSet
        copy.circleColors = circleColors
        copy.circleRadius = circleRadius
        copy.cubicIntensity = cubicIntensity
        copy.lineDashPhase = lineDashPhase
        copy.lineDashLengths = lineDashLengths
        copy.drawCirclesEnabled = drawCirclesEnabled
        copy.drawCubicEnabled = drawCubicEnabled
        return copy
    }
}
