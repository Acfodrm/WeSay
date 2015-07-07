//
//  UITextViewExt.swift
//  WeSay
//
//  Created by QLX on 15/6/27.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

extension UITextView {
    var placeholder:String {
        set{
             var label = UILabel()
             label.text = newValue
             label.numberOfLines = 0
            println(self.font)
             label.font = self.font
             label.backgroundColor = UIColor.clearColor()
             label.textColor = UIColor(red: 199/255, green: 199/255, blue: 206/255, alpha: 1.0)
             var frame = self.frame
             var size = label.sizeThatFits(CGSizeMake(frame.width, 99999))
             label.frame = CGRectMake(4, 8, size.width, size.height)
            if(frame.height < size.height + 8){
                frame.size.height = size.height + 8
                self.frame = frame
            }
             label.tag = -1
             self.addSubview(label)
        }
        get{
            if let  label = self.viewWithTag(-1){
                 return (label as! UILabel ).text!
            }else {
                 return "没有placehoder"
            }

        }
    }
    func hidenPlaceholder(){
        if let  label = self.viewWithTag(-1){
            label.hidden = true
        }else {
            println("没有placehoder")
        }
    }
    func showPlaceholder(){
        if let  label = self.viewWithTag(-1){
            label.hidden = false
            var frame = self.frame
            frame.size.height = label.frame.height + 8
            self.frame = frame
        }else {
            println("没有placehoder")
        }
    }
        
    
}
