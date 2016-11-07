//
//  UserSetInfoView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/6/30.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class UserSetInfoView: UIViewController,LoginViewProtocol {
    var presenter: LoginPresenterProtocol?
	let size = CGSize(width: 100, height: 100)
	
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        createView()
        initNavTitileView()
    }
	
	func uploadImageFailure() {
		self.noticeOnlyText2("网络不给力，上传头像失败！")
	}
	
    //MARK: Private Method
   private func createView()  {
        self.view.addSubview(self.tableView)
        self.iconImageView.addSubview(avatarImg)
        self.tableView.tableHeaderView = self.iconImageView
        self.view.addSubview(self.certainBtn)
    }
    
    private func initNavTitileView()  {
        let rightItem : UIBarButtonItem = UIBarButtonItem.init(customView: self.completeBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    func notifyFetchSuccess() {
        hudView.noticeSuccess(HudCodeMessage.uploadSucess.rawValue, autoClear: true, autoClearTime: 1)
        //self.tableView.reloadData()
    }
    
   private func sheet() {
        let iconActionAlert : UIAlertController = UIAlertController(title: "选择图片", message: nil, preferredStyle: .ActionSheet)
        
        let cancle = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (UIAlertAction) in
            print("cancle")
        }
        let photo = UIAlertAction(title: "照片", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            self.openUserPhotoLibrary()
            print("photo")
        }
        let camera = UIAlertAction(title: "拍照", style: UIAlertActionStyle.Default) { (UIAlertAction) in
            self.openCamera()
            print("camera")
        }
        iconActionAlert.addAction(cancle)
        iconActionAlert.addAction(photo)
        iconActionAlert.addAction(camera)
        
        self.presentViewController(iconActionAlert, animated: true, completion: nil)
    }
	
	@objc private func avatarImgClick() {
		print(#function)
		self.sheet()
	}
    
    func confirm() {
        if  UserMannager.instance.getUserName() == ""{
            hudView.noticeOnlyText2("请填写昵称")
        }else{
            print("------\(self.uploadImage)")
            self.presenter?.uploadImage(self.uploadImage, name: UserMannager.instance.getUserName(),navView: self.navigationController!)
        }
    }
    
    func complete()  {
        self.presenter?.comeBackMineModule(self.navigationController!)
    }
    
    //MARK: ViewController Life
    private lazy var tableView : UITableView = {
        let _tableView = UITableView()
        let tableWidth = CGFloat(49)
        let rowHeight = CGFloat(44)
        _tableView.frame = CGRectMake(0, 0, AppWidth, (AppHeight-tableWidth)/2)
        _tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.scrollEnabled = false
        _tableView.rowHeight = rowHeight
        _tableView.tableFooterView = UIView.init()
        _tableView.registerNib(UINib(nibName: "UserInfoCell", bundle: nil), forCellReuseIdentifier: UserInfoCell_Identifier)
        return _tableView
    }()

//	private lazy var headerBgView: UIView = {
//		let height = CGFloat(180)
//		let _view = UIView()
//		_view.frame = CGRectMake(0, 0, AppWidth, height)
//		_view.backgroundColor = UIColor.NavBarColor()
//		return _view
//	}()
//    
    private lazy var iconImageView : UIImageView = {
        let iconImageViewHeight = CGFloat(180)
        let _iconImageView = UIImageView()
        _iconImageView.frame = CGRectMake(0, 0, AppWidth,iconImageViewHeight)
        _iconImageView.backgroundColor = UIColor.NavBarColor()
        _iconImageView.userInteractionEnabled = true
        return _iconImageView
    }()

	private lazy var avatarImg: UIImageView = {
		let height = CGFloat(180)
		let _view = UIImageView(frame: CGRectMake(0, 0, 60, 60))
		_view.center = CGPointMake(AppWidth * 0.5, (height - 80) * 0.5 + 35)
		_view.layer.cornerRadius = _view.frame.size.width / 2
		_view.layer.borderWidth = 2
		_view.layer.borderColor = UIColor.whiteColor().CGColor
		_view.userInteractionEnabled = true
        _view.clipsToBounds = true
		_view.image = UIImage(named: "默认头像")!
		_view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserSetInfoView.avatarImgClick)))
		return _view
	}()
	
    private lazy var certainBtn : UIButton = {
        let _button  = UIButton()
        _button.frame = CGRectMake(10, AppHeight/2, AppWidth-20, 40)
        _button.setTitle("确定", forState: .Normal)
		_button.layer.cornerRadius = 4
        _button.backgroundColor = UIColor.orangeColor()
        _button.addTarget(self, action: #selector(confirm), forControlEvents: .TouchUpInside)
        return _button
    }()
    
    private lazy var completeBtn : UIButton = {
        let btn = UIButton()
        let width = CGFloat(50)
        btn.frame = CGRectMake(0, 0, width, width)
        btn.setTitle("跳过", forState: .Normal)
		btn.titleLabel?.font = UIFont.systemFontOfSize(14)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(complete), forControlEvents: .TouchUpInside)
        return btn
    }()
    
    private lazy var uploadImage :UIImage = {
        let _image = UIImage()
        return _image
    }()
    
    //相册
    private lazy var pickVC: UIImagePickerController = {
        let pickVC = UIImagePickerController()
        pickVC.delegate = self
        pickVC.allowsEditing = true
        return pickVC
    }()
    
    private lazy var data = {
        return ["昵称"]
    }()
    
    //iOS8.3 之后
    private lazy var iconActionAlert : UIAlertController = UIAlertController(title: "上传图片", message: nil, preferredStyle: .ActionSheet)
    var cancle = UIAlertAction(title: "", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        print("cancle")
    }
    var photo = UIAlertAction(title: "", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        print("photo")
    }
    var camera = UIAlertAction(title: "", style: UIAlertActionStyle.Default) { (UIAlertAction) in
        print("camera")
    }
    
}
//MARK: extension
extension UserSetInfoView: UITableViewDataSource,UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(UserInfoCell_Identifier) as? UserInfoCell
        let name : String? = UserMannager.instance.getUserName()
        
        print("")
        if (name != nil) && (indexPath.row == 0) {
            cell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.setContentToCell(self.data[indexPath.row], context: name!)
        }
        return cell!
    }
    
    //点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 0{
            self.presenter?.presentUserNameView(self.navigationController!)
        }
    }
}
// MARK: UIActionSheetDelegate
extension UserSetInfoView: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    /// 打开照相功能
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            pickVC.sourceType = .Camera
            self.presentViewController(pickVC, animated: true, completion: nil)
        } else {
            print("打开失败")
        }
    }
    
    /// 打开相册
    private func openUserPhotoLibrary() {
        pickVC.sourceType = .PhotoLibrary
        pickVC.allowsEditing = true
        presentViewController(pickVC, animated: true, completion: nil)
    }
    
    // 对用户选着的图片进行质量压缩,上传服务器,本地持久化存储
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		var image: UIImage!
		if picker.allowsEditing {
			image = info[UIImagePickerControllerEditedImage] as! UIImage
		} else {
			image = info[UIImagePickerControllerOriginalImage] as! UIImage
		}
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			UIGraphicsBeginImageContext(CGSize(width: self.size.width, height: self.size.height))
			image.drawInRect(CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
			let newImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			dispatch_async(dispatch_get_main_queue(), {
				self.uploadImage = newImage
                self.avatarImg.image = newImage
				//self.presenter?.uploadImage(newImage, name: UserMannager.instance.getUserName())
			})
		}
		picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        pickVC.dismissViewControllerAnimated(true, completion: nil)
    }
}
