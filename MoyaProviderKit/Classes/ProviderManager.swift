//
//  PNProviderManager.swift
//  PNStarCalendar
//
//  Created by Thor on 2018/7/2.
//  Copyright © 2018年 http://www.cnblogs.com/saytome/. All rights reserved.
//


import Moya
import RxSwift
import Alamofire
import Result


public class ProviderManager {
    public init() {}
    
    let provider  = createMyProvider();
    
    static func createMyProvider() -> MoyaProvider<MultiTarget> {
        
        let provider = MoyaProvider<MultiTarget>(endpointClosure: { (target) -> Endpoint in
            ProviderManager.endpointMapping(target)
            
            
        }, requestClosure: { (endpoint, closure) in
            ProviderManager.requestMapping(endpoint, closure: closure)
            
        }, stubClosure: { (target) -> StubBehavior in
            return .never;
            
        }, callbackQueue: nil,
           manager: ProviderManager.alamofireManager(),
           plugins: [activityPlugin(),loggerPlugin(),RequestLifeCirclePlugin()],
           trackInflights: false);
        
        return provider;
    }
    
    public func request<T: SeverStructProtocol>(_ token: T) -> Single<Response> {
        let targetToken = MultiTarget(token.severStruct)
        return provider.rx.request(targetToken);
    }
}




//MARK:PluginType
final class RequestLifeCirclePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    func willSend(_ request: RequestType, target: TargetType) {
        //实现发送请求前需要做的事情
        print("");
    }
    
    //    func didReceive(_ result: Result<Moya.Response, MoyaError>, target: TargetType) {
    //        guard case Result.failure(_) = result else {
    //            return
    //        }//监听失败
    //    }
    //
    //    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
    //        return result
    //    }
    
}

extension ProviderManager {
    
    static func activityPlugin() -> PluginType {
        
        return NetworkActivityPlugin { (state, targetType) in
//            switch state {
//            case .began:
//                
//                DispatchQueue.main.async {
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = true;
//                }
//            case .ended:
//                DispatchQueue.main.async {
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false;
//                }
//            }
        }
    }
    
    static func loggerPlugin() -> NetworkLoggerPlugin {
        func reversedPrint(_ separator: String, terminator: String, items: Any...) {
            for item in items {
                print(item, separator: separator, terminator: terminator)
            }
        }
        
        return NetworkLoggerPlugin(verbose: true,
                                   output: reversedPrint,
                                   responseDataFormatter: { (data: Data) -> Data in
                                    do {
                                        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
                                        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
                                        return prettyData
                                        
                                    } catch {
                                        return data
                                    }
        });
    }
}


extension ProviderManager {
    public static func endpointMapping(_ target: MultiTarget) -> Endpoint {
        return Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: {
                //.networkResponse(200, target.sampleData)
                .networkError(NSError.init())
        },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
            
            
        )
    }
    
    
    public static func requestMapping(_ endpoint: Endpoint, closure: MoyaProvider<MultiTarget>.RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            closure(.success(urlRequest))
            
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
            
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
            
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }
    
    
    public static func alamofireManager() -> Manager {
//        let policies: [String: ServerTrustPolicy] = [
//            "47.104.102.153": .disableEvaluation
//        ]
        
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 10;
        
//        let manager = Manager(configuration: configuration,
//                              serverTrustPolicyManager: ServerTrustPolicyManager(policies: policies))
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        return manager
    }
}






