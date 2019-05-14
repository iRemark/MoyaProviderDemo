//
//  PNServerAPI.swift
//  PNStarCalendar
//
//  Created by Thor on 2018/6/20.
//  Copyright © 2018年 http://www.cnblogs.com/saytome/. All rights reserved.
//

import Moya
import RxSwift

//正式host
public let api_host = "https://api.superpanda.pw";

//测试host
//public let api_host = "https://beta.shopy365.xyz"



public struct ServerStruct: TargetType {
    
    /// The target's base `URL`.
    public var baseURL: URL;
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    public var path: String;
    
    /// The HTTP method used in the request.
    public var method: Moya.Method;
    
    /// Provides stub data for use in testing.
    public var sampleData: Data;
    
    /// The type of HTTP task to be performed.
    public var task: Task;
    
    /// The type of validation to perform on the request. Default is `.none`.
    public var validationType: ValidationType;
    
    /// The headers to be used in the request.
    public var headers: [String: String]?;
    

    ////init
    public init(path:String = "",
                headers:[String: String] = [:],
                method: Moya.Method = .get,

                sampleData:Data = Data(),
                task:Task = .requestPlain,
                validationType:ValidationType = .none)
    {

//        var configHeader : Dictionary<String, String> = ["token": "PNUserModel.user.token"];
//        for e in headers {
//            configHeader[e.key] = headers[e.key] as? String
//        }
        
        
        var configHeader : Dictionary<String, String> =
            ["api-version": "v1.0",
             "Content-Type":"application/json",
             "Accept":"application/json",
             "Accept-Language": "en-US"];
//                en-US
        
        
        for h in headers {
            configHeader[h.key] = headers[h.key];
        }
        
        self.baseURL = URL.init(string: api_host)!;
        self.path = path;
        self.headers = configHeader;
        self.method = method;

        self.sampleData = Data();
        self.task = task;
        self.validationType = .none;
        
        print("\n");
        print("🌎1 \(method): \("api_host")\(path)")
        print("🌎2 header: \(headers)")
        
        //3 task
        printTask(task: task);
        
        
        
    }
}

//print task for debug
public func printTask(task:Task) {
    switch task {
    /// A request with no additional data.
    case .requestPlain :
        break
        
    /// A requests body set with data.
    case .requestData(_) :
        break
        
    case .requestJSONEncodable(_) :
        break
        
    /// A request body set with `Encodable` type and custom encoder
    case .requestCustomJSONEncodable(_,_):
        break
        
    /// A requests body set with encoded parameters.
    case .requestParameters(let parameters, _):
        print("🌎3 task: \(parameters)");
        return;
        
    /// A requests body set with data, combined with url parameters.
    case .requestCompositeData(_,_):
        break
    /// A requests body set with encoded parameters combined with url parameters.
    case .requestCompositeParameters(_,_,_):
        break
        
    /// A file upload task.
    case .uploadFile(_):
        break
        
    /// A "multipart/form-data" upload task.
    case .uploadMultipart(_):
        break
        
    /// A "multipart/form-data" upload task  combined with url parameters.
    case .uploadCompositeMultipart(_,_):
        break
        
    /// A file download task to a destination.
    case .downloadDestination(_):
        break
        
    /// A file download task to a destination with extra parameters using the given encoding.
    case .downloadParameters(_,_,_):
        break
        
//    default:
//        break;
        
    }
    print(" 🌎3 task: \(task)")
}




public protocol SeverStructProtocol {
    associatedtype ServerStructType: TargetType
    var severStruct: ServerStructType { get }
}
































