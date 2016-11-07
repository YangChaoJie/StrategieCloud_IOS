//
// Created by dylan
// Copyright (c) 2016 dylan. All rights reserved.
//

import Foundation

class OptionalShareWireFrame: OptionalShareWireFrameProtocol
{
    class func presentOptionalShareModule() -> AnyObject
    {
        // Generating module components
        let view: OptionalShareViewProtocol = OptionalShareView()
        let presenter: protocol<OptionalSharePresenterProtocol, OptionalShareInteractorOutputProtocol> = OptionalSharePresenter()
        let interactor: OptionalShareInteractorInputProtocol = OptionalShareInteractor()
        let APIDataManager: OptionalShareAPIDataManagerInputProtocol = OptionalShareAPIDataManager()
        let localDataManager: OptionalShareLocalDataManagerInputProtocol = OptionalShareLocalDataManager()
        let wireFrame: OptionalShareWireFrameProtocol = OptionalShareWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDatamanager = localDataManager
        
		return view
    }

//	func presentStockDetailsModule(controller: UINavigationController) {
//		StockDetailsWireFrame.presentStockDetailsModule(fromView: controller)
//	}

//	func presentStockDetailsModule(selectedIndex index: Int, optionalShares: [OptionalShareItem], controller: UINavigationController) {
//		StockDetailsWireFrame.presentStockDetailsModule(selectedIndex: index, optionalShares: optionalShares, controller: controller)
//	}
}