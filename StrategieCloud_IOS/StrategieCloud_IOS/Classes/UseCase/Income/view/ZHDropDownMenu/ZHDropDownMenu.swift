//
//  ZHDropDownMenu.swift
//
//  Created by 杨超杰 on 3/8/16.
//
//  Copyright (c) 2016
//



import UIKit

public protocol ZHDropDownMenuDelegate{
    func dropDownMenu(menu:ZHDropDownMenu!, didInput text:String!)
    func dropDownMenu(menu:ZHDropDownMenu!, didChoose index:Int)
    func dropDownMenuShowState(left:Bool)
}

public class ZHDropDownMenu: UIView , UITableViewDataSource ,UITableViewDelegate,UITextFieldDelegate{
    //MARK:  Property Setter and setter
    public var delegate:ZHDropDownMenuDelegate?
    public var options:Array<String> = []
    var superVV:  UIView? // 父视图
    
    public var defaultValue:String? {
        didSet {
            contentText = defaultValue!
        }
    }
    
    public var textColor:UIColor = UIColor.darkGrayColor(){
        didSet {
            contentTextField.textColor = textColor
        }
    }
    
    public var font:UIFont?{
        didSet {
            contentTextField.font = font
        }
    }
    
    public var showBorder:Bool = true {
        didSet {
            if showBorder {
                layer.borderColor = UIColor.lightGrayColor().CGColor
                layer.borderWidth = 0.5
                layer.masksToBounds = true
                layer.cornerRadius = 2.5
            }else {
                layer.borderColor = UIColor.clearColor().CGColor
                layer.masksToBounds = false
                layer.cornerRadius = 0
                layer.borderWidth = 0
            }
        }
    }
    
    var contentText: String = "" {
        didSet {
            if left == true {
              pullDownButton.frame = CGRect(x: contentText.WidthWithConstrainedWidth(30,font: UIFont.systemFontOfSize(12)) + 15, y: 10, width: 20, height: 20)
            }else{
              pullDownButton.frame = CGRect(x: contentText.WidthWithConstrainedWidth(30,font: UIFont.systemFontOfSize(12)) + 40, y: 10, width: 20, height: 20)
            }
            
            self.contentTextField.text = contentText
        }
    }
    
    var left : Bool = true
    //MARK: control lazy setter
    public lazy var rowHeight:CGFloat = { //菜单项的行高，默认和本控件一样高
        return self.frame.size.height 
    }()
    
    public lazy var optionsList:UITableView = { //下拉列表
        let table = UITableView(frame: CGRectMake(0, self.frame.origin.y + self.frame.size.height, UIScreen.mainScreen().bounds.size.width, 0), style: .Plain)
        table.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        table.dataSource = self
        table.delegate = self
        table.layer.borderColor = UIColor.lightGrayColor().CGColor
        table.layer.borderWidth = 0.5
        self.superVV?.addSubview(table)
        return table
    }()
    
    private lazy var bgBtn: UIButton = {
        let _bgBtn = UIButton(frame: CGRectMake(0, 64, AppWidth, AppHeight-64))
        _bgBtn.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        _bgBtn.addTarget(self, action: #selector(closeView), forControlEvents: UIControlEvents.TouchUpInside)
        return _bgBtn
    }()
    
    public var editable:Bool = true {
        didSet {
            contentTextField.enabled = editable
        }
    }
    
    public var placeholder:String? {
        didSet {
            contentTextField.placeholder = placeholder
        }
    }
    
    public var buttonImage:UIImage?{
        didSet {
            pullDownButton.setImage(buttonImage, forState: .Normal)
        }
    }
    
    public var isShown:Bool = false     
    private var contentTextField:UITextField!
    private var pullDownButton:UIButton!
    
    //MARK: life Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
        addTapAddGestureRecognizer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if left == true {
            contentTextField.frame = CGRect(x: 12, y: 5, width: self.frame.size.width - 30, height: self.frame.size.height - 10)
        }else {
            contentTextField.textAlignment = .Center
            contentTextField.frame = CGRect(x: 14, y: 5, width: self.frame.size.width - 10, height: self.frame.size.height - 10)
            pullDownButton.frame = CGRect(x:   contentTextField.text!.WidthWithConstrainedWidth(30,font: UIFont.systemFontOfSize(12)) + 40, y: 10, width: 20, height: 20)
        }
        
    }
    
    //MARK: method
    func setUp() {
        contentTextField = UITextField(frame: CGRectZero)
        contentTextField.delegate = self
        addSubview(contentTextField)
        
        pullDownButton = UIButton(type: .Custom)
        pullDownButton.addTarget(self, action: #selector(ZHDropDownMenu.tapAction), forControlEvents: .TouchUpInside)
        addSubview(pullDownButton)
        
        self.showBorder = true
        self.textColor = UIColor.darkGrayColor()
        self.font = UIFont.systemFontOfSize(16)
    }
    
    func addTapAddGestureRecognizer() {
        let tap = UITapGestureRecognizer(target:self, action:#selector(tapAction))
        self.addGestureRecognizer(tap)
    }
    
    func tapAction() {
        showOrHide()
        delegate?.dropDownMenuShowState(left)
    }
    
    func showOrHide() {
        if isShown {
            closeView()
        } else {
            showView()
        }
        
    }
    
    @objc private func closeView() {
        contentTextField.textColor = UIColor.darkGrayColor()
        buttonImage = UIImage.init(named: "default_down")
        bgBtn.removeFromSuperview()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.pullDownButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI*2))
            self.optionsList.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height-0.5, UIScreen.mainScreen().bounds.size.width, 0)
        }) { (finished) -> Void in
            if finished{
                self.pullDownButton.transform = CGAffineTransformMakeRotation(0.0)
                self.isShown = false
            }
        }
    }
    
    @objc private func showView() {
        contentTextField.textColor = UIColor.NavBarColor()
        buttonImage = UIImage.init(named: "up")?.imageWithRenderingMode(.AlwaysOriginal)
        self.superVV!.insertSubview(bgBtn, belowSubview: self.optionsList)
        contentTextField.resignFirstResponder()
        optionsList.reloadData()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.pullDownButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            self.optionsList.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height-0.5, UIScreen.mainScreen().bounds.size.width, CGFloat(self.options.count) * self.rowHeight)
        }) { (finished) -> Void in
            if finished{
                self.isShown = true
            }
        }
    }
 
    
    //MARK: UITextFieldDelegate
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            self.delegate?.dropDownMenu(self, didInput: text)
        }
        return true
    }
    
    //MARK: TableViewdelegate and TableViewDataSource
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "")
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = font
        cell.textLabel?.textAlignment = .Center
        if contentText == options[indexPath.row] {
            cell.textLabel?.textColor = UIColor.NavBarColor()
        }else {
            cell.textLabel?.textColor = textColor
        }
        return cell
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        contentText = options[indexPath.row]
        self.delegate?.dropDownMenu(self, didChoose:indexPath.row)
        
        showOrHide()
    }

}
