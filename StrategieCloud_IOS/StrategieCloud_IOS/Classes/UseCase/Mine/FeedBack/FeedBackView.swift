//
//  FeedBackView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/28.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
class FeedBackView: BaseVC ,FeedBackViewProtocol{

    @IBOutlet weak var myTextView: UITextView!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    var presenter: FeedBackPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        initCommit()
        initMyText()
        setControlState()
    }
    
    
    @IBAction func sendMial(sender: AnyObject) {
        if examineTextLength() {
           presenter?.suggest(myTextView.text)
        }
    }
    
    private func initCommit() {
        presenter = FeedBackPresenter()
        presenter?.view = self
    }
    
    func examineTextLength()->Bool {
        if NSString(string: myTextView.text).length < 4 {
            helper.messageShow("字符长度为4~200", view: self)
            return false
        }else if NSString(string: myTextView.text).length >= 200 {
            helper.messageShow("字符长度为4~200", view: self)
            return false
        }
        return true
    }
    
    private func initMyText() {
		
        myTextView.text = "请提出你的宝贵意见，我们会做得更好..."
        myTextView.textColor = UIColor.lightGrayColor()
        
        myTextView.delegate = self
        myTextView.becomeFirstResponder()
        myTextView.selectedTextRange = myTextView.textRangeFromPosition(myTextView.beginningOfDocument, toPosition: myTextView.beginningOfDocument)
    }

    private func setControlState() {
		sendBtn.backgroundColor = UIColor.orangeColor()
		sendBtn.layer.cornerRadius = 4
		myTextView.layer.borderColor=UIColor.grayColor().CGColor
      // myTextView.returnKeyType = UIReturnKeyType.Send
    }
    
    //MARK: view Protocol
    func comeBackToMineView() {
        hudView.noticeOnlyText2("发送成功")
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension FeedBackView: UITextViewDelegate,UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "请提出你的宝贵意见，我们会做得更好..."
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
        }
    }
}
