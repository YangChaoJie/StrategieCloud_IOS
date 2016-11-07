//
//  OptionLiveCell.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/25.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
protocol TextViewCellDelegate:NSObjectProtocol{
    func textClicked(name:String,code:String,type:Int)
}

protocol OptionalLiveDataSource {
    func setMessages(text:String)
    func setTimeText(time:String)
    func setMessageType(msgType:Int)
}
class OptionLiveCell: UITableViewCell ,UITextViewDelegate,OptionalLiveDataSource{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var myTextView: UITextView!
    var message = "" {
        didSet{
            //设置展示文本框的代理
            myTextView.delegate = self
            myTextView.scrollEnabled = false
			
			let item = ParseLiveItem(msg: message)
			myTextView.text = item.showMsg
			myTextView.handleStyle(item.msgTextList)
        }
    }
    var msgType : Int = 0
    var keyWord:[AnyObject] = []
    weak var delegate: TextViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: --UItextViewDelegate
    //展示文本框链接点击响应
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL,
                  inRange characterRange: NSRange) -> Bool {

		switch URL.scheme {
		case "ticker":
			let name = (textView.text as NSString).substringWithRange(characterRange)
			let ticker = URL.resourceSpecifier.stringByRemovingPercentEncoding!
			print("name---> \(name), ticker---> \(ticker)")
			delegate?.textClicked(name, code: ticker,type: self.msgType)
		default:
			print("")
		}
		
        return true
    }
    
    //MARK:DataSource
    func setMessages(text: String) {
        message = text
    }
    
    func setTimeText(time: String) {
        timeLabel.text = time
    }
    
    func setMessageType(msgType: Int) {
        self.msgType = msgType
    }
}
