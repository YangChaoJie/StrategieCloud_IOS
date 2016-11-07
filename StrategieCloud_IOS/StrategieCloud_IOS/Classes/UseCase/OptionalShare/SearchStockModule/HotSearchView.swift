//
//  HotSearchView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 2016/11/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
class HotSearchView: SearchStockView {
    var headHeight = CGFloat(30)
    override func viewWillAppear(animated: Bool) {
        presenter?.gethotdiagnosedstock()
    }
    
    override func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty {
            headHeight = 30
            presenter?.gethotdiagnosedstock()
        } else {
            headHeight = 0
            presenter?.searchStock(withText: searchText)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headHeight
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        tableView.frame = CGRectMake(0, 40, AppWidth, AppHeight - 40-NavigationH)
        return  headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        presenter?.enterStockDetailPage(withIndex: indexPath, inView: self.navigationController!,viewTag: 2)
    }
    
    private lazy var headerView: SearchHeadView = {
        let _view = SearchHeadView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        return _view
    }()
    
}