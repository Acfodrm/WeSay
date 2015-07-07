//
//  LoginStatus.swift
//  WeSay
//
//  Created by QLX on 15/7/2.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class LoginStatus: NSObject {
    var bLogin = false
    var _user : UserModel?
    var loginComplete : ((user : UserModel ) -> Void )?
    var  user:UserModel?{
        set {
            self._user = newValue
            self.bLogin =  (self._user != nil)
            if(self.bLogin){
                self.loginComplete?(user:self._user!)
            }
        }get {
            return self._user
        }
    }
    static var instance: LoginStatus?
    
    class func getInstance() -> LoginStatus {
        if(instance == nil){
            instance = LoginStatus()
        }
        return instance!
    }
    //是否登录
    func isLogin() -> Bool{
        return self.bLogin
    }
    func exitLogin(){
        self.bLogin = false
        self.user = nil
    }

}
