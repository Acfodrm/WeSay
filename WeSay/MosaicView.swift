//
//  MosaicView.swift
//  WeSay
//
//  Created by QLX on 15/6/28.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class MosaicView: UIView {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var zoomBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    var limitRect :CGRect = CGRectZero
    var firstEnter = true
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!self.firstEnter){
            return
        }
        self.firstEnter = false
        //给 缩放按钮 添加拖拉手势
        var pan = UIPanGestureRecognizer(target: self, action: "onZoom:")
        self.zoomBtn.addGestureRecognizer(pan)
        
        pan = UIPanGestureRecognizer(target: self, action: "onMove:")
        self.addGestureRecognizer(pan)
    }
    /**
    拖拉缩放按妞回调
    */
    func onZoom(sender: UIPanGestureRecognizer) {
        var transition = sender.translationInView(self.superview!)
        
        if(transition.x * transition.y < 0 ){
            return
        }
        var center = self.center
        var frame = self.frame
        var width = transition.x + transition.y + frame.width
        
        if !(width > 150 || width < 70){
            self.frame = CGRectMake(0, 0, width, width)
            self.center = center
            if(!self.limitRect.contains(self.frame)){
                self.frame = frame
            }
        }
        sender.setTranslation(CGPointZero, inView: self.superview!)
    }
    /**
    移动马赛克
    */
    func onMove(sender: UIPanGestureRecognizer) {
        var offset = sender.translationInView(self.superview!)
        var center = self.center
        self.center = CGPointMake(self.center.x + offset.x, self.center.y + offset.y)
        
        if !self.limitRect.contains(self.frame){
            self.center = center
        }
        
        sender.setTranslation(CGPointZero, inView: self.superview!)
    }
    @IBAction func onCancel(sender: AnyObject) {
        self.removeFromSuperview()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
