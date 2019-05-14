//
//  PNAPIServer.swift
//  PNCargoOwner
//
//  Created by Thor on 2018/9/27.
//  Copyright © 2018 Thor. All rights reserved.
//


import Moya
public enum APIServer {
    //通用方法
    case request(path: String,  param: Dictionary<String,Any>, encoding: ParameterEncoding)
    
    case login(param: Dictionary<String,Any>)
    case channels(headers: Dictionary<String, String>)
    case connectInfo(id: Int, headers: Dictionary<String, String>)
}

extension APIServer: SeverStructProtocol {
    public var severStruct : ServerStruct {
        switch self {
        case .request(let path, let param, let encoding):
            return ServerStruct.init(path: path,
                                     method:.post,
                                     task:.requestParameters(parameters: param, encoding: encoding));

        case .login(let param):
            return ServerStruct.init(path: "/api/users/app/login",
                                     method:.post,
                                     task:.requestParameters(parameters: param, encoding: JSONEncoding()));
            
            
        case .channels(let headers):
            return ServerStruct.init(path: "/api/channels", headers: headers, method: .get);
            
            
        
        case .connectInfo(let id, let headers):
             return ServerStruct.init(path: "/api/channels/\(id)/connect", headers: headers, method: .post);
        }
    }
}
