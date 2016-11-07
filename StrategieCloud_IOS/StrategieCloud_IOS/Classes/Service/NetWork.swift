//
//  NetWork.swift
//  ArtOfWarCloud_IOS
//
//  Created by 杨超杰 on 16/4/7.
//  Copyright © 2016年 JUNYI. All rights reserved.
//

import UIKit
import Alamofire

public enum BackendError: ErrorType {
	case Network(error: NSError)
	case DataSerialization(reason: String)
	case JSONSerialization(error: NSError)
	case ObjectSerialization(reason: String)
	case XMLSerialization(error: NSError)
}

// ResponseObjectSerializable
public protocol ResponseObjectSerializable {
	init?(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Request {
	public func responseObject<T: ResponseObjectSerializable>(completionHandler: Response<T, BackendError> -> Void) -> Self {
		let responseSerializer = ResponseSerializer<T, BackendError> { request, response, data, error in
			guard error == nil else { return .Failure(.Network(error: error!)) }
			
			let JSONResponseSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
			let result = JSONResponseSerializer.serializeResponse(request, response, data, error)
			
			switch result {
			case .Success(let value):
				if let
					response = response,
					responseObject = T(response: response, representation: value)
				{
					return .Success(responseObject)
				} else {
					return .Failure(.ObjectSerialization(reason: "JSON could not be serialized into response object: \(value)"))
				}
			case .Failure(let error):
				return .Failure(.JSONSerialization(error: error))
			}
		}
		
		return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
}

// ResponseCollectionSerializable
public protocol ResponseCollectionSerializable {
	static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
	static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
		var collection = [Self]()
		
		if let representation = representation as? [[String: AnyObject]] {
			for itemRepresentation in representation {
				if let item = Self(response: response, representation: itemRepresentation) {
					collection.append(item)
				}
			}
		}
		
		return collection
	}
}

extension Alamofire.Request {
	public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
		let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
			guard error == nil else { return .Failure(.Network(error: error!)) }
			
			let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
			let result = JSONSerializer.serializeResponse(request, response, data, error)
			
			switch result {
			case .Success(let value):
				if let response = response {
					return .Success(T.collection(response: response, representation: value))
				} else {
					return .Failure(. ObjectSerialization(reason: "Response collection could not be serialized due to nil response"))
				}
			case .Failure(let error):
				return .Failure(.JSONSerialization(error: error))
			}
		}
		
		return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
}

// ResponseCollectionSerializableData
public protocol ResponseCollectionSerializableData {
	static func collectionData(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension ResponseCollectionSerializableData where Self: ResponseObjectSerializable {
	static func collectionData(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self] {
		var collection = [Self]()

		if let representation = representation.valueForKeyPath("data") as? [NSDictionary] {
			for itemRepresentation in representation {
				if let item = Self(response: response, representation: itemRepresentation) {
					collection.append(item)
				}
			}
		}
        
		return collection
	}
}

extension Alamofire.Request {
	public func responseCollectionData<T: ResponseCollectionSerializableData>(completionHandler: Response<[T], BackendError> -> Void) -> Self {
		let responseSerializer = ResponseSerializer<[T], BackendError> { request, response, data, error in
			guard error == nil else { return .Failure(.Network(error: error!)) }
			
			let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
			let result = JSONSerializer.serializeResponse(request, response, data, error)
            
			switch result {
			case .Success(let value):
				if let response = response {
					return .Success(T.collectionData(response: response, representation: value))
				} else {
					return .Failure(. ObjectSerialization(reason: "Response collection could not be serialized due to nil response"))
				}
			case .Failure(let error):
				return .Failure(.JSONSerialization(error: error))
			}
		}
		
		return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
	}
}


enum Router : URLRequestConvertible {
	static var APIVersion = "v1.0"
    static let APIVersion1_3 = "v1.3"
    static var serverPath = "http://120.77.26.40:8080/"
	//static var baseURLString = "\(Router.serverPath)\(Router.APIVersion)"
	
	//static let baseURLString = "http://www.ringeartech.cn/\(Router.APIVersion)"
	static let baseShareImgUrl = "http://www.ringeartech.cn/v1.0" + "/shareimage/"

    static var OAuthToken: String?
    case registerUser(phone_number: String, authenticode: String, password : String)
    case getAuthenticode(String,String)
    case userLogin(phone_number: String, password : String)
    case LoginOut([String: AnyObject])
    case resetPassword(phone_number: String, authenticode: String, password : String)
    case AddUser([String: AnyObject])
    case MinuteTick(String, String)
    case avatarUploadUrl
    case updateUserinfo([String: AnyObject])
    case getUserInfo
    case searchTicket(String)
    case UploadTickers([String: AnyObject])
    case GetTickets
	case UpdateTickets([String: AnyObject])
    
    case UpdateStocks([String: AnyObject])
	
	case StockDetail(String)
	case AowInfo([String: AnyObject])
	case BacktestData([String: AnyObject])
	case AowDetail(ticker: String)
	case ProfitRankDetail([String: AnyObject])
	case ChosenByProfitRank([String: AnyObject])
	case KLineIndex(String, String)
	case KLineData(String)
	
	case ImageShareUploadUrl
    case deleteTickets([String: AnyObject])
    
    case glamourStock(String)
    
    case getMarkInfo
    case getMarkMoreInfo(String)
    case getIndustryInfo(String)
    
    case getNoticeSwitch
    case setNoticeSwitch([String: AnyObject])
    
    case getThirdPartySecret(String)
    case loginByOpenId([String: AnyObject])
    
    case suggest([String: AnyObject])
    
    case getProfitRank(String)
    
    case getStrategyProfitRank
    case getProfitRankMore(String)
    
    case getStategyChosenStock
    
    case getChosenAlert
    
    case getStrategyWinInfo(String)
    
    case aowSettingStrategy([String: AnyObject])
    
    case getStrategyAowDetail(String)
    
    case getstrategyRank(String,String)
    
    case getChosenBsAlert(String)
    
    case newSearchTicket([String: AnyObject])
    
    case gethotdiagnosedstock
    
    case getInventorymessage
    
    case diagnosestock(String)
    
    case getChosenStock
    
    case addChosenStock([String: AnyObject])
    
    case updateStockShortInfo([String: AnyObject])
    var method: Alamofire.Method {
        switch self {
        case .AddUser:
            return .POST
        case .getAuthenticode:
            return .GET
        case .registerUser:
            return .POST
        case .userLogin:
            return .POST
        case .LoginOut:
            return .POST
        case .resetPassword:
            return .POST
			
        case .MinuteTick, .StockDetail, .AowDetail, .ImageShareUploadUrl, .KLineIndex, .KLineData:
            return .GET
		case .BacktestData, .AowInfo, .ProfitRankDetail, .ChosenByProfitRank:
			return .POST
			
        case .avatarUploadUrl:
            return .GET
        case .updateUserinfo:
            return .POST
        case .getUserInfo:
            return .GET
        case .searchTicket:
            return .GET
        case .UploadTickers, .UpdateTickets,.UpdateStocks:
            return .POST
        case .GetTickets:
            return .GET
        case .deleteTickets:
            return .POST
        case .glamourStock:
            return .GET
        case .getMarkInfo:
            return .GET
        case .getMarkMoreInfo:
            return .GET
        case .getIndustryInfo:
            return .GET
        case .getNoticeSwitch:
            return .GET
        case .setNoticeSwitch:
            return .POST
        case .getThirdPartySecret:
            return .GET
        case .loginByOpenId:
            return .POST
        case .suggest:
            return .POST
        case .getProfitRank:
            return .GET
            
        case .getStrategyProfitRank:
            return .GET
            
        case .getProfitRankMore:
            return .GET
            
        case .getStategyChosenStock:
            return .GET
        case .getChosenAlert:
            return .GET
        case .getStrategyWinInfo:
            return .GET
        case .aowSettingStrategy:
            return .POST
        case .getStrategyAowDetail:
            return .GET
        case .getstrategyRank:
            return .GET
            
        case .getChosenBsAlert:
            return .GET
            
        case .newSearchTicket:
            return .POST
            
        case .gethotdiagnosedstock:
            return .GET
            
        case .getInventorymessage:
            return .GET
         
        case .diagnosestock:
            return .GET
            
        case .getChosenStock:
            
            return .GET
            
        case .addChosenStock:
            return .POST
            
        case .updateStockShortInfo:
            return .POST
        }
    }
    
    var path : String {
        switch self {
        case .AddUser:
            return "/account/adduser/"
        case .getAuthenticode(let register, let phoneNumber):
            return "/account/authenticode/\(register)/\(phoneNumber)"
        case .registerUser:
            return "/account/registerbyphone"
        case .userLogin:
            return "/account/loginbyphone"
        case .LoginOut:
            return "/account/logout"
        case .resetPassword:
            return "/account/resetpassword"
        case .MinuteTick(let ticker, let option):
            return "/winner/minutetick/\(ticker)/\(option)"
		case .StockDetail(let ticker):
			return "/winner/stockdetail/\(ticker)"
		case .AowInfo:
			return "/winner/aowinfo"
		case .AowDetail(ticker: let ticker):
			return "/winner/aowdetail/\(ticker)"
		case .BacktestData(_):
			return "/winner/backtestdata/"
		case .ProfitRankDetail(_):
			return "/winner/profitrankdetail"
		case .ChosenByProfitRank(_):
			return "/winner/chosenbyprofitrank"
		case .ImageShareUploadUrl:
			return "/account/imageshareuploadurl"
		case .KLineIndex(let ticker, let option):
			return "/winner/volumedata/\(ticker)/\(option)"
		case .KLineData(let ticker):
			return "/winner/klinedata/\(ticker)"
			
        case .avatarUploadUrl:
            return "/account/avataruploadurl"
        case .updateUserinfo:
            return "/account/userinfo"
        case .getUserInfo:
            return "/account/userinfo"
        case .searchTicket(let ticker):
            return "/winner/equinfo/\(ticker)"
            
        case .newSearchTicket:
            return "winner/equinfo"
        case .UploadTickers:
            return "/winner/strgchosenstock/"
            //"/winner/chosenstock/"
        case .GetTickets:
            return "/winner/chosenstock/"
        case .UpdateTickets:
            return "/winner/strgstockshortinfo/"
            //"/winner/stockshortinfo/"
        case .UpdateStocks:
            return "/winner/stockshortinfo/"
        case .deleteTickets:
            return "/winner/chosenstockdelete/"
        case .glamourStock(let option):
            return "/winner/glamourstock/\(option)"
        case .getMarkInfo:
            return "/winner/marketinfo"
        case .getMarkMoreInfo(let option):
            return "/winner/marketmoreinfo/\(option)"
        case .getIndustryInfo(let industry_info):
            return "/winner/industryinfo/\(industry_info)"
        case .getNoticeSwitch:
            return "/account/noticeswitch"
        case .setNoticeSwitch:
            return "/account/noticeswitch"
        case .getThirdPartySecret(let option):
            return "/account/thirdpartysecret/\(option)"
        case .loginByOpenId:
            return "/account/loginbyopenid"
        case .suggest:
            return "/account/suggest/"
        case .getProfitRank(let option):
            return "/winner/profitrank/\(option)"
            
        case .getStrategyProfitRank:
            return "/winner/strgprofitrank/"
            
        case .getProfitRankMore(let option):
            return "/winner/profitrankmore/\(option)"
            
        case .getStategyChosenStock:
            return "/winner/strgchosenstock/"
            
        case .getChosenAlert:
            return "/winner/chosenalert/"
            
        case .getStrategyWinInfo(let option):
            return "/winner/strgaowinfo/\(option)"
        case .aowSettingStrategy:
            return "/winner/aowsetting/"
        case .getStrategyAowDetail(let option):
            return "/winner/strgaowdetail/\(option)"
        case .getstrategyRank(let option,let period):
            return "/winner/strgrank/\(option)/\(period)/"
            
        case .getChosenBsAlert(let option):
            return "/winner/chosenstockmessage/\(option)/"
            
        case .gethotdiagnosedstock:
            return "/winner/hotdiagnosedstock"
        
        case .getInventorymessage:
            return "/winner/inventorymessage"
         
        case .diagnosestock(let option):
            return "/winner/diagnosestock/\(option)"
            
        case .getChosenStock:
            return "/winner/chosenstock"
            
        case .addChosenStock:
            return "/winner/chosenstock"
            
        case .updateStockShortInfo:
            return "/winner/stockshortinfo"
        }
    }
    
    var URLRequest: NSMutableURLRequest {
        var baseURLString = "\(Router.serverPath)\(Router.APIVersion)"
        switch self {
		case .getChosenStock, .addChosenStock, .updateStockShortInfo, .KLineIndex, .KLineData, .newSearchTicket:
			baseURLString = "\(Router.serverPath)\(Router.APIVersion1_3)"
        default :
            baseURLString = "\(Router.serverPath)\(Router.APIVersion)"
        }
        let URL = NSURL(string: baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
		if !UserMannager.instance.getUserToken().isEmpty {
			mutableURLRequest.setValue(UserMannager.instance.getUserToken(), forHTTPHeaderField: "Authorization")
		}
		//print("mutableURLRequest--> \(mutableURLRequest), authori---> \(UserMannager.instance.getUserToken())")
		
        switch self {
        case .AddUser(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .registerUser(let p1, let p2 ,let p3):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:["phone_number":p1,"authenticode":p2,"password":p3]).0
        case .userLogin(let p1, let p2) :
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:["phone_number":p1,"password":p2]).0
        case .LoginOut(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .resetPassword(let p, let p1, let p2):
            return  Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:["phone_number":p,"authenticode":p1,"password":p2]).0
        case .updateUserinfo(let parameters):
             return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .UploadTickers(let parameters):
             return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .UpdateStocks(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .UpdateTickets(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .deleteTickets(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .setNoticeSwitch(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
		case .BacktestData(let parameters):
			return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
		case .ProfitRankDetail(let parameters):
			return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
		case .AowInfo(let parameters):
			return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
		case .ChosenByProfitRank(let parameters):
			return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .loginByOpenId(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .suggest(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .aowSettingStrategy(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .newSearchTicket(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .addChosenStock(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        case .updateStockShortInfo(let parameters):
             return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:parameters).0
        default:
            return  mutableURLRequest
        }
        
    }
}



