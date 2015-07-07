//
//  UIImageExt.swift
//  WeSay
//
//  Created by QLX on 15/6/15.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

extension UIImage {
    class func imageWithImage(image:UIImage , scaledToSize newSize : CGSize)->UIImage{
         // Create a graphics image context
        UIGraphicsBeginImageContext(newSize)
        // Tell the old image to draw in this new context, with the desired
        // new size
        image .drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
         // Get the new image from the context
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        //End the context
        UIGraphicsEndImageContext()
        
        return newImage
    }
    func updataSizeFitwidth(width:CGFloat)->UIImage{
        var size = self.size
        if(size.width <= width){
            return self
        }
        var rato = size.width / size.height
        var height = width / rato
        return  UIImage.imageWithImage(self, scaledToSize: CGSizeMake(width, height))
    }
    class func ratate(image:UIImage, orientation:UIImageOrientation) -> UIImage{
       return  UIImage(CGImage: image.CGImage , scale: 1.0, orientation: orientation)!
    }
    //根据方向旋转
    func ratateByOrientition(orientation:UIImageOrientation) -> UIImage{
        return UIImage.ratate(self, orientation:orientation)
    }
    //顺时针 或者 逆时针 旋转
    func ratateToNextOrientation(clockwisse : Bool) -> UIImage{
        switch self.imageOrientation {
        case UIImageOrientation.Up:
            var  nextOrientation = clockwisse ? UIImageOrientation.Right : UIImageOrientation.Left
            return self.ratateByOrientition(nextOrientation)
        case UIImageOrientation.Down:
            var  nextOrientation = clockwisse ? UIImageOrientation.Left : UIImageOrientation.Right
            return self.ratateByOrientition(nextOrientation)
        case UIImageOrientation.Left:
            var  nextOrientation = clockwisse ? UIImageOrientation.Up : UIImageOrientation.Down
            return self.ratateByOrientition(nextOrientation)
        case UIImageOrientation.Right:
            var  nextOrientation = clockwisse ? UIImageOrientation.Down : UIImageOrientation.Up
            return self.ratateByOrientition(nextOrientation)
        default :
            break
        }
        return self
    }
    //获取图片类型
    class func typeForImageData(data:NSData) -> String{
        var c:__uint8_t = 0
        
        data.getBytes(&c, length: 1)
        
        switch(c){
         case 0xFF:
            return "jpg"
         case 0x89:
            return "png"
         case 0x47:
            return "gif"
        case 0x49:
            return "tiff"
        case 0x4D:
            return "tiff"
        default:
            break;
        }
        return ""
        
    }
    //获取图片 转成 jpeg 后的  nsdata
    func getJPEGData()-> NSData{
        var data = UIImageJPEGRepresentation(self, 1.0)
        return data
    }
    
}
