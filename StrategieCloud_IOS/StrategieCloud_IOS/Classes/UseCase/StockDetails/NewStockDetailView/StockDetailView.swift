//
//  StockDetailView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/10/20.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import Alamofire
import MonkeyKing

class StockDetailView: BaseVC,NSURLSessionTaskDelegate {

    static var FromProfitRank = false
    var showSecondPage = false
    var currentRoughStockPos = Int(0)
    var roughStocks: [RoughStock] = []
    var marketIndex = false
    
    static let PageControlHeight = CGFloat(12)
    private var currentPageNum = Int(0)
    private var vcArray: [BasePageController] = []
    private var TotalPage = Int(2)
    private var addChosenBtnItem: AddChosenButtonItem!
    private var sharePlatformType: PopupShareView.PlatformType?
    private var uploadShareImgUrl: String?
    private var shareImg: UIImage?
    
    private let AddChosenBtnSize = CGSize(width: 52, height: 18)
    
    var text  : String = ""
   
    struct StoryBoard {
        static let firstPageID = "firstPageID"
        static let secondPageID = "secondPageID"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageName = "股票详细"
        self.view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(tableView)
        print("详情2页面坐标是======\(self.view.frame)")
        self.automaticallyAdjustsScrollViewInsets = false
        
        if StockDetailView.FromProfitRank || showSecondPage {
            currentPageNum = 1
        }
        setupContainerView()
        scrollView.snp_makeConstraints { (make) in
            make.leading.top.trailing.equalTo(self.headerView)
            make.bottom.equalTo(bottomPageControl.snp_top)
        }

        titleView.showPrevNextBtn(roughStocks.count > 1 ? true : false)
        self.navigationItem.titleView = titleView
        let currRoughStock = roughStocks[currentRoughStockPos]
        self.setTitle(currRoughStock)
        addChosenBtnItem = AddChosenButtonItem(frame: CGRectMake(0, 0, AddChosenBtnSize.width, AddChosenBtnSize.height))
        addChosenBtnItem.delegate = self
        addChosenBtnItem.enabled = !RealmHelper.instance.isOptionalShare(witCode: currRoughStock.code)
        self.navigationItem.rightBarButtonItems = [ shareBtn, addChosenBtnItem ]
        
