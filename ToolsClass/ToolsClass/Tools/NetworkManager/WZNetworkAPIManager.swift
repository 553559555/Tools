//
//  WZNetworkAPIManager.swift
//  ToolsClass
//
//  Created by arther on 2018/9/14.
//  Copyright © 2018年 arther. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum WZNetworkState: Int {
    case Success = 0
    case TokenExpire = 918
    case RefreshTokenExpire = 919
}

protocol WZNetworkAPIManagerDelegate: class {
    func APIManagerDidSuccess(_ APIManager: WZNetworkAPIManager, whit responseData: JSON)
    func APIManagerDidFail(_ APIManager: WZNetworkAPIManager, whitError error: NSError)
    func APIManagerNeedReLoginGetToken(_ APIManager: WZNetworkAPIManager)
}

protocol WZNetworkAPIManagerInterface: class {
    var APIMethodName: String { get }
}

class WZNetworkAPIManager {
    
    static let errorDomain: String = "WZNetworkAPIManagerError"
    
    fileprivate weak var child: WZNetworkAPIManagerInterface!
    
    weak var APIManagerDelegate: WZNetworkAPIManagerDelegate!
    
    var parameters: [String : Any]?
    
    var isGetMethod: Bool = false
    
    var token: String?
    
    var sessionTask: URLSessionTask!
    
    init() {
        if self is WZNetworkAPIManagerInterface {
            child = self as! WZNetworkAPIManagerInterface
        } else {
            assert(false, "Subclass must implement WZNetworkAPIManagerInterface protocol")
        }
    }
    
    func callAPIWhitParameters(_ parameters: [String: Any]) {
        
//        guard let sessionTask = sessionTask, sessionTask.state == .running else {
//            return
//        }
        
        var requestStr = MAIN_URL + child.APIMethodName
        
        if let token = token {
            requestStr += "?token=6fb9d93d8d1a42b9a34c611df446caed"
        }
        
        self.parameters = parameters
        
        sendRequest(requestStr: requestStr, parameters: parameters) { [unowned self] json in
            let returnCode = json["code"].intValue
            
            if returnCode == WZNetworkState.Success.rawValue {
                self.APIManagerDelegate.APIManagerDidSuccess(self, whit: json["data"])
            } else if returnCode == WZNetworkState.TokenExpire.rawValue {
                self.APIManagerDelegate.APIManagerNeedReLoginGetToken(self)
            } else {
                let userInfo : [String: Any] = [
                    NSLocalizedDescriptionKey: "API调用成功，后台返回错误。",
                    NSLocalizedFailureReasonErrorKey: json["msg"].stringValue
                ]
            
                let error = NSError(domain: WZNetworkAPIManager.errorDomain, code: returnCode, userInfo: userInfo)
                self.APIManagerDelegate.APIManagerDidFail(self, whitError: error)
            }
            
        }
        
    }
    
    fileprivate func sendRequest(requestStr: String, parameters: [String : Any]?, success:((JSON) -> Void)?) {
        // 获取请求方式
        let method = isGetMethod == true ? HTTPMethod.get : HTTPMethod.post
        // 发送网络请求
        Alamofire.request(requestStr, method: method, parameters: parameters).responseJSON { (response) in
            
            print(response.result)
            
            // 3.获取结果
            guard let result = response.result.value else {
                print(response.result.error!)
                return
            }
            
            // 4.将结果回调出去
            success!(JSON(result))
            
        }
    }
    
}
