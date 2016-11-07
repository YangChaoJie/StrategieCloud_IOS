//
//  UserNameView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/30.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class UserNameView: UIViewController, LoginViewProtocol{
    
    var presenter: LoginPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.colorWith(240, green: 244, blue: 250, alpha: 1.0)
        self.view.addSubview(nameTextField)
        self.nameTextField.becomeFirstResponder()
        initNavTitileView()
    }
    
    func notifyFetchSuccess() {
     
    }
	
	func uploadImageFailure() {
		
	}
    
    private func initNavTitileView()  {
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView: self.completeBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
   //MARK: private Life
    private lazy var nameTextField : UITextField = {
     let height = CGFloat(44)
      let _textFiled = UITextField()
      _textFiled.frame = CGRectMake(0, height, AppWidth, height)
      _textFiled.backgroundColor = UIColor.whiteColor()
      _textFiled.placeholder = "输入昵称,最多十个字符"
      _textFiled.textAlignment = .Center
      return _textFiled
    }()
    //MARK: setter and getter
    private lazy var completeBtn : UIButton = {
        let btn = UIButton()
        let width = CGFloat(50)
        btn.frame = CGRectMake(0, 0, width, width)
        btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.setTitle("完成", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(complete), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    func complete()  {
        UserMannager.instance.setUserName(self.nameTextField.text!)
        self.presenter?.comeBackUserNameView(self.navigationController!,name:self.nameTextField.text!)
    }
   
}
