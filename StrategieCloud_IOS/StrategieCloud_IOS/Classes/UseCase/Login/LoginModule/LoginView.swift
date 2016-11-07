//
// Created by xxx
// Copyright (c) 2016 xxx. All rights reserved.
//

import Foundation
import UIKit
import MonkeyKing
import Alamofire
class LoginView: UIViewController, UserLoginViewProtocol
{
    //var presenter: LoginPresenterProtocol?
    var presenter: UserLoginPresenterProtocol?
	
	
//    let account = MonkeyKing.Account.QQ(appID: Configs.QQ.appID)
	
    let loginW: CGFloat = 250
    //MARK: view delegate
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(true)
         judgmentToInstallApp()
         presenter?.getThirdPartySecret()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
//        MonkeyKing.registerAccount(account)
       // MonkeyKing.registerAccount(account1)
        addTextField()
        createButton()
    }
    
    override func loadView() {
        view = self.backScrollView
    }
    
  //MARK: View Delagete
    func viewBackToMineView() {
        hudView.noticeSuccess(HudCodeMessage.loginSucess.rawValue,autoClear: true)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func setAppAccount(appKey: String) {
        //ase解密
        let key = EncryptDecrypt.sharedInstance.aesDecryptFromHexString(appKey)
        let account = MonkeyKing.Account.WeChat(appID: Configs.Wechat.appID, appKey: key)
        MonkeyKing.registerAccount(account)
    }
    
    func notifyFetchFailure() {
        hudView.noticeOnlyText2("网络不给力啊")
        print(#function)
    }
    
  //MARK: private Method
    private  func addTextField() {
        topView.addSubview(self.phoneTextField)
        topView.addSubview(self.psdTextField)
        topView.addSubview(self.line)
        topView.addSubview(self.userImageView)
        topView.addSubview(self.pwdImageView)
        self.backScrollView.addSubview(label)
        self.backScrollView.addSubview(topView)
    }
    
   private func createButton(){
        self.backScrollView.addSubview(self.landBtn)
        self.backScrollView.addSubview(self.newUserBtn)
        self.backScrollView.addSubview(self.weixinBtn)
        self.backScrollView.addSubview(self.QQBtn)
        self.backScrollView.addSubview(self.forgotPwdBtn)
    }
    
    private func commonInit() {
      presenter = UserLoginPresenter()
      presenter?.view = self
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

        btn.setImage(UIImage.init(named: backImageName), forState:.Normal )
        btn.titleLabel?.font = font
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        return btn
    }

    //MARK: 按钮点击方法
    //TODO
    /// 登录按钮被点击
    func QQloginClick() {
        presenter?.QQLogin()
    }
   
    func loginClick()  {
        if InfoExamineHelper.isTelNumber(phoneTextField.text!) {
            if InfoExamineHelper.isPasswordOK(psdTextField){
				let phoneNumber = EncryptDecrypt.sharedInstance.aesEncryptToHexArray(phoneTextField.text!)
				let password = EncryptDecrypt.sharedInstance.aesEncryptToHexArray(psdTextField.text!)
                presenter?.loginByphone(phoneNumber!, password:  password!)
            }else{
                self.noticeOnlyText2(HudCodeMessage.passwordError.rawValue)
            }
        }else {
                self.noticeOnlyText2(HudCodeMessage.phoneError.rawValue)
        }
    }
    
    func WXloginClick(){
        presenter?.WXLogin()
    }
    
    func registClick() {
        self.navigationController?.pushViewController(LoginWireFrame.registerViewModule("注册"), animated: true)
    }
    
    func forgetPsd() {
        self.navigationController?.pushViewController(LoginWireFrame.registerViewModule("找回密码"), animated: true)
    }
    
    func backScrollViewTap() {
        view.endEditing(true)
        hudView.clearAllNotice()
    }
    
    func judgmentToInstallApp() {
            if  openURL(URLString: "weixin://") == false {
                self.weixinBtn.hidden = true
            }
        
            if  openURL(URLString: "mqqapi://") == false {
                self.QQBtn.hidden = true
            }
        
        changeLayout()
    }
    
    func changeLayout() {
        if self.weixinBtn.hidden == true && self.QQBtn.hidden == false {
            self.QQBtn.frame.origin.x = (self.view.frame.size.width - self.QQBtn.width)/2
        }else if self.weixinBtn.hidden == false && self.QQBtn.hidden == true {
            self.weixinBtn.frame.origin.x = (self.view.frame.size.width - self.QQBtn.width)/2
        }else if self.weixinBtn.hidden == true && self.QQBtn.hidden == true {
            self.label.hidden = true
        }
    }
    
    private func openURL(URLString URLString: String) -> Bool {
        
        guard let URL = NSURL(string: URLString) else {
            return false
        }
        
        return UIApplication.sharedApplication().canOpenURL(URL)
    }
    //MARK: setter And Getter
	private let margin = CGFloat(10)
	
    private lazy var backScrollView : UIScrollView = {
        let _scollView = UIScrollView()
        _scollView.frame = UIScreen.mainScreen().bounds
        _scollView.backgroundColor = UIColor.colorWith(239, green: 239, blue: 244, alpha: 1.0)
        _scollView.alwaysBounceVertical = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(backScrollViewTap))
        _scollView.addGestureRecognizer(tap)
        return _scollView
    }()
	
    private lazy var landBtn :UIButton = {
       let _button = self.createBtn(CGRectMake(10, 140, AppWidth-20, 36), backImageName: "", title: "登录", titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(19), target: self, action: #selector(loginClick))
        _button.backgroundColor  = UIColor.orangeColor()
		_button.layer.cornerRadius = 4
        return _button
    }()
    
    private lazy var newUserBtn :UIButton = {
        let _button = self.createBtn(CGRectMake(5, 180, 70, 30), backImageName: "", title: "快速注册", titleColor: UIColor.orangeColor(), font: UIFont.boldSystemFontOfSize(14), target: self, action: #selector(registClick))
        return _button
    }()
    
    private lazy var forgotPwdBtn :UIButton = {
        let _button = self.createBtn(CGRectMake(AppWidth-75, 180, 60, 30), backImageName: "", title: "找回密码", titleColor: UIColor.orangeColor(), font: UIFont.boldSystemFontOfSize(14), target: self, action: #selector(forgetPsd))
        return _button
    }()
    //(AppWidth-50)/2+100,
    private lazy var weixinBtn :UIButton = {
        let _button = self.createBtn(CGRectMake((AppWidth-50)/2+100, AppHeight-2*NavigationH, 50, 50), backImageName: "ic_landing_wechat", title: "", titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(19), target: self, action: #selector(WXloginClick))
        _button.layer.cornerRadius=25
        return _button
    }()
    
    private lazy var QQBtn :UIButton = {
        let _button = self.createBtn(CGRectMake((AppWidth-50)/2-100, AppHeight-2*NavigationH, 50, 50), backImageName: "ic_landing_qq", title: "", titleColor: UIColor.whiteColor(), font: UIFont.boldSystemFontOfSize(19), target: self, action: #selector(QQloginClick))
        _button.layer.cornerRadius=25
        return _button
    }()
    
    private lazy var topView : UIView = {
       let _view = UIView()
		_view.frame = CGRectMake(self.margin, 2 * self.margin, self.view.frame.width - 2 * self.margin, 100)
        _view.layer.cornerRadius = 3.0
        _view.alpha = 0.7
        _view.backgroundColor = UIColor.whiteColor()
       return _view
    }()
    
    private lazy var phoneTextField : UITextField = {
        let _TextField = UITextField()
         self.createTextFieldToTopView(_TextField, frame: CGRectMake(60, 10, 271, 30), placeholder: "请输入手机号码", font: UIFont.systemFontOfSize(14))
        return _TextField
    
    }()
    
    private lazy var psdTextField : UITextField = {
        let _TextField = UITextField()
        self.createTextFieldToTopView(_TextField, frame: CGRectMake(60, 60, 271, 30), placeholder: "密码", font: UIFont.systemFontOfSize(14))
        _TextField.secureTextEntry = true
        return _TextField
        
    }()
    
    private lazy var label: UILabel = {
        let _label = UILabel()
        _label.frame = CGRectMake((self.view.frame.size.width-140)/2, AppHeight-2.5*NavigationH, 140, 21)
        _label.text = "第三方账号快速登录"
        _label.textColor = UIColor.grayColor()
        _label.textAlignment = .Center
        _label.font = UIFont.systemFontOfSize(14)
        return _label
    }()
    
    private lazy var userImageView : UIImageView = {
        let _imageView = UIImageView()
		let WH = CGFloat(25)
        _imageView.frame = CGRectMake(2 * self.margin, self.margin, WH, WH)
		_imageView.contentMode = UIViewContentMode.Center
        _imageView.image = UIImage.init(named: "登录手机号")
        return _imageView
    }()
    
    private lazy var pwdImageView : UIImageView = {
        let _imageView = UIImageView()
		let WH = CGFloat(25)
		_imageView.contentMode = UIViewContentMode.Center
        _imageView.frame = CGRectMake(2 * self.margin, 60, WH, WH)
        _imageView.image = UIImage.init(named: "登录密码")
        return _imageView
    }()
    
    private lazy var line : UIImageView = {
        let _imageView = UIImageView()
        _imageView.frame = CGRectMake(20, 50, self.topView.frame.size.width-40, 1)
        _imageView.backgroundColor = UIColor.colorWith(180, green: 180, blue: 180, alpha: 0.3)
        return _imageView
    }()
}