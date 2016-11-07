//
//  StockQuotationRepository.swift
//  StrategieCloud_IOS
//
//  Created by 杨超杰 on 16/7/19.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import Foundation
import Alamofire
class StockQuotationRepository:StockQuotationDataSourceProtocol  {
    //API
    func getMarketInfo(completion: (success: Bool, data: StockQuotationItem?) -> ()) {
        Alamofire.request(Router.getMarkInfo).responseJSON { (response)  in
            
            switch response.result{
            case .Success(let value):
               // print("value546474747============\(value)")
                let status = value.valueForKeyPath("status") as! String
                if status == "success" {
                    let data = value.valueForKeyPath("data")
                    let stockQoutationItem = StockQuotationItem.init(representation: data!)
                    completion(success: true, data: stockQoutationItem)
                }
                
             //print("value546474747============\(data)")
                
            case .Failure(let error):
                print("\(#function) error: \(error)")
                completion(success: false, data: nil)
         }
       }
    }
    
    func getHeaderStocks(completion: (success: Bool, data: AnyObject) -> ()) {
        let tickets = ["sh000001","sz399001","sz399006","sh000300"]
        let parameters: [String: AnyObject] =
            [
                "tickers": tickets,
            ]
        Alamofire.request(Router.UpdateStocks(parameters))
            .responseCollectionData { (response: Response<[OptionalItem], BackendError>) in
                switch response.result {
                case .Success(let value):
                     print("error: \(value)")
                    completion(success: true, data: value)
                case .Failure(let error):
                    completion(success: false, data: "")
                    print("error: \(error)")
                }
        }
    }
    
    func getDataList()->[[String]] {
        return self.dataList
    }
    
    private lazy var dataList:[[String]] = {
        return [["板块","first"],["行业涨幅榜","industry"],["概念涨幅榜","concept"],["涨幅榜","equ_desc"],["跌幅榜","equ_aes"],["五分钟涨幅榜","five_min"],["换手率榜","turnover"],["量比榜","volume_rate"]]
    }()

    //local
}