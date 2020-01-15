//
//  DFNetManager.swift
//  CamdoraSwift
//
//  Created by user on 12/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit
import Alamofire

enum DFNetworkStatus : Int {
    /*! 未知网络 */
    case DFNetworkStatusUnknown
    /*! 没有网络 */
    case DFNetworkStatusNotReachable
    /*! 手机 3G/4G 网络 */
    case DFNetworkStatusReachableViaWWAN
    /*! wifi 网络 */
    case DFNetworkStatusReachableViaWiFi
    
}

enum DFHttpRequestType : Int {

    case DFHttpRequestTypeGet

    case DFHttpRequestTypePost

    case DFHttpRequestTypePut
    
    case DFHttpRequestTypeDelete
    
}

typealias DFNetWorkStatusBlock = ((_ status: DFNetworkStatus) -> Void)
typealias DFResponseSuccess = ((_ response: Any) -> Void)
typealias DFResponseFailed = ((_ error: Error) -> Void)



class DFNetManager: NSObject {
    
    static let sharedManager = DFNetManager()
    
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    var networkStatus : DFNetworkStatus = .DFNetworkStatusUnknown
    
//    var baseUrl: String? = nil
    lazy var headers : HTTPHeaders = [:]
    
    private var sessionManager = Alamofire.SessionManager.default
}

//TODO:get、post请求
extension DFNetManager {
    /*!
     *  网络请求方法,block回调
     *
     *  @param type         get / post
     *  @param urlString    请求的地址
     *  @param paraments    请求的参数
     *  @param successBlock 请求成功的回调
     *  @param failureBlock 请求失败的回调
     *  @param progress 进度
     */
    func df_requestWithType(type: DFHttpRequestType = .DFHttpRequestTypeGet, urlString: String, parameters: [String:Any]?, successBlock: @escaping DFResponseSuccess, failureBlock: @escaping DFResponseFailed) -> Void/*NSURLRequest*/ {
        
        let methodType = changeRequest(dfRequestType: type)
        
        sessionManager.request(urlString, method: methodType, parameters: parameters, headers: headers).responseJSON { (response) in
            
            if let error = response.error {
                failureBlock(error)
                return
            }
            if let json = response.result.value {
                successBlock(json)
            }
        }
    }
    
    
    private func changeRequest(dfRequestType: DFHttpRequestType) -> HTTPMethod {
        switch dfRequestType {
        case .DFHttpRequestTypeGet:
            return .get
        case .DFHttpRequestTypePost:
            return .post
        case .DFHttpRequestTypePut:
            return .put
        default:
            return .get
        }
    }
}

//TODO:网络监测
extension DFNetManager {
    func df_startNetWorkMonitoring(_ networkBlock : @escaping DFNetWorkStatusBlock) -> Void {
        manager?.listener = {[weak self] status in

            switch status {
            case .unknown:
                self?.networkStatus = .DFNetworkStatusUnknown
                networkBlock(.DFNetworkStatusUnknown)
                
            case .notReachable:
                self?.networkStatus = .DFNetworkStatusNotReachable
                networkBlock(.DFNetworkStatusNotReachable)
                
            case .reachable(let connectionType) where connectionType == .ethernetOrWiFi:
                self?.networkStatus = .DFNetworkStatusReachableViaWiFi
                networkBlock(.DFNetworkStatusReachableViaWiFi)
                
            case .reachable(let connectionType) where connectionType == .wwan:
                self?.networkStatus = .DFNetworkStatusReachableViaWWAN
                networkBlock(.DFNetworkStatusReachableViaWWAN)

            default: break
                
            }
        }
        let flag = manager?.startListening()
        print( "==== \(flag ?? false)")
    }
}

//TODO:配置请求头等信息
extension DFNetManager {
//    func setBaseUrl(baseUrl: String?) {
//        self.baseUrl = baseUrl
//    }
    
    func addHeaderToManager(value: String?, header: String) {
        guard let value = value else {
            headers.removeValue(forKey: header)
            return
        }
        headers[header] = value
    }
    
    func setTimeOut(timeout: Double) {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        self.sessionManager = Alamofire.SessionManager(configuration: config)
    }
}










