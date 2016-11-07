//
//  BaseTopInfoView.swift
//  StrategieCloud_IOS
//
//  Created by dylan.zhang on 16/7/11.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class BaseTopInfoView: UIView {

	enum ViewType: Int {
		case TimeSharedLine
		case TimeSharedVolume
		case KLine
		case KLineVolume
	}
	
	func setLabels(datas: [ExternalData]) {
	}
}
