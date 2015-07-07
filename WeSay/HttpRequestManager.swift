//
//  HttpRequestManager.swift
//  WeSay
//
//  Created by QLX on 15/6/26.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit
class HttpRequestManager: NSObject {
    static let instance = HttpRequestManager()
    let rootURL = "http://localhost:8888/WeSayServer/"
    class func getInstance()->HttpRequestManager{
        return instance
    }
 
    //注册
    func signUp(phoneNum:String , pwd: String, isThridParty: Bool ,complete: (error :String? , userinfo :UserModel?)-> Void){
            self.signUpRequest(phoneNum, pwd: pwd, isThidParty: isThridParty, complete: { (json) -> Void in
                if let data = json {
                    var result = data["result"].boolValue
                    var desption = data["error"].stringValue
                    if(result){
                        var user = UserModel(json: data["user"])
                        complete(error: nil, userinfo: user)
                    }else{
                        complete(error: desption, userinfo: nil)
                    }
                
                }else {
                    complete(error: "网络错误", userinfo: nil)
                }
            })
    }
    //注册请求
    func signUpRequest(phoneNum:String , pwd:String , isThidParty: Bool , complete:(json : JSON? )->Void){
        Alamofire.request(.GET, URLString: rootURL+"adduser.php", parameters: ["phoneNum":phoneNum , "pwd":pwd ,"isThidParty": isThidParty]).responseJSON{ (_, _, json, error) -> Void in
            if(error != nil){
                println(error?.description)
                complete(json: nil )
            }else {
                var json = JSON(json!)
                complete(json: json)
            }
       }
        
    }
    //登录
    func login(phoneNum:String , pwd: String , complete: (error :String? , userinfo :UserModel?) ->Void){
        self.loginRequest(phoneNum, pwd: pwd, complete: { (json) -> Void in
            if let data = json {
                var result = data["result"].boolValue
                var desption = data["error"].stringValue
                if(result){
                    var user = UserModel(json: data["user"])
                    complete(error: nil, userinfo: user)
                }else{
                    complete(error: desption, userinfo: nil)
                }
                
            }else {
                complete(error: "网络错误", userinfo: nil)
            }
        })
    }
    //第三方登录
    func login(name : String , headURL : String ,complete: (error :String? , userinfo :UserModel?) ->Void){
        self.loginRequest(name, headURL: headURL) { (json) -> Void in
            if let data = json {
                var result = data["result"].boolValue
                var desption = data["error"].stringValue
                if(result){
                    var user = UserModel(json: data["user"])
                    complete(error: nil, userinfo: user)
                }else{
                    complete(error: desption, userinfo: nil)
                }
                
            }else {
                complete(error: "网络错误", userinfo: nil)
            }
        }

    }
    //登录请求
    func loginRequest(phoneNum:String , pwd:String , complete:(json : JSON? )->Void){
        Alamofire.request(.GET, URLString: rootURL+"login.php", parameters: ["phoneNum":phoneNum , "pwd":pwd ,"isThidParty": false]).responseJSON{ (_, _, json, error) -> Void in
            if(error != nil){
                println(error?.description)
                complete(json: nil )
            }else {
                var json = JSON(json!)
                complete(json: json)
            }
        }

    }
    //第三方登录请求
    func loginRequest(name : String , headURL : String , complete:(json : JSON? )->Void){
        Alamofire.request(.GET, URLString: rootURL+"login.php", parameters: ["nickName":name , "headURL":headURL ,"isThidParty": true]).responseJSON{ (_, _, json, error) -> Void in
            if(error != nil){
                println(error?.description)
                complete(json: nil )
            }else {
                var json = JSON(json!)
                complete(json: json)
            }
        }
        
    }
    
    //投稿
    func submitValueWithText(text : String , image : UIImage? , videoFileURL : NSURL? , uid : String , tid: String , complete : (error : String? ) -> Void){
        
        if(image != nil){
            self.uploadImage(image, uid: uid, tid: tid, complete: { (error, path) -> Void in
                if(error == nil){
                    self.submmitText(text, uid: uid, tid: tid, imagePath: path, videoPath: "", complete: complete)
                }else {
                    complete(error: "投稿失败")
                }
            })
       }else if(videoFileURL != nil){
            self.uploadVideo(videoFileURL!, uid: uid, tid: tid, complete: { (error, path) -> Void in
                if(error == nil){
                    self.submmitText(text, uid: uid, tid: tid, imagePath: "", videoPath: path, complete: complete)
                }else {
                    complete(error: "投稿失败")
                }
            })
        }else {
            self.submmitText(text, uid: uid, tid: tid, imagePath: "", videoPath: "", complete: complete)
        }
    }
    
