//
//  PNHandyJSONMapper.swift
//  PNStarCalendar
//
//  Created by Thor on 2018/7/9.
//  Copyright © 2018年 http://www.cnblogs.com/saytome/. All rights reserved.
//

import RxSwift
import HandyJSON
import Moya


private let responseCode = "status"
private let responseMessage = "msg"


private enum MapError : Swift.Error {
    case errorInfo(String)
}


extension MapError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .errorInfo(let text): return NSLocalizedString(text, comment: "error")
        }
    }
}


public extension Observable {
    //MARK: model
    func handyModel<T: HandyJSON>(_ type: T.Type, designatedPath: String? = nil) -> Observable<T> {
        return map { response in
            // 得到response
            guard let response = response as? Moya.Response else {
                throw MapError.errorInfo("noResponse")
            }
            
            // check status code
            if response.statusCode == 403 {
                throw MapError.errorInfo("ban error");
            }
            guard ((200...209) ~= response.statusCode) else {
                var errorMsg = "\(response.statusCode)";
                if let urlString = response.request?.url?.absoluteString {
                    errorMsg = errorMsg + urlString;
                }
                throw MapError.errorInfo(errorMsg);
            }
            
          
            guard let json = try? JSONSerialization.jsonObject(with: response.data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String: Any]  else {
                throw MapError.errorInfo("json serialization error")
            }
            
            if designatedPath == nil {
                if let object = JSONDeserializer<T>.deserializeFrom(dict: json) {
                    return object;
                }else {
                    throw MapError.errorInfo("handly path json error")
                }
                
            }else {
                
                if let object = JSONDeserializer<T>.deserializeFrom(dict: json, designatedPath: designatedPath) {
                    return object;
                }else {
                    throw MapError.errorInfo("handly json error")
                }
            }
        }
    }
}














