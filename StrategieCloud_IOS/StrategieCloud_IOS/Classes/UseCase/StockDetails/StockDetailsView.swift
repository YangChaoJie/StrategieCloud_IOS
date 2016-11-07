//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import MonkeyKing

class StockDetailsView: BaseVC,
	NSURLSessionTaskDelegate
{
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
	override func viewDidLoad() {
		super.viewDidLoad()
		self.pageName = "股票详细"
		self.automaticallyAdjustsScrollViewInsets = false
		self.view.addSubview(scrollView)
		self.view.addSubview(bottomPageControl)
     
		bottomPageControl.snp_makeConstraints { (make) in
			make.leading.trailing.bottom.equalTo(view)
			make.height.equalTo(14)
		}

		scrollView.snp_makeConstraints { (make) in
			make.leading.top.trailing.equalTo(view)
			make.bottom.equalTo(bottomPageControl.snp_top)
		}

		if StockDetailsView.FromProfitRank || showSecondPage {
			currentPageNum = 1
		}
		
		self.setupContainerView()
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

	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		StockDetailsView.FromProfitRank = false
	}

	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		let isLandscape = size.width != AppWidth
		self.navigationController?.navigationBarHidden = isLandscape

		for i in 0 ..< vcArray.count {
			self.vcArray[i].viewWillTransitionToSizeWithLandscape(isLandscape)
		}
	}

	override func viewWillLayoutSubviews() {
//		scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(TotalPage), height: scrollView.height)
		scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(TotalPage), height: 0)
		scrollView.setContentOffset(CGPointMake(scrollView.width * CGFloat(currentPageNum), 0), animated: false)

		vcArray[0].view.frame = scrollView.frame
		vcArray[1].view.frame = CGRectMake(scrollView.frame.width, 0, scrollView.frame.width, scrollView.frame.height)
        
        print("坐标是======\(self.view.bounds)------\(self.scrollView.frame)")
	}

	override func shouldAutorotate() -> Bool {
		return true
	}

	override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
		return UIInterfaceOrientationMask.All
	}

	// MARK: - Private Method
	struct StoryBoard {
		static let firstPageID = "firstPageID"
		static let secondPageID = "secondPageID"
		static let thirdPageID = "thirdPageID"
	}

	private func setupContainerView() {
		let screenWidth = UIScreen.mainScreen().bounds.width
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

		self.scrollView.addSubview(firstPage.view)
		secondPage.view.frame.origin.x = screenWidth
		self.scrollView.addSubview(secondPage.view)
		
		self.scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.width * CGFloat(TotalPage), 0)
		self.scrollView.setContentOffset(CGPointMake(screenWidth * CGFloat(currentPageNum), 0), animated: false)
		self.bottomPageControl.currentPage = currentPageNum
	}

	private func update() {
		let page = Int(floorf(Float(scrollView.contentOffset.x / scrollView.frame.size.width)))
		if page >= 0 && page < TotalPage {
			self.currentPageNum = page
			self.bottomPageControl.currentPage = self.currentPageNum
			
			let stock = roughStocks[currentRoughStockPos]
			vcArray[currentPageNum].setPageInfo(viewPagerNum: currentPageNum, roughStock: stock)
		}
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
	
	private var uploadShareImgUrl: String?
	private var shareImg: UIImage?
	
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
	
	private var sharePlatformType: PopupShareView.PlatformType?
	
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
	
	private func getShareUrl(uploadUrl: String) -> String {
		let _splitedArray = uploadUrl.componentsSeparatedByString("?")[0].componentsSeparatedByString("/")
		let _imgNameArray = _splitedArray[_splitedArray.count - 1].componentsSeparatedByString("%2F")
		let _imgName = _imgNameArray[_imgNameArray.count - 1]
		return Router.baseShareImgUrl + _imgName
	}
	
	private lazy var shareView: PopupShareView = {
		let _shareView = PopupShareView(frame: CGRectMake(0, AppHeight, AppWidth, CGFloat(120)), shareType: PopupShareView.ShareContentType.StockDetail)
		_shareView.delegate = self
		return _shareView
	}()

	private lazy var scrollView: UIScrollView = {
		let _scrollView = UIScrollView()
		_scrollView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height)
		_scrollView.showsHorizontalScrollIndicator = false
		_scrollView.pagingEnabled = true
		_scrollView.delegate = self
		return _scrollView
	}()

	private lazy var titleView: StockTitleView = {
		let _titleView = StockTitleView(frame: CGRect(x: 0, y: 0, width: 140, height: 44))
		_titleView.delegate = self
		return _titleView
	}()
	
	private lazy var bottomPageControl: UIPageControl = {
		let control = UIPageControl()
		control.frame = CGRectMake(0, AppHeight - 78, AppWidth, 14)
		control.numberOfPages = 2
		control.currentPageIndicatorTintColor = UIColor.PageControlHighColor()
		control.pageIndicatorTintColor = UIColor.PageControlNormalColor()
		control.userInteractionEnabled = false
		return control
	}()
	
	private let AddChosenBtnSize = CGSize(width: 52, height: 18)
	
	private lazy var shareBtn: UIBarButtonItem = {
		let btn = UIBarButtonItem(image: UIImage(named: "分享")!, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(StockDetailsView.shareBtnClick(_:)))
		return btn
	}()
}

//MARK: -AddChosenButtonItemDelegate
extension StockDetailsView: AddChosenButtonItemDelegate {
	func addChosenButtonItemClick(button: AddChosenButtonItem) {
		let currRoughStock = roughStocks[currentRoughStockPos]
		if StockDetailsView.FromProfitRank {
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
extension StockDetailsView: PopupShareViewDelegate {
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
extension StockDetailsView: StockTitleViewDelegate {
	func stockTitleViewNext() {
		currentRoughStockPos += 1
		onPreviouNextBtnClick()
	}

	func stockTitleViewPreviou() {
		currentRoughStockPos -= 1
		onPreviouNextBtnClick()
	}
}

// MARK: - UIScrollViewDelegate
extension StockDetailsView: UIScrollViewDelegate {
	func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if !decelerate {
			self.update()
		}
	}

	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		self.update()
	}
}