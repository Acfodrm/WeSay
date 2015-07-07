//
//  TitleSwitch.swift
//  WeSay
//
//  Created by QLX on 15/7/5.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class TitleSwitch: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var titles:[AnyObject]
    var firstLoad = true
    var dots : UIPageControl!
    var _selectIndex : Int = 0
    init(titles : [AnyObject]){
        self.titles = titles
        super.init(frame: CGRectZero)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(){
       // self.clipsToBounds = true
        var i = 0
        for title in titles{
            var subFrame = CGRectMake(CGFloat(i) * frame.width, 0, frame.width, frame.height)
            if let sub = title as? String {
                var titleLabel = UILabel(frame: subFrame)
                titleLabel.font = UIFont.systemFontOfSize(17)
                titleLabel.text = sub
                titleLabel.textAlignment = NSTextAlignment.Center
                titleLabel.textColor = UIColor.whiteColor()
                titleLabel.alpha = i == 0 ? 1: 0
                
                self.addSubview(titleLabel)
            }else if let sub = title as? UIView{
                sub.frame = subFrame
                self.addSubview(sub)
            }
            i++
        }

    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        if(self.firstLoad == false){
            return
        }
        self.firstLoad = false
        // 初始化 标题 对应相应的view
        setUpView()
        // 点 提示
        var frame = self.frame
        var dotsFrame = CGRectMake(0, 0, frame.width/3, 2)
        
        var dots = UIPageControl(frame: dotsFrame)
        dots.center = CGPointMake(frame.width/2, frame.height*0.85)
        dots.numberOfPages = self.titles.count
        self.dots = dots
        dots.transform = CGAffineTransformScale(dots.transform, 0.5, 0.5)
        self.addSubview(dots)

    }
    
    func setOffset(offset : CGPoint){
        var i = 0
        for sub in self.subviews {
             var title = sub as! UIView
            if(title is UIPageControl){
                continue
            }
             var frame = title.frame
             frame.origin.x = CGFloat(i - selectIndex) * self.frame.width + offset.x
            title.frame = frame
           var dfdframe = self.frame
            var alpha = 1 - fabs(title.frame.origin.x - 0) / self.frame.width
            alpha = alpha < 0 || alpha > 1 ? 0 : alpha
            title.alpha = alpha
            i++
        }
    }
    
    func setOffsetWithRate(rate : CGFloat){
       var offset = CGPointMake(-rate * self.frame.width, 0)
       self.setOffset(offset)
    }
    
    var selectIndex : Int {
        set {
            self._selectIndex = newValue
            self.dots.currentPage = newValue
            self.setOffsetWithRate(0)
        }get{
            return self._selectIndex
        }
    }
    
    
    

}
