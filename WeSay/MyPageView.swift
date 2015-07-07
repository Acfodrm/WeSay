//
//  MyPageView.swift
//  UIDemoSwfit
//
//  Created by 邱良雄 on 15/6/6.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class MyPageView: UIScrollView ,UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var bUpdate=true
    var clipSuviews = true
    var scrollProgressCallback:((progressValue:CGFloat)->Void)?
    var pageValueChangeCallback:((pageIndex : Int) -> Void)?
    var views=[AnyObject](){
        didSet{
           bUpdate=true
        }
    }
    var dotsHiden:Bool=true{
        didSet{
            bUpdate=true
            if(dotsHiden){
                pageControl.hidden=true
            }else {
                pageControl.hidden=false
            }
        }
    }
    
    var pageControl=UIPageControl()
    var curPage=0{
        didSet{
            self.contentOffset=CGPointMake(CGFloat(curPage)*frame.width,self.contentOffset.y)
            pageControl.currentPage=curPage
        }
    }
    
    override init(frame :CGRect){
        super.init(frame: frame)
        setInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func  setInit(){
        self.backgroundColor=UIColor.clearColor()
        self.showsVerticalScrollIndicator=false
        self.showsHorizontalScrollIndicator=false
        self.bounces=false
        self.delaysContentTouches = false
        self.pagingEnabled=true
        self.delegate=self
        self.clipsToBounds = false
        self.dotsHiden = true
     // self.canCancelContentTouches = true
     
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX=scrollView.contentOffset.x
        var orginX = CGFloat(curPage)*self.frame.width
        if self.frame.width != CGFloat(0){
           var percentage=(offsetX - orginX) / self.frame.width
          //  println("\(percentage)")
            scrollProgressCallback?(progressValue: percentage)
        }
        else {
            println("scrollViewDidScroll  self.frame.width == 0 error")
        }
        
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
         var offsetX=scrollView.contentOffset.x
         curPage=Int((offsetX/self.frame.width + CGFloat(0.5)))
         pageControl.currentPage=curPage
         self.pageValueChangeCallback?(pageIndex: curPage)
    }
    
    func  setPageByIndex(indexPage:Int){
        curPage=indexPage
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        onEnter()
    }

    func onEnter(){
        
        if(bUpdate){
            bUpdate=false
            setContentViews()
            setPageControl()
        }
    }
    
    func setContentViews(){
        
        self.contentSize=CGSizeMake(CGFloat(views.count)*self.frame.width, 0)
        var i=0
        for view in views{
            var frame=CGRectMake(self.frame.width*CGFloat(i) ,0, self.frame.width, self.frame.height)
            if view is UIView{
                var v=view as! UIView
                v.clipsToBounds=true
                v.frame=frame
                v.clipsToBounds = self.clipSuviews
                self.addSubview(v)
                let rect=v.frame
                
            }else if view is UIViewController{
                (view as! UIViewController).navigationController?.navigationBar.hidden=true
                var v=(view as! UIViewController).view
                v.frame=frame
                
                v.clipsToBounds = self.clipSuviews
                self.addSubview(v)
                
            }else{
                println("***didSet Views  error")
                i--
            }
            i++
        }
    }
    func setPageControl(){
        pageControl.numberOfPages=views.count
        pageControl.currentPage=curPage
        pageControl.frame=CGRectMake(frame.origin.x, (frame.origin.y+frame.height)*0.95,frame.width , 5)
        superview?.addSubview(pageControl)
    }
   
    override func touchesShouldCancelInContentView(view: UIView!) -> Bool {
        if(view is UIButton){
           // return false
        }
       // return false
        return true
    }
   

}
