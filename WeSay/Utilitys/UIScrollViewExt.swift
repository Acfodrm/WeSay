//
//  UIScrollViewExt.swift
//  WeSay
//
//  Created by QLX on 15/6/18.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

extension UIScrollView  {
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.delaysContentTouches=false // 延迟取消
    }
    // 用swizing 强行 替代 touchesShouldCancelInContentView 取消 选中 的view 以便滚动
    func touchesShouldCancelInContentViewExt(view: UIView!) -> Bool{
        return true
    }
}


