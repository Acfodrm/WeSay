//
//  MySegmentControl.swift
//  WeSay
//
//  Created by QLX on 15/7/4.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class MySegmentControl: UISegmentedControl {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var firstLoad = true
    var selectImaegView : UIImageView?
    var bgColor : UIColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)

    var textColor : UIColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)
    
    override init(items: [AnyObject]) {
        super.init(items: items)
        self.bgColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        
        self.textColor = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0)

    }
    override init(frame:CGRect){
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(self.firstLoad == false ){
            return
        }
        self.firstLoad = false
        self.setBackgroundImage(UIImage(), forState: UIControlState.allZeros, barMetrics: UIBarMetrics.Default)
        self.setDividerImage(UIImage(), forLeftSegmentState: UIControlState.allZeros, rightSegmentState: UIControlState.allZeros, barMetrics: UIBarMetrics.Default)
        self.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.blackColor()], forState: UIControlState.Selected)
        self.backgroundColor = self.bgColor
        self.tintColor = self.textColor
        
        if(self.selectImaegView == nil){
            self.selectImaegView = UIImageView()
            
             self.selectImaegView?.image = UIImage(named: "segselect.png")
            
           // var segWidth
        }
        var segWidth   = self.frame.width / CGFloat(self.numberOfSegments)
        var x = CGFloat(self.selectedSegmentIndex) * segWidth
        self.selectImaegView?.frame  = CGRectMake(x, 0, segWidth, self.frame.height)
        self.addSubview(self.selectImaegView!)
    }
    
    func autoMoveToSelectIndex(){
        var frame = self.selectImaegView?.frame
        frame?.origin.x = CGFloat(self.selectedSegmentIndex) * frame!.width
        
        UIView.beginAnimations("move", context: nil)
        UIView.setAnimationDuration(0.3)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseInOut)
        self.selectImaegView!.frame = frame!
        UIView.commitAnimations()
    }
    
    func setSelectImageViewMoveBy(rate : CGFloat){
        if(self.selectImaegView == nil){
            return 
        }
        var frame = self.selectImaegView!.frame
        
        var offsetx = rate * frame.width
        frame.origin.x = CGFloat(self.selectedSegmentIndex) * frame.width + offsetx
        
        self.selectImaegView!.frame = frame
        
    }
    
    

}