        let gestures = self.navigationController!.view.gestureRecognizers
        if let _gestures = gestures {
            for gesture in _gestures {
                if (gesture.isKindOfClass(UIScreenEdgePanGestureRecognizer)) {
                    self.scrollView.panGestureRecognizer.requireGestureRecognizerToFail(gesture)
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        StockDetailView.FromProfitRank = false
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let isLandscape = size.width != AppWidth
        self.navigationController?.navigationBarHidden = isLandscape
        
        for i in 0 ..< vcArray.count {
            self.vcArray[i].viewWillTransitionToSizeWithLandscape(isLandscape)
        }
    }
    
    override func viewWillLayoutSubviews() {
        		//scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(TotalPage), height: scrollView.height)
      
        if self.view.width > self.view.height {
           print("横坐标为====\(self.view.frame)===000\(self.scrollView.frame)")
           self.tableView.scrollEnabled = false
           self.tableView.setContentOffset(CGPointMake(0, 0) , animated: false)
           
           self.tableView.frame = self.view.frame
           //scrollView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
           self.headerView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
           vcArray[0].view.frame = self.view.frame
           vcArray[1].view.frame = CGRectMake(self.view.frame.width, 0, self.view.frame.width, self.view.frame.height-14)
           scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(TotalPage), height: 0)
           scrollView.setContentOffset(CGPointMake(scrollView.width * CGFloat(currentPageNum), 0), animated: false)
           bottomPageControl.frame = CGRectMake(0, self.view.frame.size.height - 14, self.view.frame.size.width, 14)
        }else{
           self.tableView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
           self.headerView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
           self.tableView.scrollEnabled = true
            // self.scrollView.frame = self.view.frame
           print("坐标为====\(self.view.frame)===000\(self.scrollView.frame)")
           vcArray[0].view.frame = scrollView.frame
           vcArray[1].view.frame = CGRectMake(scrollView.frame.width, 0, scrollView.frame.width, scrollView.frame.height)
           scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(TotalPage), height: 0)
           scrollView.setContentOffset(CGPointMake(scrollView.width * CGFloat(currentPageNum), 0), animated: false)
           bottomPageControl.frame = CGRectMake(0, self.view.frame.size.height - 20, self.view.frame.size.width, 20)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
     // MARK: - Private Method
    private func setupContainerView() {
        let screenWidth = self.view.frame.width
        
        let firstPageStoryboard = UIStoryboard(name: "FirstPage", bundle: nil)
        let firstPage = firstPageStoryboard.instantiateViewControllerWithIdentifier(StoryBoard.firstPageID) as! FirstTimeSharedPage
        firstPage.roughStock = self.roughStocks[currentRoughStockPos]
        firstPage.pageNum = currentPageNum
        
        let secondPageStoryboard = UIStoryboard(name: "SecondPage", bundle: nil)
        let secondPage = secondPageStoryboard.instantiateViewControllerWithIdentifier(StoryBoard.secondPageID) as! SecondKLinePage
        secondPage.roughStock = self.roughStocks[currentRoughStockPos]
        secondPage.pageNum = currentPageNum
        
        
        self.vcArray.append(firstPage)
        self.vcArray.append(secondPage)
        self.addChildViewController(firstPage)
        self.addChildViewController(secondPage)
        scrollView.addSubview(firstPage.view)
        secondPage.view.frame.origin.x = screenWidth
        scrollView.addSubview(secondPage.view)
        
        
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * CGFloat(TotalPage), 0)
        scrollView.setContentOffset(CGPointMake(screenWidth * CGFloat(currentPageNum), 0), animated: false)
        self.bottomPageControl.currentPage = currentPageNum
        self.headerView.addSubview(scrollView)
        self.headerView.addSubview(bottomPageControl)
        //self.tableView.addSubview(bottomPageControl)
    }
    
    private func uploadShareImg(url: String, img: UIImage) {
        let requestURL = NSURL(string: url)
        let request = NSMutableURLRequest(URL: requestURL!)
        request.HTTPMethod = "PUT"
        let data = NSUIImagePNGRepresentation(img)
        request.HTTPBody = data
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
        session.uploadTaskWithStreamedRequest(request).resume()
    }
    
    private func setTitle(stock: RoughStock) {
        titleView.nameLabel.text = stock.name
        titleView.codeLabel.text = (stock.code as NSString).substringFromIndex(2)
    }
    
    private func onPreviouNextBtnClick() {
        if currentRoughStockPos < 0 {
            currentRoughStockPos = roughStocks.count - 1
        }
        if currentRoughStockPos >= roughStocks.count {
            currentRoughStockPos = 0
        }
        
        setTitle(roughStocks[currentRoughStockPos])
        let stock = roughStocks[currentRoughStockPos]
        vcArray[currentPageNum].setPageInfo(viewPagerNum: currentPageNum, roughStock: stock)
        addChosenBtnItem.enabled = !RealmHelper.instance.isOptionalShare(witCode: stock.code)
    }
    
    @objc private func shareBtnClick(sender: UIBarButtonItem) {
        uploadShareImgUrl = nil
        shareImg = nil
        
        Alamofire.request(Router.ImageShareUploadUrl).responseJSON { (response: Response<AnyObject, NSError>) in
            switch response.result {
            case .Success(let value):
                if let data = value["data"] as? String {
                    self.uploadShareImgUrl = data
                    self.view.window?.addSubview(self.shareView)
                    self.shareView.show()
                }
            case .Failure(let error):
                self.uploadShareImgUrl = nil
                self.noticeInfo("网络异常，分享失败！")
                print("\(#function) error: \(error)")
            }
        }
    }
    
    private func update() {
        let page = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
        if page < TotalPage{
            self.currentPageNum = page
            self.bottomPageControl.currentPage = self.currentPageNum
            
            let stock = roughStocks[currentRoughStockPos]
            vcArray[currentPageNum].setPageInfo(viewPagerNum: currentPageNum, roughStock: stock)
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        if error?.description == nil {
            print("分享图片上传成功")
            guard let uploadUrl = self.uploadShareImgUrl else {
                self.noticeError("分享失败，请检查网络！", autoClear: true, autoClearTime: 1)
                return
            }
            
            guard let uploadImg = self.shareImg else {
                self.noticeError("分享失败，请检查网络！", autoClear: true, autoClearTime: 1)
                return
            }
            
            let roughStock = self.roughStocks[currentRoughStockPos]
            var title: String!
            if currentPageNum == 1 {
                title = "\(roughStock.name)(\(roughStock.code))在【兵法云】产生了B、S信号和仓位信息"
            } else {
                title = "\(roughStock.name)(\(roughStock.code))今天在【兵法云】产生了急涨、放量信号"
            }
            
            let shareUrl = getShareUrl(uploadUrl)
            let shareInfo = MonkeyKing.Info(
                title: title,
                description: title,
                thumbnail: uploadImg,
                media: .URL(NSURL(string: shareUrl)!)
            )
            
            if let type = sharePlatformType {
                var message: MonkeyKing.Message!
                switch type {
                case .QQfriend:
                    message = MonkeyKing.Message.QQ(.Friends(info: shareInfo))
                case .QQZone:
                    message = MonkeyKing.Message.QQ(.Zone(info: shareInfo))
                case .WXfriend:
                    message = MonkeyKing.Message.WeChat(.Session(info: shareInfo))
                case .WXCircleFriend:
                    message = MonkeyKing.Message.WeChat(.Timeline(info: shareInfo))
                }
                
                if let msg = message {
                    MonkeyKing.shareMessage(msg, completionHandler: { (result) in
                        if !result {
                            print("分享失败")
                        }
                    })
                }
                
            }
        } else {
            print("分享图片上传失败")
            self.noticeError("分享失败，请检查网络！", autoClear: true, autoClearTime: 1)
        }
        
        sharePlatformType = nil
    }
    //MARK: Lazy load control
    private func getShareUrl(uploadUrl: String) -> String {
        let _splitedArray = uploadUrl.componentsSeparatedByString("?")[0].componentsSeparatedByString("/")
        let _imgNameArray = _splitedArray[_splitedArray.count - 1].componentsSeparatedByString("%2F")
        let _imgName = _imgNameArray[_imgNameArray.count - 1]
        return Router.baseShareImgUrl + _imgName
    }
    
    private lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Plain)
        _tableView.backgroundColor = UIColor.whiteColor()
        _tableView.dataSource = self
        _tableView.delegate = self
        _tableView.rowHeight = 70
        _tableView.tableHeaderView = self.headerView
        return _tableView
    }()
    
