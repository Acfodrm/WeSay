//
//  StringExt.swift
//  WeSay
//
//  Created by QLX on 15/6/21.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

extension String{
    func counts()->Int{
        return count(self)
    }
    func substringToIndex(to: Int) -> String{
        return (self as NSString).substringToIndex(to)
    }
    func sizeThatFits(width:CGFloat,fontSize:CGFloat)-> CGSize{
        var font = UIFont.systemFontOfSize(fontSize)
        return self.sizeThatFits(width, font: font)
    }
    func sizeThatFits(width:CGFloat,font:UIFont)-> CGSize{
        var label = UILabel()
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.frame = CGRectMake(0, 0, width, width)
        label.text = self
        label.sizeToFit()
        return label.frame.size
        
    }
    func sizeThatFitsForTextView(width:CGFloat,font:UIFont)->CGSize{
       var tv = UITextView()
        tv.font = font
        tv.text = self
        return tv.sizeThatFits(CGSizeMake(width, 9999))
    }
    func getFileType() -> String{
        var seps = self.componentsSeparatedByString(".")
        return seps.last!
    }
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat
        
    {
        var font = UIFont.systemFontOfSize(fontSize)
        var size = CGSizeMake(width,9999)
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        var  attributes = [NSFontAttributeName:font,
            NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        var text = self as NSString
        var rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size.height
    }

   
}
