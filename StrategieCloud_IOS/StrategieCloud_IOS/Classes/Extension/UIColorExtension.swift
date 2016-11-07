//
//  UIColorExtension.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/1.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation

extension UIColor {
	
	class func colorWith(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor {
		let color = UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
		return color
	}

	class func appBarTintColor() -> UIColor {
		return UIColor(red: 66/255.0, green: 133/255.0, blue: 244/255.0, alpha: 1.0)
	}
	
	class func appBarColor() -> UIColor {
		return UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
	}
	
	class func TimeSharedPriceColor() -> UIColor {
		return UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 1.0)
	}
	
	class func NavBarColor() -> UIColor {
		return UIColor(red: 66/255.0, green: 133/255.0, blue: 244/255.0, alpha: 1)
	}
	
	class func KLineDownColor() -> UIColor {
		return UIColor(red: 34/255.0, green: 172/255.0, blue: 56/255.0, alpha: 1.0)
	}
	
	class func KLineUpColor() -> UIColor {
		return UIColor(red: 255/255.0, green: 29/255.0, blue: 52/255.0, alpha: 1.0)
	}
	
	class func TextUpColor() -> UIColor {
		return UIColor(red: 255/255.0, green: 78/255.0, blue: 86/255.0, alpha: 1.0)
	}
	
	class func TextDownColor() -> UIColor {
		return UIColor(red: 29/255.0, green: 191/255.0, blue: 96/255.0, alpha: 1.0)
	}
	
	class func TextHintColor() -> UIColor {
		return UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)
	}

	class func ShieldColor() -> UIColor {
		return UIColor(red: 230/255.0, green: 234/255.0, blue: 240/255.0, alpha: 1.0)
	}
	
	class func BacktestBaseColor() -> UIColor {
		return UIColor(red: 43/255.0, green: 175/255.0, blue: 255/255.0, alpha: 1.0)
	}
	
	class func BacktestAssetColor() -> UIColor {
		return UIColor(red: 255/255.0, green: 105/255.0, blue: 26/255.0, alpha: 1.0)
	}
	
	class func BacktestBuyColor() -> UIColor {
		return UIColor(red: 255/255.0, green: 166/255.0, blue: 170/255.0, alpha: 1.0)
	}
	
	class func BacktestSellColor() -> UIColor {
		return UIColor(red: 135/255.0, green: 227/255.0, blue: 135/255.0, alpha: 1.0)
	}
	
	class func TabBarHighlightColor() -> UIColor {
		return UIColor.colorWith(66, green: 133, blue: 244, alpha: 1.0)
	}
	
	class func TabBarNormalColor() -> UIColor {
		return UIColor.colorWith(128, green: 143, blue: 158, alpha: 1.0)
	}
	
	class func PageControlHighColor() -> UIColor {
		return UIColor.colorWith(66, green: 133, blue: 244, alpha: 1.0)
	}
	
	class func PageControlNormalColor() -> UIColor {
		return UIColor.colorWith(204, green: 204, blue: 204, alpha: 1.0)
	}
	
	class func TopHintTextColor() -> UIColor {
		return UIColor.colorWith(53, green: 67, blue: 70, alpha: 1.0)
	}
	
	class func TopSplitLineColor() -> UIColor {
		return UIColor.colorWith(213, green: 223, blue: 230, alpha: 1.0)
	}
	
	class func StockItemNameColor() -> UIColor {
		return UIColor.colorWith(53, green: 67, blue: 70, alpha: 1.0)
	}
	
	class func StockItemCodeColor() -> UIColor {
		return UIColor.colorWith(150, green: 166, blue: 178, alpha: 1.0)
	}
    
    class func headerRefreshTextColor()->UIColor {
        return UIColor.colorWith(146, green: 160, blue: 172, alpha: 1)
    }
}