    private lazy var segement: SegmentView = {
        let titles = ["看点","公告","研报","诊股"," 财务","股东","简况(10)","太猛了","镇魂街"]
        let segement = SegmentView.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44), titles: titles)
        segement.setedSegmentTintColor(UIColor.orangeColor())
        segement.setSelectedItemAtIndex(0)
        segement.type = CCZSegementStyle.CCZSegementStyleDefault
        
        segement.selectedAtIndex { (Index) in
            self.text = titles[Index]
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            print("点到\(Index)")
        }
        return segement
    }()
    
    private lazy var shareView: PopupShareView = {
        let _shareView = PopupShareView(frame: CGRectMake(0, AppHeight, AppWidth, CGFloat(120)), shareType: PopupShareView.ShareContentType.StockDetail)
        _shareView.delegate = self
        return _shareView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let _scrollView = UIScrollView()
        _scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)
        _scrollView.showsHorizontalScrollIndicator = false
        _scrollView.pagingEnabled = true
        _scrollView.delegate = self
        return _scrollView
    }()
    
    private lazy var headerView: UIView = {
        let _View = UIView()
        _View.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)
        return _View
    }()
    
    private lazy var titleView: StockTitleView = {
        let _titleView = StockTitleView(frame: CGRect(x: 0, y: 0, width: 140, height: 44))
        _titleView.delegate = self
        return _titleView
    }()
    
    private lazy var bottomPageControl: UIPageControl = {
        let control = UIPageControl()
        control.frame = CGRectMake(0, self.view.frame.size.height - 14-64, self.view.frame.size.width, 14)
        control.numberOfPages = 2
        control.currentPageIndicatorTintColor = UIColor.PageControlHighColor()
        control.pageIndicatorTintColor = UIColor.PageControlNormalColor()
        control.userInteractionEnabled = false
        return control
    }()
    
    private lazy var firstSectionView: UIView = {
        let _view = UIView.init(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        _view.backgroundColor = UIColor.clearColor()
        return _view
    }()
    
    private lazy var shareBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem(image: UIImage(named: "分享")!, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(StockDetailView.shareBtnClick(_:)))
        return btn
    }()


}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension StockDetailView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 10
        }
        return 10
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if  cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "cell")
        }
        //cell!.backgroundColor = UIColor.whiteColor()
        cell!.textLabel?.text = text
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return self.view.frame.height
//        }
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section == 0 {
//            return scrollView
//        }
        return self.segement
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "今天"
    }
}

