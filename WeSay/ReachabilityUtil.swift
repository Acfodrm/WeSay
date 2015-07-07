//
//  ReachabilityUtil.swift
//  WeSay
//
//  Created by QLX on 15/6/25.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class ReachabilityUtil: NSObject {
    class func isConnectNetwork()->Bool{
        var reach = Reachability.reachabilityForLocalWiFi()
        return reach.isReachable()
    }
    class func isConnectWifi()->Bool{
        var reach = Reachability.reachabilityForLocalWiFi()
        return reach.isReachableViaWiFi()
    }
    class func isConnectWWlan()->Bool{
        var reach = Reachability.reachabilityForLocalWiFi()
        return reach.isReachableViaWWAN()
    }
}
