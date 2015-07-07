//
//  SayViewController.swift
//  WeSay
//
//  Created by QLX on 15/7/2.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class SayViewController: UIViewController {

    var titleSeg : MySegmentControl!
    var contentPageView : MyPageView!
    var cell : ArticleCell!
    var titleView : TitleSwitch!
    var bigTitle : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //导航栏 投稿按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "投稿", style: UIBarButtonItemStyle.Plain, target: self, action: "onAddValue")
        //导航栏 审帖 按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "审贴",style: UIBarButtonItemStyle.Plain, target: self, action: "onCheckValue")
        //导航栏 标题
        self.navigationItem.setTitle("微说")
        // 初始化  "专享","视频","纯文","纯图","精华
        self.initSegment()
        // 分页 内容
        self.initPageView()
        // 初始化 导航栏标题
        self.initTitleView()
        
        
        println(NSDate().timeIntervalSince1970)
       
        // Do any additional setup after loading the view.
    }
    func onMove(sender : UIPanGestureRecognizer){
        println("move")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewDidDisappear(animated: Bool) {
        
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func viewWillDisappear(animated: Bool) {
        
    }
    /**
    初始化 分段控件   专享  视频 纯图 纯文 精华
    
    :returns: return value description
    */
    func initSegment(){
        var frame = self.view.frame
        var segFrame = CGRectMake(0, 0, frame.width, 40)
        var seg = MySegmentControl(items: ["专享","视频","纯文","纯图","精华"])
        seg.frame = segFrame
        seg.addTarget(self, action: "onSegSelect:", forControlEvents: UIControlEvents.ValueChanged)
        seg.selectedSegmentIndex = 0
        self.titleSeg = seg
      //  seg.hidden = true
        self.view.insertSubview(self.titleSeg, atIndex: 1)
        self.tabBarController?.tabBar.hidden = true
    }
    /**
    初始化 分页 空间
    
    :returns:
    */
   
    func initPageView(){
        var frame = self.view.bounds
        var pageview = MyPageView()
        pageview.clipsToBounds = false
        
        frame.size.height -= (64)
        frame.origin.y = 0
        pageview.frame = frame
        
        var vc0 = MainSayVC()
        vc0.scrollOffsetByCallback = self.updateSegFrame
        
        //vc0.view.backgroundColor = UIColor.brownColor()
        
        var vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.blueColor()
        var vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.redColor()
        var vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.cyanColor()
        var vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.grayColor()
        
        pageview.views = [vc0, vc1 ,vc2 ,vc3, vc4]
        
        pageview.scrollProgressCallback = { value in
            
            self.titleSeg.setSelectImageViewMoveBy(value)
            self.titleView.setOffsetWithRate(value)
        }
        pageview.pageValueChangeCallback = {
            index in
            self.titleSeg.selectedSegmentIndex = index
            self.titleView.selectIndex = index
        }
            
      
        self.contentPageView = pageview
      
        self.view.insertSubview(pageview, atIndex: 0)
        // 给pageview 添加手势
        
    }
    /**
    投稿 按钮 回调
    */
    func onAddValue(){
        var isLogin = LoginStatus.getInstance().isLogin()
        if(isLogin ==  true){
            
            var loginVC = UIViewController.createWithStoryBoard("Main", identifier: "Login")
            LoginStatus.getInstance().loginComplete = {
                user in
                var vc = UIViewController.createWithStoryBoard("Main", identifier: "Submit")
                self.presentViewController(vc, animated: true, completion: nil)
            }
            self.presentViewController(loginVC, animated: true, completion: nil)
        }else {
            var vc = UIViewController.createWithStoryBoard("Main", identifier: "Submit")
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    // 审贴  按钮 回调
    func onCheckValue(){
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("begin")
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        println("move")
    }
    // 拖拉 整个内容 回调
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // 分段标题 点击 选择 回调
    func onSegSelect(seg : UISegmentedControl){
        var segment = seg as! MySegmentControl
        segment.autoMoveToSelectIndex()
        self.contentPageView.curPage = seg.selectedSegmentIndex
        self.titleView.selectIndex = seg.selectedSegmentIndex
        //seg.setImage(UIImage(named: "segselect.png"), forSegmentAtIndex: index)
    }
    
    // 动态更新 分段标题
    func updateSegFrame(offset:CGPoint , draging :Bool){
        
        var frame = self.titleSeg.frame
        if(draging == false){
            if(frame.origin.y + frame.height > 0){
                frame.origin.y = 0
            }
            UIView.beginAnimations("updateSeg", context: nil)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
            self.titleSeg.frame = frame
            UIView.commitAnimations()
        }
        else {
            frame.origin.x -= offset.x
            frame.origin.y -= offset.y
            if(frame.origin.y > 0){
                frame.origin.y = 0
            }else if (frame.origin.y < -40 ){
                frame.origin.y = -40
            }
            

            self.titleSeg.frame = frame
        }
        self.updateTitleView(offset, draging : draging)
    }
    
    // 动态更新 导航栏的 标题
    func updateTitleView( offset:CGPoint , draging :Bool ){
        var frame = self.titleView.frame
        if(draging == false){
            var scale = CGFloat(0)
            var y = self.titleSeg.frame.origin.y
            if( y == 0 ){
                frame.origin.y = 70
                scale = 1
            }else {
                frame.origin.y = 0
                scale = 0
            }
            UIView.beginAnimations("updateTitleView", context: nil)
            UIView.setAnimationDuration(0.3)
            self.titleView.frame = frame
            self.bigTitle.transform = CGAffineTransformMakeScale(scale, scale)
            self.bigTitle.alpha = scale
            UIView.commitAnimations()
            
        }else{
            frame.origin.y -= offset.y
            if(frame.origin.y < 0 ){
                frame.origin.y = 0
            }else if(frame.origin.y > 70){
                frame.origin.y = 70
            }
            var scale = 1 - (70 - frame.origin.y) / 100
            scale = log10(CGFloat(10) * scale)
          
            if(scale < 0.5){
                scale = 0
            }
            self.bigTitle.transform = CGAffineTransformMakeScale(scale, scale)
            self.bigTitle.alpha = scale
            self.titleView.frame = frame
        }
      
        
    }
    // 初始化 标题
    func initTitleView(){
        var frame = CGRectMake(0, 0, self.view.frame.width / 2, 44)
        
        // 提示标题
        self.titleView = TitleSwitch(titles: ["专享","视频","纯文","纯图","精华"])
        self.titleView.frame = CGRectMake(0, 70, self.view.frame.width / 2, 44)
        //标题背景View
        var titleBg = UIView(frame: frame)
        titleBg.clipsToBounds = true
        titleBg.addSubview(self.titleView)
        
        // 主标题
        self.bigTitle = UILabel(frame: frame)
        self.bigTitle.text = "微说"
        self.bigTitle.textAlignment = NSTextAlignment.Center
        self.bigTitle.textColor = UIColor.whiteColor()
        self.bigTitle.font = UIFont.systemFontOfSize(19)
        titleBg.addSubview(bigTitle)
        self.navigationItem.titleView = titleBg
    }
    

}
