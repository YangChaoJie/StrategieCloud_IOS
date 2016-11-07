//
//  OptionSearchView.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/4.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit

class SearchStockView: BaseVC, SearchStockViewProtocol {
	
	var presenter: SearchStockPresenterProtocol?
	private let CellHeight = CGFloat(44)
	private let FooterHeight = CGFloat(30)
	private var showSearchHistory = true
    var viewTag:Int = 0
	struct Nib {
		static let CellName = "SearchViewCell"
	}
	
	struct Cell {
		static let CellID = "SearchViewCellID"
	}

	struct HintName {
		static let Title = "个股搜索"
		static let searchBarPlaceholder = "请输入股票代码／简拼/名称"
	}
	
	// MARK: - View Life
    override func viewDidLoad() {
        super.viewDidLoad()
		commonInit()
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.tableView)
    }
	
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        //presenter?.uploadStock()
    }
    
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
        if searchBar.text == "" {
                presenter?.searchHistoryStock()
        }
		
	}
	
	// MARK: - SearchStockViewProtocol

	func notifyFetchSuccess() {
		print(#function)
		
		self.tableView.reloadData()
	}
	
	func notifyFetchFailure() {
		//弹出框提示
		print(#function)
		self.tableView.reloadData()
	}
	
	
	// MARK: - Private Method
	
	private func commonInit() {
		self.view.backgroundColor = UIColor.whiteColor()
		self.navigationItem.title = HintName.Title
		presenter = SearchStockPresenter()
		presenter?.view = self
	}
	
	@objc private func hideKeyboard() {
		searchBar.resignFirstResponder()
	}

    private lazy var searchBar : UISearchBar = {
		let bar = UISearchBar()
		bar.becomeFirstResponder()
		bar.barTintColor = UIColor.NavBarColor().colorWithAlphaComponent(0.6)
		bar.backgroundColor = UIColor.blueColor()
		bar.frame = CGRectMake(0, 0, AppWidth, self.CellHeight)
		bar.delegate = self
		bar.placeholder = HintName.searchBarPlaceholder
		return bar
    }()
    
    private lazy var tableView : UITableView = {
		let _tableView = UITableView()
		_tableView.frame = CGRectMake(0, self.CellHeight, AppWidth, AppHeight - self.CellHeight-HeaderH)
		_tableView.tableFooterView = UIView()
		_tableView.registerNib(UINib(nibName: Nib.CellName, bundle: nil), forCellReuseIdentifier: Cell.CellID)
        _tableView.dataSource = self
        _tableView.delegate = self
        return _tableView
    }()
    
    private lazy var headerView: SearchHeadView = {
       let _view = SearchHeadView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.width, height: self.FooterHeight))
        return _view
    }()
}

// MARK: - UISearchBarDelegate

extension SearchStockView : UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {
                // 显示历史搜索
                showSearchHistory = true
                presenter?.searchHistoryStock()
            } else {
                // 显示搜索结果
                showSearchHistory = false
                presenter?.searchStock(withText: searchText)
            }
    }
   
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
		self.hideKeyboard()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchStockView : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let items = (self.presenter?.numberOfItems(inSection: section))!
		return items
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell.CellID)! as! SearchViewCell
		cell.delegate = self
		presenter?.setContentToView(cell, indexPath: indexPath)
        return cell
    }
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
        presenter?.addStockToSearchHistory(fromIndex: indexPath)
        presenter?.enterStockDetailPage(withIndex: indexPath, inView: self.navigationController!,viewTag: self.viewTag)
	}

	func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let view = SearchStockFooterView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: FooterHeight))
		view.delegate = self
		view.historyBtn.hidden = !showSearchHistory
		view.historyBtn.enabled = !presenter!.historyStockEmpty()
		return view
	}
	
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return FooterHeight
	}
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		self.hideKeyboard()
	}
}

// MARK: - SearchViewCellDelegate
extension SearchStockView: SearchViewCellDelegate {
	func searchViewAddStock(name name: String, code: String) {
		presenter?.addStock(withName: name, code: code)
	}
}

// MARK: - SearchStockFooterViewDelegate
extension SearchStockView: SearchStockFooterViewDelegate {
	func clearStockSearchHistory() {
        presenter?.deleteStockSearchHistory()
		print(#function)
		//显示弹出框，是否删除历史记录
	}
}

