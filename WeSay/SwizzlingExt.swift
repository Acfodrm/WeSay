//
//  SwizzlingExt.swift
//  WeSay
//
//  Created by QLX on 15/6/20.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class SwizzlingExt: NSObject {
    class func swizzlingInstanceMethod(clzz: AnyClass, oldSelector: Selector, newSelector: Selector) {
        let oldMethod = class_getInstanceMethod(clzz, oldSelector)
        let newMethod = class_getInstanceMethod(clzz, newSelector)
        method_exchangeImplementations(oldMethod, newMethod)
        
    }
    class func swizzlingClassMethod(clzz: AnyClass, oldSelector: Selector, newSelector: Selector) {
        let oldMethod = class_getClassMethod(clzz, oldSelector)
        let newMethod = class_getClassMethod(clzz, newSelector)
        method_exchangeImplementations(oldMethod, newMethod)
        
    }
    class func swizzingSomeMethod(){
        SwizzlingExt.swizzlingInstanceMethod(UIViewController.self, oldSelector: "viewDidLoad", newSelector: "viewDidLoadExt")
        SwizzlingExt.swizzlingInstanceMethod(UIView.self, oldSelector: "addSubview:", newSelector: "addSubviewExt:")
        SwizzlingExt.swizzlingInstanceMethod(UIScrollView.self, oldSelector: "touchesShouldCancelInContentView:", newSelector: "touchesShouldCancelInContentViewExt:")
    }
}
