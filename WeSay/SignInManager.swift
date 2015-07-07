//
//  SignInManager.swift
//  WeSay
//
//  Created by QLX on 15/6/20.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class SignInManager: NSObject {
    class func checkForPhoneNumInput(text:String,submit:Bool=false)->(result:Bool,description:String){
        var result=true
        var despription="success"
        var separas=text.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: "0123456789"))
        var str=(separas as NSArray).componentsJoinedByString("")
        if(str != ""){
            result=false
            despription="含有非数字字符"
        }
        else if(text.counts()>11){
            result=false
            despription="号码超出11位"
        }
        
        else if(submit){
            if(text.counts() != 11){
                result=false
                despription="号码不等于11位"
            }
        }
        return (result,despription)
    }
    
    class func checkPwdInput(text:String,submit:Bool=false)->(result:Bool,description:String){
        var result=true
        var desprtion="success"
        if(text.counts()>16){
            result=false
            desprtion="密码超出16位"
        }
        return (result,desprtion)
    }
}
