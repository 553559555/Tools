//
//  TestNetworkAPIManager.swift
//  ToolsClass
//
//  Created by arther on 2018/9/14.
//  Copyright © 2018年 arther. All rights reserved.
//

import Foundation

class TestNetworkAPIManager: WZNetworkAPIManager,WZNetworkAPIManagerInterface {
    var APIMethodName: String {
        return "/common/user/token"
    }
    
    override init() {
        super.init()
        isGetMethod = true
    }
}
