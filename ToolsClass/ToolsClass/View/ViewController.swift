//
//  ViewController.swift
//  ToolsClass
//
//  Created by arther on 2018/9/14.
//  Copyright © 2018年 arther. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class ViewController: UIViewController,WZNetworkAPIManagerDelegate {
    
    func APIManagerDidSuccess(_ APIManager: WZNetworkAPIManager, whit responseData: JSON) {
        print("请求成功 = \(responseData)")
    }
    
    func APIManagerDidFail(_ APIManager: WZNetworkAPIManager, whitError error: NSError) {
        print("请求失败 = \(error)")
    }
    
    func APIManagerNeedReLoginGetToken(_ APIManager: WZNetworkAPIManager) {
        print("ToKen过期")
    }
    
    
    lazy var testNetworkAPIManager: TestNetworkAPIManager = {
        let APIManager = TestNetworkAPIManager()
        APIManager.APIManagerDelegate = self
        return APIManager
    }()
    
    lazy var testPOSTNetworkAPIManager: TestPOSTNetworkAPIManager = {
        let APIManager = TestPOSTNetworkAPIManager()
        APIManager.APIManagerDelegate = self
        return APIManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dict = ["grant_type": "password",
                    "phone": "18701422911",
                    "password": "25D55AD283AA400AF464C76D713C07AD",
                    ]
        
        testPOSTNetworkAPIManager.callAPIWhitParameters(["":""])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

