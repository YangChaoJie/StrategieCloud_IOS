//
//  EditStockPresenter.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/8.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class EditStockPresenter : EditStockPresenterProtocol{
  var repository: EditStockDataSource?
  weak var view : EditStockViewProtocol?
    var optionEditSet  = NSMutableOrderedSet()
    init() {
        repository = EditStockRepository()
    }
    
    func numberOfItems(shareView section: Int) -> Int {
        return self.optionEditSet.count
    }
    
    func setContentToView(shareView view: OptionalDataSources, indexPath: NSIndexPath) {
        let optionalShare = self.optionEditSet[indexPath.row] as! OptionalShareModel
        view.set(stockName: optionalShare.name)
        view.set(stockCode: optionalShare.code)
    }
    
    func getStock() {
        self.repository?.fetchStockRepository({ (results) in

            let array = results.map{$0}
            self.optionEditSet.addObjectsFromArray(array)
            self.view?.notifyFetchSuccess()
        })
    }
    
    //MARK: tableview Method
	func moveItem(fromIndex index1: NSIndexPath, toIndex index2: NSIndexPath) {
        self.optionEditSet.moveObjectsAtIndexes(NSIndexSet.init(index: index1.row), toIndex: index2.row)
		view?.notifyMove(fromIndex: index1, toIndex: index2)
	}
    
    func findIndexPathByCode(code: String) -> Int  {
        var a : OptionalShareModel?
        for p in self.optionEditSet {
            if (p.code as NSString).substringFromIndex(2) == code {
                a = p as? OptionalShareModel
            }
        }
        let index = self.optionEditSet.indexOfObject(a!)
        return index
    }
    
    func savePosition() {
        for index in 0..<self.optionEditSet.count{
            let model = self.optionEditSet[index] as! OptionalShareModel
            repository?.updatePosition(model, index: index)
        }
    }
    
    func delete(indexPaths :[NSIndexPath]?){
        
        if let _indexPaths = indexPaths {
            if _indexPaths.count > 0 {
                
                var stocks: [String] = []
                var array : [OptionalShareModel] = []
                for indexPath in _indexPaths {
                    let model = optionEditSet[indexPath.row] as! OptionalShareModel
                    array.append(model)
                    stocks.append(model.code)
                }
                
                repository?.deleteStockFromNetWork(stocks, completion: { (success) in
                    if success {
                        //本地数据库和tableview的更新
                        self.optionEditSet.removeObjectsInArray(array)
                        self.repository?.deleteTableItemInDataBase(array)
                        self.view?.deleteRowsAtIndexPaths(_indexPaths)
                    } else {
                        //删除失败
                        self.view?.notifyFetchFailure()
                    }
                })
            }
            
        }
    }

}
