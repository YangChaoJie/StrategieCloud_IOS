//
//  ProtocolView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class ProtocolView: BaseVC {

    @IBOutlet weak var myTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.layoutManager.allowsNonContiguousLayout = false
        myTextView.editable  = false
        myTextView.frame.size.height = AppHeight-280
        self.title = "用户协议"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
