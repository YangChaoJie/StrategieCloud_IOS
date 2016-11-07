//
//  RegisterViewController.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/27.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController,LoginViewProtocol {
  
    var presenter: LoginPresenterProtocol?
    //MARK: viewController Life
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
    }

      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK: private Method
   private func createView()  {
        addScrollView()
        addTextField()
        addButton()
        addProtocolView()
    }
    //创建滑动式图
   private func addScrollView(){
        view = backScrollView
    }
    
    func notifyFetchSuccess() {
       self.noticeOnlyText2("修改密码成功")
    }
	
	func uploadImageFailure() {
		
	}
    
    //添加
   private func addTextField() {
        topView.addSubview(self.phoneTextField)
        topView.addSubview(self.psdTextField)
        topView.addSubview(self.identifyingCode)
        topView.addSubview(self.line1)
        topView.addSubview(self.userImageView)
        topView.addSubview(self.pwdImageView)
        topView.addSubview(self.line)
        topView.addSubview(self.codeImageView)
        self.backScrollView.addSubview(self.topView)
    }
    
    private func addProtocolView() {
      if self.title == "注册" {
          topView.addSubview(protocolLabel)
          self.backScrollView.addSubview(self.protocolBtn)
          self.certainBtn.setTitle("注册", forState: .Normal)
      }else {
          self.certainBtn.setTitle("确定", forState: .Normal)
      }
    }
    
    private func addButton()  {
        self.backScrollView.addSubview(self.codeBtn1)
        self.backScrollView.addSubview(self.certainBtn)
    }
    
    private func createTextFieldToTopView(textField: UITextField ,frame: CGRect, placeholder: String, font: UIFont) {
        textField.frame = frame
        textField.font = font;
        textField.autocorrectionType = .No
        textField.clearButtonMode = .Always
        textField.backgroundColor = UIColor.whiteColor()
        textField.placeholder = placeholder
    }
    
    private func createBtn(frame:CGRect, backImageName: String, title:String, titleColor: UIColor?, font: UIFont? ,target: AnyObject? ,action : Selector ) -> UIButton {
        let btn: UIButton = UIButton()
        btn.frame = frame
        btn.setTitleColor(titleColor, forState: .Normal)
        btn.backgroundColor = UIColor.orangeColor()
        btn.setImage(UIImage.init(named: backImageName), forState:.Normal )
        btn.titleLabel?.font = font
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return btn
    }
    
    //MARK: 按钮的点击方法
    func backScrollViewTap() {
        view.endEditing(true)
        self.clearAllNotice()
    }
    
    func getIdentifyingCode() {
        if self.title == "注册" {
            self.presenter?.getAuthentiCode("register", phoneNumber: phoneTextField.text!)
        }else if self.title == "找回密码" {
            self.presenter?.getAuthentiCode("changepassword", phoneNumber: phoneTextField.text!)
        }
        print("\(self.title)")
    }
    
    func skipToProtocolView() {
        let view = ProtocolView()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func makeCertern() {
        if InfoExamineHelper.isTelNumber(phoneTextField.text!) {
            if InfoExamineHelper.isPasswordOK(psdTextField){
				let phoneNumber = EncryptDecrypt.sharedInstance.aesEncryptToHexArray(phoneTextField.text!)
				let password = EncryptDecrypt.sharedInstance.aesEncryptToHexArray(psdTextField.text!)
                if self.title == "注册" {
                    self.presenter?.register(phoneNumber!, authenticode: identifyingCode.text!, password: password!, navView: self.navigationController!)
                }else{
                    self.presenter?.resetPassword(phoneNumber!, authenticode: identifyingCode.text!, password: password!, navView: self.navigationController!)
                }
            }else{
                hudView.noticeOnlyText2(HudCodeMessage.passwordError.rawValue)
            }
        }else {
            hudView.noticeOnlyText2(HudCodeMessage.phoneError.rawValue)
        }
    }
    //MARK: setter and getter
    private lazy var backScrollView : UIScrollView = {
        let _scollView = UIScrollView()
        _scollView.frame = UIScreen.mainScreen().bounds
        _scollView.backgroundColor =  UIColor.colorWith(239, green: 239, blue: 244, alpha: 1.0)
        _scollView.alwaysBounceVertical = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backScrollViewTap))
        _scollView.addGestureRecognizer(tap)
        return _scollView
    }()
    
    private lazy var topView : UIView = {
        let _view = UIView()
        _view.frame = CGRectMake(10, 20, AppWidth-20, 150)
        _view.layer.cornerRadius = 3.0
        _view.alpha = 0.7
        _view.backgroundColor = UIColor.whiteColor()
        return _view
    }()
    
    private lazy var phoneTextField : UITextField = {
        let _TextField = UITextField()
        self.createTextFieldToTopView(_TextField, frame: CGRectMake(60, 10, AppWidth-120, 30), placeholder: "请输入您手机号码", font: UIFont.systemFontOfSize(14))
        return _TextField
        
    }()
    
    private lazy var psdTextField : UITextField = {
        let _TextField = UITextField()
        self.createTextFieldToTopView(_TextField, frame: CGRectMake(60, 110, AppWidth-120, 30), placeholder: "密码", font: UIFont.systemFontOfSize(14))
        _TextField.secureTextEntry = true
        return _TextField
    }()
    
    private lazy var identifyingCode : UITextField = {
        let _TextField = UITextField()
        self.createTextFieldToTopView(_TextField, frame: CGRectMake(60, 60, AppWidth-120, 30), placeholder: "输入验证码", font: UIFont.systemFontOfSize(14))
        _TextField.secureTextEntry = true
        return _TextField
    }()
    
    private lazy var userImageView : UIImageView = {
        let _imageView = UIImageView()
		_imageView.contentMode = UIViewContentMode.Center
        _imageView.frame = CGRectMake(20, 10, 25, 25)
        _imageView.image = UIImage.init(named: "登录手机号")
        return _imageView
    }()
    
    private lazy var codeImageView : UIImageView = {
        let _imageView = UIImageView()
		_imageView.contentMode = UIViewContentMode.Center
        _imageView.frame = CGRectMake(20, 60, 25, 25)
        _imageView.image = UIImage.init(named: "登录验证码")
        return _imageView
    }()
    
    private lazy var pwdImageView : UIImageView = {
        let _imageView = UIImageView()
		_imageView.contentMode = UIViewContentMode.Center
        _imageView.frame = CGRectMake(20, 110, 25, 25)
        _imageView.image = UIImage.init(named: "登录密码")
        return _imageView
    }()
    
    private lazy var codeBtn :UIButton = {
        let _button = self.createBtn(CGRectMake(AppWidth-100, 75, 80, 40), backImageName: "", title: "输入验证码", titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(14), target: self, action: #selector(getIdentifyingCode))
      
        _button.layer.cornerRadius = 2
        return _button
    }()
    
    private lazy var codeBtn1 :VerifyButton = {
		let _button = VerifyButton(frame: CGRectMake(AppWidth-100, 79, 80, 32))
		_button.delegate = self
		return _button
    }()
    
    private lazy var certainBtn :UIButton = {
        let _button = self.createBtn(CGRectMake(20, self.psdTextField.y + 100, AppWidth-40, 40), backImageName: "", title: "注册", titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(14), target: self, action: #selector(makeCertern))
       _button.layer.cornerRadius = 4
        return _button
    }()
    
    private lazy var protocolLabel : UILabel = {
       let _label = UILabel()
        _label.frame = CGRectMake(2, self.psdTextField.y + 50, 140, 20)
        _label.textColor = UIColor.darkGrayColor()
        _label.font = UIFont.systemFontOfSize(14)
        _label.textAlignment = .Center
        _label.text = "点击注册即表示同意"
        return _label
    }()
    
    private lazy var protocolBtn: UIButton = {
        let _button = self.createBtn(CGRectMake(144, self.psdTextField.y + 70, 150, 20), backImageName: "", title: "《兵法云用户协议》", titleColor: UIColor.orangeColor(), font: UIFont.boldSystemFontOfSize(14), target: self, action: #selector(skipToProtocolView))
        _button.backgroundColor = UIColor.clearColor()
        return _button
    }()
    
    private lazy var line : UIImageView = {
        let _imageView = UIImageView()
        _imageView.frame = CGRectMake(20, 50, self.topView.frame.size.width-40, 1)
        _imageView.backgroundColor = UIColor.colorWith(180, green: 180, blue: 180, alpha: 0.3)
        return _imageView
    }()
    
    private lazy var line1 : UIImageView = {
        let _imageView = UIImageView()
        _imageView.frame = CGRectMake(20, 100, self.topView.frame.size.width-40, 1)
        _imageView.backgroundColor = UIColor.colorWith(180, green: 180, blue: 180, alpha: 0.3)
        return _imageView
    }()
}

extension RegisterViewController: VerifyButtonDelegate {
	func verifyButtonClick(verifyBtn: VerifyButton) {
		if InfoExamineHelper.isTelNumber(self.phoneTextField.text!) {
			verifyBtn.verifyButtonStartTimer()
			self.getIdentifyingCode()
		} else {
			hudView.noticeOnlyText2(HudCodeMessage.phoneError.rawValue)
		}
	}
}
