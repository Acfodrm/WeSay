//
//  KeyboardUtil.swift
//  WeSay
//
//  Created by QLX on 15/6/26.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class KeyboardUtil: NSObject {
   static let instance = KeyboardUtil()
    var lastHeight:CGFloat = 0
    class func getIntance()->KeyboardUtil{
        return instance
    }
    
    var keyboardWillShowCallback :((height:CGFloat ,duration: NSTimeInterval ,curve :Int)->Void)?
    var keyboardWillHidenCallback :((height:CGFloat,duration: NSTimeInterval , curve: Int)->Void)?
    //回调
    func listenKeyboardWillShow(callback : (height:CGFloat ,duration: NSTimeInterval ,curve:Int)->Void){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        self.keyboardWillShowCallback = callback
    }
    func listenKeyboardWillHiden(callback : (height:CGFloat,duration:NSTimeInterval ,curve:Int)->Void){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHiden:", name: UIKeyboardWillHideNotification, object: nil)
        self.keyboardWillHidenCallback = callback
    }
    //唤起输入法时候  这个回被多次调用  最多可达到3次 注意
    func keyboardWillShow(notification : NSNotification){
     
        var info = (notification.userInfo)!
        var value = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
        var height = value.CGRectValue().size.height
        
        var duration = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        var curve  = info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        var addHeight = (height - self.lastHeight)
        if(addHeight == 0){
            return
        }
        self.keyboardWillShowCallback?(height:addHeight, duration:duration.doubleValue , curve:curve.integerValue)
        self.lastHeight = height
    }
    func keyboardWillHiden(notification : NSNotification){
      
        self.lastHeight = 0
        var info = (notification.userInfo)!
        var value = info[UIKeyboardFrameEndUserInfoKey] as! NSValue
        var height = value.CGRectValue().size.height
        
        var duration = info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        var curve  = info[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber
        
        self.keyboardWillHidenCallback?(height:height, duration:duration.doubleValue , curve:curve.integerValue)
  
    }
    func removeObserver() {
        self.lastHeight = 0
        self.keyboardWillShowCallback = nil
        self.keyboardWillHidenCallback = nil
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
