//
//  PresentViewController.swift
//  hangge_1096
//
//  Created by 杨超杰 on 2016/10/24.
//  Copyright © 2016年 hangge.com. All rights reserved.
//

import UIKit

class PresentViewController: SearchStockView {
    var h = CGFloat(30)
    override func viewWillAppear(animated: Bool) {
        presenter?.gethotdiagnosedstock()
    }

    override func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty {
            h = 30
            presenter?.gethotdiagnosedstock()
        } else {
            h = 0
            presenter?.searchStock(withText: searchText)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return h
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  headerView
    }
    
    private lazy var headerView: SearchHeadView = {
        let _view = SearchHeadView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 30))
        return _view
    }()

}