// MARK: - UIScrollViewDelegate
extension StockDetailView: UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.update()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.update()
    }
}

//MARK: -AddChosenButtonItemDelegate
extension StockDetailView: AddChosenButtonItemDelegate {
    func addChosenButtonItemClick(button: AddChosenButtonItem) {
        let currRoughStock = roughStocks[currentRoughStockPos]
        if StockDetailView.FromProfitRank {
            if let _aowId = currRoughStock.aowID {
                let parameters = [
                    "ticker": currRoughStock.code,
                    "aow_id": "\(_aowId)"
                ]
                Alamofire.request(Router.ChosenByProfitRank(parameters)).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                    switch response.result {
                    case .Success:
                        RealmHelper.instance.addStockToRealm(currRoughStock.name, code: currRoughStock.code, uploaded: true)
                        button.enabled = false
                        self.noticeSuccess("添加成功", autoClear: true, autoClearTime: 1)
                    case .Failure(let error):
                        print("\(#function) error: \(error)")
                        self.noticeError("添加失败", autoClear: true, autoClearTime: 1)
                    }
                })
            }
        } else {
            let parameters = [
                "tickers": [ currRoughStock.code ]
            ]
            Alamofire.request(Router.UploadTickers(parameters)).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                switch response.result {
                case .Success(_):
                    RealmHelper.instance.addStockToRealm(currRoughStock.name, code: currRoughStock.code, uploaded: true)
                    button.enabled = false
                    self.noticeSuccess("添加成功", autoClear: true, autoClearTime: 1)
                case .Failure(let error):
                    print("\(#function) error: \(error)")
                    self.noticeError("添加失败", autoClear: true, autoClearTime: 1)
                }
            })
        }
    }
}

//MARK: -PopupShareViewDelegate
extension StockDetailView: PopupShareViewDelegate {
    func popupShareViewShare(platformType: PopupShareView.PlatformType) {
        self.sharePlatformType = platformType
        
        var shareImagePageIndex = currentPageNum
        if (shareImagePageIndex > 1) {
            shareImagePageIndex = 0
        }
        self.shareImg = self.vcArray[shareImagePageIndex].getShareImage()
        if let url = self.uploadShareImgUrl, let img = self.shareImg {
            self.uploadShareImg(url, img: img)
        } else {
            self.noticeError("分享失败，请检查网络！", autoClear: true, autoClearTime: 1)
        }
    }
}

// MARK: - StockTitleViewDelegate
extension StockDetailView: StockTitleViewDelegate {
    func stockTitleViewNext() {
        currentRoughStockPos += 1
        onPreviouNextBtnClick()
    }
    
    func stockTitleViewPreviou() {
        currentRoughStockPos -= 1
        onPreviouNextBtnClick()
    }
}
