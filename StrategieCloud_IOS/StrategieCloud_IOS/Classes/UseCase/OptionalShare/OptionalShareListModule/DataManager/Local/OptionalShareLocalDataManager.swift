//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation
import RealmSwift
class OptionalShareLocalDataManager: OptionalShareLocalDataManagerInputProtocol
{
    init() {}
	func fetchStockDataFromRealm(completion: (stocks: Results<OptionalShareModel>) -> ()) {
		completion(stocks: RealmHelper.instance.fetchStock())
	}

	func fetchStockDataFromRealm(byUploadedStatus uploaded: Bool, completion: (results: Results<OptionalShareModel>) -> ()) {
		completion(results: RealmHelper.instance.fetchStockByStatus(uploaded))
	}
	
	func realmSyncServerStocks(stocks: [OptionalItem]?) {
		guard let _stocks = stocks else {
			return
		}
		if _stocks.count > 0 {
			RealmHelper.instance.updateRealmStock(fromStocks: _stocks)
		}
	}
}