//
//  UIImagViewExt.swift
//  test3
//
//  Created by qlx on 15/6/9.
//  Copyright (c) 2015年 邱良雄. All rights reserved.
//

import UIKit


extension UIImageView{
    func setImageWithUrlString(urlString :String){
        Alamofire.request(.GET, URLString: urlString).response { (_, _, data, error) -> Void in
            if(error != nil){
                println("setImageWithUrlString error")
            }else{
                var image=UIImage(data: data as! NSData)
                self.image=image
            }
        }
    }
    convenience init(name:String , frame :CGRect){
        self.init(frame: frame)
        self.image=UIImage(named: name)
    }
    convenience init(name:String){
        self.init()
        self.image=UIImage(named: name)
        var size = self.image!.size
        self.frame = CGRectMake(0, 0, size.width, size.height)
    }
    convenience init(name:String ,contentMode:UIViewContentMode){
        self.init(name: name)
        self.contentMode=contentMode
    }
    func aspectFillForAdjustHeight(){
        if var imageSize = self.image?.size{
           var frameSize = self.frame.size
           var rato = imageSize.width / imageSize.height
           frameSize = CGSizeMake(frameSize.width, frameSize.width / rato )
           var frame = self.frame
           frame.size = frameSize
           self.frame = frame
           self.contentMode = UIViewContentMode.ScaleAspectFit
        }
    }
    //获取图片在在self 下的 frame
    func getImageFrame() -> CGRect{
        var imageSize = self.image!.size
        var wfactor = imageSize.width / self.frame.width
        var hfactor = imageSize.height / self.frame.height
        var factor = fmax(wfactor, hfactor)
        var width = imageSize.width / factor
        var height = imageSize.height / factor
        var x = (self.frame.width - width ) / 2
        var y = (self.frame.height - height ) / 2
        return CGRectMake(x , y , width , height)
    }
    // 返回  图片应有的高度
    func getHeightWithWidth(wdith : CGFloat) -> CGFloat{
        var size = self.image!.size
        var rate = size.width / size.height
        return wdith / rate
    }
}
