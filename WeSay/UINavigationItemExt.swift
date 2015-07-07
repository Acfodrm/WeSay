//
//  UINavigationItemExt.swift
//  WeSay
//
//  Created by QLX on 15/6/20.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

extension UINavigationItem{
    func setTitle(title:String,color:UIColor=UIColor.whiteColor(),fontSize:CGFloat=18){
        var titleLabel=UILabel()
        titleLabel.text=title
        titleLabel.textColor=color
        titleLabel.sizeToFit()
        titleLabel.textAlignment=NSTextAlignment.Center
        titleLabel.font=UIFont.systemFontOfSize(fontSize)
        self.titleView=titleLabel
    }
}

