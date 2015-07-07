//
//  Toast.swift
//  WeSay
//
//  Created by QLX on 15/6/21.
// //

import UIKit
@objc
enum ShowType:Int{
    case Top
    case Bottom
    case Center
}
/// 显示信息在当前的vie的顶部 或者底部

class MyToast: UIView {
    static let instance=MyToast()
    var textLabel:UILabel!
    
    init(){
        super.init(frame: CGRectZero)
        self.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        textLabel=UILabel()
        textLabel.textAlignment=NSTextAlignment.Center
        textLabel.textColor=UIColor.whiteColor()
        self.layer.cornerRadius=12
        self.layer.masksToBounds=true
        self.addSubview(textLabel)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //单例
    class func getInstance()->MyToast{
        return instance
    }
    
    func test(a:Int , b: Int , c:Int){
        
    }
    //显示信息
    func toastWithText(text:String,showInview view:UIView,type:ShowType=ShowType.Bottom){
        self.dismissInView(view)
        self.textLabel.text=text
        
        var size=view.frame.size
        self.textLabel.numberOfLines=0
        var textSize=textLabel.sizeThatFits(CGSizeMake(size.width-50, 9999))
        self.textLabel.frame=CGRectMake(0, 0, textSize.width, textSize.height)
        self.frame=CGRectMake(0, 0, textSize.width+32, textSize.height+20)
        self.textLabel.center=CGPointMake(self.frame.width/2, self.frame.height/2)
        
        if(type == ShowType.Bottom){
            self.center = CGPointMake(size.width/2, size.height - (self.frame.height/2+20))
        }else if(type == ShowType.Top){
            self.center = CGPointMake(size.width/2, (self.frame.height/2+20))
        }else if(type == ShowType.Center){
            self.center = CGPointMake( size.width / 2, size.height / 2)
        }
        //动画
        self.removeFromSuperview()
        self.layer.removeAllAnimations()
        self.animationWithKeyFrameForLinear(0.2, values: [0,1], keyPath: KeyPath.Scale, key: "come", additive: false)
        self.animationWithKeyFrame(0.2, values: [1,0], keyPath: KeyPath.Scale, key: "out", additive: false, timingFunc: kCAMediaTimingFunctionLinear, delay: 1, repeatCount: 0)
        view.addSubview(self)
    }
    func toastOfWaitingWithText(text:String , showInView view :UIView){
        
        var mask = UIView(frame: view.bounds)
        mask.tag = 10000
        mask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        mask.alpha = 0
        view.addSubview(mask)
        UIView.beginAnimations("toastOf", context: nil)
        UIView.setAnimationDuration(0.2)
        mask.alpha = 1
        UIView.commitAnimations()
        SVProgressHUD.showWithStatus(text)
    }
    func dismissInView(view : UIView){
        view.viewWithTag(10000)?.removeFromSuperview()
        SVProgressHUD.dismiss()
    }
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        if(anim.valueForKey("out") != nil){
            if(flag){
                self.removeFromSuperview()
                self.layer.removeAllAnimations()
            }
        }
    }
}
