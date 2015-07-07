//
//  UILabelExt.swift
//  WeSay
//
//  Created by QLX on 15/7/3.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

extension UILabel {
    func setTextForAutoFit(text:String , maxWidth : CGFloat){
        var size = text.sizeThatFits(maxWidth, font: self.font)
        self.text = text
        var frame = self.frame
        frame.size.height = size.height
        self.frame = frame
    }
    
    
}
