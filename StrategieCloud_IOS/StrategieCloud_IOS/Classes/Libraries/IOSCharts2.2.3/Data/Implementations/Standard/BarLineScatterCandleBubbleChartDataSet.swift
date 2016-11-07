//
//  BarLineScatterCandleBubbleChartDataSet.swift
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


public class BarLineScatterCandleBubbleChartDataSet: ChartDataSet, IBarLineScatterCandleBubbleChartDataSet
{
    // MARK: - Data functions and accessors
    
    // MARK: - Styling functions and accessors

	public var highlightColor = NSUIColor(red: 84/255.0, green: 95/255.0, blue: 115/255.0, alpha: 1.0)
    public var highlightLineWidth = CGFloat(0.8)
    public var highlightLineDashPhase = CGFloat(0.0)
    public var highlightLineDashLengths: [CGFloat]?
    
    // MARK: - NSCopying
    
    public override func copyWithZone(zone: NSZone) -> AnyObject
    {
        let copy = super.copyWithZone(zone) as! BarLineScatterCandleBubbleChartDataSet
        copy.highlightColor = highlightColor
        copy.highlightLineWidth = highlightLineWidth
        copy.highlightLineDashPhase = highlightLineDashPhase
        copy.highlightLineDashLengths = highlightLineDashLengths
        return copy
    }
}
