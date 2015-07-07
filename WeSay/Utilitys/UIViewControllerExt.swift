//
//  UIViewControllerExt.swift
//  WeSay
//
//  Created by QLX on 15/6/18.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

extension UIViewController:UIGestureRecognizerDelegate{
    func viewDidLoadExt(){
        self.viewDidLoadExt()
        StyleSet.setStyleByViewController(self)
    }
    /**
    自动收起键盘
    */
    func autoStopKeyboard(){
        var tapGR=UITapGestureRecognizer(target: self, action: "onTapInView")
        tapGR.delegate=self
        self.view.addGestureRecognizer(tapGR)
    }
    //是否接受触摸
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view==self.view
    }
    //单击空白的地方回调
    func onTapInView(){
       self.view.endEditing(true)
    }
    
    class func createWithStoryBoard(name : String ,identifier: String) -> UIViewController{
        var sb = UIStoryboard(name: name, bundle: nil)
         return  sb.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
    }
}
