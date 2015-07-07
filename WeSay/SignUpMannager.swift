//
//  SignUpMannager.swift
//  WeSay
//
//  Created by QLX on 15/6/21.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class SignUpMannager: NSObject {
    class func checkForPhoneNumInput(text:String,submit:Bool=false)->(result:Bool,description:String){
        return SignInManager.checkForPhoneNumInput(text, submit: submit)
    }
    class func checkForVerifityCodeInput(text:String,submit:Bool=false)->(result:Bool,description:String){
        var result=true
        var desp="success"
        var sepras=text.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789"))
        var joinStr=(sepras as NSArray).componentsJoinedByString("")
        if(joinStr != ""){
            result=false
            desp="含有非数字字符"
        }else if(text.counts()>6){
            result=false
            desp="验证码超出6位"
        }
        return (result,desp)
    }
    class func checkForPwdInput(text:String, submit:Bool=false)->(result:Bool,description:String){
        var result=true
        var desp="success"
        if(submit && text.counts()<6){
            result=false
            desp="密码小于6位"
        }else if(text.counts()>16){
            result=false
            desp="密码大于16位"
        }
        return (result,desp)
    }
    
}
