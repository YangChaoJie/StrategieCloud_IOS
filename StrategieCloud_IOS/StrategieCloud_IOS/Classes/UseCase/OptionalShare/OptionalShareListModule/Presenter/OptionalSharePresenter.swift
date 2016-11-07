//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation
import RealmSwift

struct Tag {
	static var priceTag : Int = 0
	static var changeTag : Int = 0
}


class OptionalSharePresenter: OptionalSharePresenterProtocol, OptionalShareInteractorOutputProtocol
{
    weak var view: OptionalShareViewProtocol?
    var interactor: OptionalShareInteractorInputProtocol?
    var wireFrame: OptionalShareWireFrameProtocol?

	var orderType: OrderType = OrderType.Normal
	var optionalItems: [OptionalItem] = []
    var headItems: [OptionalItem] = []
    var isMsg: Bool = false
    var isBs:Bool = false
    init() {}
	
	func setOptionOrderType(type: OrderType) {
		orderType = type
		view?.orderRefresh()
	}
	
	func updateLocalRealm() {
		interactor?.updateLocalRealm(optionalItems)
	}
	
	func fetchStockDataFromRealm() {
		interactor?.fetchStockDataFromRealm()
	}

	func returnStockDataFromRealm(results: [OptionalItem]) {
        optionalItems = results
		view?.startRefresh()
		interactor?.checkLocalStockStatus()
        view?.fetchLocalStockSuccess()
	}
    
    func returnHeaderStockDataFormServer(results: [OptionalItem],isMsg:Bool) {
        headItems = results
        self.isMsg = isMsg
    }
    
    func setHeaderState(type:String)  {
        self.isMsg = false
        self.view?.startRefresh()
    }
    
    func updateItem() {
        headItems.removeAll()
        _ =  optionalItems.map{
            if  $0.stockCode == "sh000001" || $0.stockCode == "sz399001" {
                headItems.append($0)
            }
        }
        view?.fetchLocalStockSuccess()
    }
	
	func regularlyUpdateStockDataFromServer() {
		view?.startRefresh()
        //当列表为空时，只执行头部刷新接口
        if optionalItems.count <= 0 {
            interactor?.updateHeaderItems({ (success, data) in
                if success {
                    self.headItems = data as! [OptionalItem]
                    self.view?.fetchServerStockSuccess(regularlyRefresh: true)
                }else {
                    self.view?.fetchServerStockFailure()
                }
            })
        }else{
           interactor?.regularlyUpdateStockFromServer(optionalItems.map { $0.stockCode })
        }
	}
	
	func returnRegularlyStockFromServer(results: [OptionalItem]?) {
		convertServerDataToShow(results)
		view?.fetchServerStockSuccess(regularlyRefresh: true)
	}

	func returnStockDataFromServerFailure() {
		view?.fetchServerStockFailure()
	}
	
	func updateStockDataFromRealm(results: [OptionalItem]) {
		self.optionalItems = results
		view?.fetchServerStockSuccess(regularlyRefresh: false)
	}
    
     func setDataToHeaderView(view: OptionalShareHeaderDataSources) {
        view.setItems(headItems)
        view.setChangeState(self.isMsg)
        view.setBsState(self.isBs)
    }
	
	private func convertServerDataToShow(serverData: [OptionalItem]?) {
		guard let _results = serverData else { return }

		var serverDataDic = [String : Int]()
		for index in 0 ..< _results.count {
			let result = _results[index]
			serverDataDic.updateValue(index, forKey: result.stockCode)
		}
		
		for item in optionalItems{
			guard let resultIndex = serverDataDic[item.stockCode] else { break }
			item.change = _results[resultIndex].change
			item.changePct = _results[resultIndex].changePct
			item.lastPrice = _results[resultIndex].lastPrice
			item.status = _results[resultIndex].status
			item.trend = _results[resultIndex].trend
		}
	}

	func didSelectOptionalShareItem(atIndexPath indexPath: NSIndexPath, controller: UINavigationController) {	
		var roughStocks: [RoughStock] = []
		for model in optionalItems {
			let roughStock = RoughStock(name: model.stockName, code: model.stockCode)
			roughStocks.append(roughStock)
		}
		
		let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
        //let vc = StockDetailView()
        let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
		vc.currentRoughStockPos = indexPath.row
		vc.roughStocks = roughStocks
		controller.pushViewController(vc, animated: true)
	}
    
    func didTapOptionalHeaderView(index: Int, controller: UINavigationController){
        var roughStocks: [RoughStock] = []
        for model in headItems {
            let roughStock = RoughStock(name: model.stockName, code: model.stockCode)
            roughStocks.append(roughStock)
        }
        
        let storyboard = UIStoryboard(name: "StockDetails", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("StockDetailsViewID") as! StockDetailsView
        vc.currentRoughStockPos = index
        vc.roughStocks = roughStocks
        controller.pushViewController(vc, animated: true)
    }
    
    func numberOfItems(shareView section: Int) -> Int {
		return self.optionalItems.count
    }
    
    func setContentToView(shareView view: OptionalShareListDataSources, indexPath: NSIndexPath) {
		if self.optionalItems.count > 0 {
			var orderedOptionalItems = self.optionalItems
			switch orderType {
			case .Normal: print("")
			case .PriceAscending:
				orderedOptionalItems = optionalItems.sort({ (s1, s2) -> Bool in
					(s1.lastPrice as NSString).floatValue < (s2.lastPrice as NSString).floatValue
				})
			case .PriceDescending:
				orderedOptionalItems = optionalItems.sort({ (s1, s2) -> Bool in
					(s1.lastPrice as NSString).floatValue > (s2.lastPrice as NSString).floatValue
				})
			case .RiseAscending:
				orderedOptionalItems = optionalItems.sort({ (s1, s2) -> Bool in
					(s1.changePct as NSString).floatValue < (s2.changePct as NSString).floatValue
				})
			case .RiseDescending:
				orderedOptionalItems = optionalItems.sort({ (s1, s2) -> Bool in
					(s1.changePct as NSString).floatValue > (s2.changePct as NSString).floatValue
				})
			}
			
			let optionalItem = orderedOptionalItems[indexPath.row]
			view.set(stockName: optionalItem.stockName)
			view.set(stockCode: optionalItem.stockCode)
			view.set(trend: optionalItem.trend)
			view.set(changePct: optionalItem.changePct, status: optionalItem.status)
			view.set(lastPrice: optionalItem.lastPrice)
            if optionalItem.isStrategy != nil {
              view.set(strategy: optionalItem.isStrategy!)
            }
		}
    }
}