    //上传图片
    func uploadImage(image:UIImage? , uid : String, tid : String , complete : (error : String? , path : String) -> Void){
        self.uploadImageRequest(image, uid: uid, tid: tid) { (json) -> Void in
            if let data = json {
                 var result = data["result"].boolValue
                if(result){
                    var path = data["path"].stringValue
                    complete(error: nil, path: path)
                }else{
                    var error = data["error"].stringValue
                    complete(error: error, path: "")
                }
            }else {
                
            }
        }
    }
    //上传图片请求
    func uploadImageRequest(image:UIImage? , uid : String, tid : String , complete : (json : JSON?) -> Void){
        if let i = image{
            var data = i.getJPEGData()
            AlamofireExt.upload(rootURL+"addImage.php", fileData: data, parameters: ["uid":uid , "tid" : tid ,"type" : "jpg"] ).responseJSON(completionHandler: { (_, _, json, error) -> Void in
                if(error != nil){
                    println(error?.description)
                    complete(json: nil )
                }else {
                    var json = JSON(json!)
                    complete(json: json)
                }
            })
            
        }
        
    }
    //上传视频
    func uploadVideo(fileURL : NSURL , uid : String, tid: String , complete : (error : String? , path : String ) ->Void ){
        self.uploadVideoRequest(fileURL, uid: uid, tid: tid) { (json) -> Void in
            if let data = json {
                var result = data["result"].boolValue
                var error = data["error"].stringValue
                if(result){
                    var path = data["path"].stringValue
                    complete(error: nil, path: path)
                }else {
                    complete(error: error, path: "")
                }
            }else {
                complete(error: "网络错误", path: "")
            }
        }
    }
    //上传视频 请求
    func uploadVideoRequest(fileURL : NSURL , uid : String , tid : String, complete : (json : JSON?) -> Void){
        var path = fileURL.path!
        var type = path.getFileType()
         AlamofireExt.upload(rootURL+"addVideo.php" , fileUrl: fileURL, parameters: ["uid":uid , "tid":tid , "type":type]).responseJSON { (_, _, json, error) -> Void in
            if(error != nil){
                println(error?.description)
                complete(json: nil )
            }else {
                var json = JSON(json!)
                complete(json: json)
            }
        }
    }
    
    //上传文本
    func submmitText(text:String , uid:String , tid:String , imagePath:String, videoPath:String , complete:(error:String?)->Void){
        self.submmitTextRequest(text, uid: uid, tid: tid, imagePath: imagePath, videoPath: videoPath) { (json) -> Void in
            if let data = json{
                var result = data["result"].boolValue
                var error = data["error"].stringValue
                var sql = data["sql"].stringValue
                println(sql)
                if(result){
                    complete(error: nil)
                }else {
                    complete(error: error)
                }
            }else {
                complete(error: "网络错误")
            }
        }
        
    }
    //上传文本请求
    func submmitTextRequest(text:String , uid:String , tid:String , imagePath:String, videoPath:String , complete:(json:JSON?)->Void){
        Alamofire.request(.GET, URLString: rootURL+"addValue.php", parameters: ["text":text,"uid":uid,"tid":tid,"imagePath":imagePath,"videoPath":videoPath]).responseJSON { (_, _, json, error) -> Void in
            if(error != nil){
                println(error?.description)
                complete(json: nil )
            }else {
                var json = JSON(json!)
                complete(json: json)
            }
        }
    }
    
    
    // 下载说说请求
    
    func downloadArticleRequest(type: SayType , endTime: Double , page:Int , complete: (json:JSON? )->Void ){
        Alamofire.request(.GET, URLString: rootURL + "getValue.php", parameters: ["type" : type.rawValue  , "endTime":endTime , "page":page]).responseJSON { (_, _, json, error) -> Void in
            if(error != nil){
                println(error?.description)
                complete(json: nil )
            }else {
                var json = JSON(json!)
                complete(json: json)
            }
        }
    }
    
    
}
