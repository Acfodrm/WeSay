//
//  DataBaseDAL.swift
//  WeSay
//
//  Created by QLX on 15/7/6.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

enum SayType:Int{
    case MixType
    case VideoType
    case TextType
    case PictureType
    case HotType
}
class DataBaseDAL: NSObject {

    static let instance = DataBaseDAL()
    var pageArray  = [0,0,0,0,0]
    class func getInstance() -> DataBaseDAL{
        return instance
    }

    //  获取上次刷新时间
    func getLastRefreshTimeWithType(type : SayType) -> Double{
        var time: AnyObject? = NSUserDefaults.standardUserDefaults().valueForKey("lastRefreshTime\(type.rawValue)" )
        if( time != nil){
            return time as! Double
        }
        return NSDate().timeIntervalSince1970
    }
    
    var curTime:Double {
        get{
            return NSDate().timeIntervalSince1970
        }
    }
    // 设置上次刷新时间
    func setLastRefreshTimeWithType(time: Double , type : SayType){
        NSUserDefaults.standardUserDefaults().setValue(time, forKey: "lastRefreshTime\(type.rawValue)")
    }
    
    
    
    
    
    func  headerRefreshWithType(type: SayType){
        self.setLastRefreshTimeWithType(self.curTime, type: type)
        self.pageArray[type.rawValue] = 0
        HttpRequestManager.getInstance().downloadArticleRequest(type, endTime: self.curTime, page: 0) { (json) -> Void in
            if let jsonData = json{
                
                
            }else {
                println("网络请求错误")
            }
        }
        
        
    }
    func footerRefreshWithType(type: Int){
        
    }
    
    
    
    
    
}
