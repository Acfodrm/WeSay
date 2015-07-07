//
//  SubmissionVC.swift
//  WeSay
//
//  Created by QLX on 15/6/26.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class SubmissionVC: UIViewController ,UITextViewDelegate , UIScrollViewDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UIVideoEditorControllerDelegate , UIAlertViewDelegate{
    
    var toolBarView:ToolBarView!               //工具栏
    var showNameSegment:UISegmentedControl! //匿名和署名 的 segment
    
    var imageContent:UIImageView?        // 说说的图片
    var textContent: UITextView!          // 文字内容
    var bgScrollView:UIScrollView!        //背景 滚动 作为父亲容器
    var keyboardHiden = true              //键盘是否隐藏
    var deleteBtn:UIButton!
    var videoView :VideoView?              // 视频
    var selectType : String = "照片"
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame = self.view.frame
        
        //添加 取消  和  投稿  按钮
        var leftItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancel")
        self.navigationItem.leftBarButtonItem = leftItem
        var rightItem = UIBarButtonItem(title: "投稿", style: UIBarButtonItemStyle.Plain, target: self, action: "onSubmit")
        self.navigationItem.rightBarButtonItem = rightItem
        
        
        //图片
        
        
        // 是否匿名
        self.showNameSegment = UISegmentedControl(frame: CGRectMake(0, 0, frame.width*0.35, 27))
        self.showNameSegment.insertSegmentWithTitle("署名", atIndex: 0, animated: false)
        self.showNameSegment.insertSegmentWithTitle("匿名", atIndex: 1, animated: false)
        self.showNameSegment.selectedSegmentIndex = 0
        self.navigationItem.titleView = self.showNameSegment
        
        
        //scroll view
        
        self.bgScrollView = UIScrollView(frame: CGRectMake(0, 0, frame.width, frame.height - 64 - 45))
        self.bgScrollView.contentSize = CGSizeMake(frame.width, frame.height - 64 - 44)
        self.bgScrollView.decelerationRate = 0.8
        self.bgScrollView.delegate = self
        self.bgScrollView.contentSize = CGSizeMake(frame.width, self.bgScrollView.frame.height + 1)
        self.view.addSubview(self.bgScrollView)
        
        
        //文字 文本框
        self.initTextContent()
        
        //添加工具浪
        self.initToolBarView()
        
        //初始化 删除 按钮
        
        self.initDeleteBtn()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle=UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden = false
        KeyboardUtil.getIntance().listenKeyboardWillShow(self.keyboardWillShowCallback)
        KeyboardUtil.getIntance().listenKeyboardWillHiden(self.keyboardWillHidenCallback)
        //设置视频 播放
        self.videoView?.play()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        KeyboardUtil.getIntance().removeObserver()//取消监听
        
        //设置视频 暂停
        self.videoView?.pause()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        println("memrory not enough")
        // Dispose of any resources that can be recreated.
    }
    
    /**
    初始化工具栏  相册  相机 视频
    */
    func initToolBarView(){
        var frame = self.view.frame
        var array = NSBundle.mainBundle().loadNibNamed("ToolBarView", owner: nil, options: nil)
        self.toolBarView = array[0] as! ToolBarView
        self.toolBarView.frame = CGRectMake(0, frame.height - 45 - 64 , frame.width, 45)
        self.toolBarView.backgroundColor = UIColor.mainColor()
        self.view.addSubview(toolBarView)
        
        self.toolBarView.albumBtn.addTarget(self, action: "onAlbum", forControlEvents: UIControlEvents.TouchUpInside)
        self.toolBarView.cameraBtn.addTarget(self, action: "onCamara", forControlEvents: UIControlEvents.TouchUpInside)
        self.toolBarView.videoBtn.addTarget(self, action: "onVedio", forControlEvents: UIControlEvents.TouchUpInside)
        self.toolBarView.pickup.addTarget(self, action: "onPickup", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    /**
    初始化文本框
    */
    func initTextContent(){
        var frame = self.view.frame
        self.textContent = UITextView(frame: CGRectMake(8, 0, frame.width - 16, 20))
        self.textContent.font = UIFont.systemFontOfSize(17)
        // self.textContent.textColor = UIColor.grayColor()
        self.textContent.becomeFirstResponder()
        self.textContent.textColor = UIColor.textColor()
        self.textContent.delegate = self
        self.textContent.placeholder = submissoinPlaceHolder
        self.textContent.bounces = false
        self.textContent.scrollEnabled = false
        self.bgScrollView.addSubview(self.textContent)
    }
    /**
    初始化 删除 按钮
    */
    func initDeleteBtn(){
        self.deleteBtn = UIButton(frame: CGRectMake(0, 0, 25, 25))
        self.deleteBtn.setImage(UIImage(named: "icon_cancel"), forState: UIControlState.Normal)
        self.deleteBtn.addTarget(self, action: "onDelete", forControlEvents: UIControlEvents.TouchUpInside)
        self.deleteBtn.hidden = true
        self.bgScrollView.insertSubview(self.deleteBtn, atIndex: 100)
    }
    /**
    设置图片内容
    */
    func setUpimageContent(image:UIImage) {
        self.delete()
        self.imageContent?.removeFromSuperview()
        self.imageContent = UIImageView()
        self.imageContent?.image = image
        var frame = self.view.frame
        self.imageContent?.frame = CGRectMake(16, 15, frame.width - 32 , 0)
        self.imageContent?.aspectFillForAdjustHeight()
        self.imageContent?.clipsToBounds = false
        self.imageContent?.userInteractionEnabled = true
        self.bgScrollView.insertSubview(self.imageContent!, atIndex: 0)
        self.unpdateContenSize()
    }
    /**
    设置视频内容
    :param: fileUrl 资源路径
    */
    func setUpVideoContent(fileUrl:NSURL){
        self.delete()
        
        //        var library = ALAssetsLibrary()
        //        library.writeVideoAtPathToSavedPhotosAlbum(fileUrl, completionBlock: { (_, error) -> Void in
        //            if(error != nil){
        //                println(error)
        //            }else {
        //                println("save video success")
        //            }
        //        })
        
        self.videoView = VideoView(contentURL: fileUrl)
        self.videoView?.frame = CGRectMake(16, 0, self.view.frame.width - 32, 0)
        self.videoView?.autoRepeat = true
        self.videoView?.shouldAutoplay = true
        self.videoView!.frameUpdateCallback = {
            (_) in
            println("回调")
            self.unpdateContenSize()
        }
        self.bgScrollView.insertSubview(self.videoView!, atIndex: 0)
        self.unpdateContenSize()
    }
    //删除图片 或 视频
    func onDelete(){
        var content = self.imageContent == nil ? "视频" : "图片"
        var alert = UIAlertView(title: "确定删除\(content)?", message: "", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定")
        alert.delegate = self
        alert.show()
    }
    /**
    删除图片或者视频时候 ，提醒框回调
    */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex == 1){
            self.delete()
        }
    }
    /**
    删除图片或者视频
    */
    func delete(){
        self.deleteBtn.hidden = true
        self.imageContent?.removeFromSuperview()
        self.imageContent = nil
        self.videoView?.removeFromSuperview()
        self.videoView = nil
        unpdateContenSize()
    }
    /**
    更新图片的位置
    */
    func updateImageContentFrame(){
        if let iv = self.imageContent{
            var tvFrame = self.textContent.frame
            var ivFrame = iv.frame
            ivFrame.origin.y = tvFrame.height + 20
            if iv.frame.origin.y != ivFrame.origin.y {
                println("upateImageframe")
                self.deleteBtn.hidden = false
                UIView.beginAnimations("updatImage", context: nil)
                UIView.setAnimationDuration(0.3)
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
                iv.frame = ivFrame
                self.deleteBtn.center = CGPointMake(ivFrame.origin.x + ivFrame.width, ivFrame.origin.y)
                UIView.commitAnimations()
            }
            
        }
    }
    /**
    更新视频的位置
    */
    func updateVideoContentFrame(){
        if let vv = self.videoView{
            var tvFrame = self.textContent.frame
            var vvFrame = vv.frame
            vvFrame.origin.y = tvFrame.height + 20
            if vv.frame.origin.y != vvFrame.origin.y {
                self.deleteBtn.hidden = false
                println("updateVideo")
                UIView.beginAnimations("updatVideo", context: nil)
                UIView.setAnimationDuration(0.3)
                UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
                vv.frame = vvFrame
                self.deleteBtn.center = CGPointMake(vvFrame.origin.x + vvFrame.width, vvFrame.origin.y)
                UIView.commitAnimations()
            }
            
        }
    }
    /**
    更新滑动内容Size大小
    */
    func unpdateContenSize(){
        self.updateImageContentFrame()
        self.updateVideoContentFrame()
        var bgContentSize = self.bgScrollView.contentSize
        var textHeight:CGFloat = self.textContent.frame.height
        var imageHeight: CGFloat = 0
        var videoHeight: CGFloat = 0
        var spaceHeight: CGFloat = 0
        if let iv = self.imageContent {
            imageHeight = iv.frame.height
            spaceHeight = 20
        }else if let vv = self.videoView {
            videoHeight = vv.frame.height
            spaceHeight = 20
        }
        var totalHeight = textHeight + spaceHeight + imageHeight + videoHeight
        bgContentSize.height = totalHeight
        if(fabs(bgContentSize.height - self.bgScrollView.contentSize.height)>2){
            bgContentSize.height = fmax(bgContentSize.height,self.bgScrollView.frame.height + 1)
            
            UIView.beginAnimations("upadteContentSize", context: nil)
            UIView.setAnimationDuration(0.3)
            UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
            self.bgScrollView.contentSize = bgContentSize
            UIView.commitAnimations()
        }
        
        
        
        
    }
    /**
    相册回调
    */
    func onAlbum(){
        self.selectType = "照片"
        var  pickImage = UIImagePickerController()
        pickImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickImage.mediaTypes = ["public.image"]
        pickImage.delegate = self
        pickImage.allowsEditing = false
        pickImage.editing = false
        pickImage.videoQuality = UIImagePickerControllerQualityType.TypeHigh
        self.presentViewController(pickImage, animated: true, completion: nil)
    }
    /**
    相机回调
    */
    func onCamara(){
        var  pickImage = UIImagePickerController()
        pickImage.sourceType = UIImagePickerControllerSourceType.Camera
        pickImage.delegate = self
        self.presentViewController(pickImage, animated: true, completion: nil)
    }
    /**
    视频回调
    */
    func onVedio(){
        self.selectType = "视频"
        var  pickImage = UIImagePickerController()
        pickImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickImage.mediaTypes = ["public.movie"]
        pickImage.delegate = self
        pickImage.allowsEditing = false
        pickImage.editing = false
        pickImage.videoQuality = UIImagePickerControllerQualityType.TypeHigh
        self.presentViewController(pickImage, animated: true, completion: nil)
    }
    /**
    摄像 回调
    */
    func onPickup(){
        var ipc = UIImagePickerController()
        ipc.sourceType = UIImagePickerControllerSourceType.Camera
        
        //Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
        var availableMedia = UIImagePickerController.availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)
        ipc.mediaTypes = [ availableMedia![1] ]
        ipc.videoMaximumDuration = 15.0
        ipc.delegate = self
        ipc.videoQuality = UIImagePickerControllerQualityType.TypeHigh
        self.presentViewController(ipc, animated: true, completion: nil)
    }
    /**
    图片读取控制器 代理 回调
    */
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        //
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if var image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.dismissViewControllerAnimated(false, completion: nil)
            var sb = UIStoryboard(name: "Main", bundle: nil)
            var vc = sb.instantiateViewControllerWithIdentifier("ImageModify") as! ImageModifyVC
            vc.image = image
            vc.completed = { (image) in
                self.setUpimageContent(image)
            }
            self.presentViewController(vc, animated: true, completion: nil)
            
            
        }else {
            //
            var fileUrl = info[UIImagePickerControllerMediaURL] as! NSURL
            //  var path = NSBundle.mainBundle().pathForResource("video", ofType: "mp4")
            if UIVideoEditorController.canEditVideoAtPath(fileUrl.path!){
                var video = UIVideoEditorController()
                video.videoPath = fileUrl.path!
                video.videoQuality = UIImagePickerControllerQualityType.TypeMedium
                video.videoMaximumDuration = 15
                video.delegate = self
                
                UIView.beginAnimations("guodu", context: nil)
                UIView.setAnimationDuration(0.2)
                self.dismissViewControllerAnimated(false, completion: nil)
                self.presentViewController(video, animated: true, completion: nil)
                
                UIView.commitAnimations()
            }
        }
        
    }
    
    /**
    键盘弹出回调
    
    :param: 键盘高度
    :param: 弹出动画时间
    :param: 动画时间曲线
    */
    func keyboardWillShowCallback(height:CGFloat ,time: NSTimeInterval, curve:Int)->Void{
        
        println("show\(height)")
        self.keyboardHiden = false
        // self.toolBarView.layer.removeAllAnimations()
        //UIView.beginAnimations("show", context: nil)
        //UIView.setAnimationDuration(time)
        if let animationCurve = UIViewAnimationCurve(rawValue: curve){
            //  UIView.setAnimationCurve(animationCurve)
        }
        var frame = self.toolBarView.frame
        frame.origin.y -= (height)
        self.toolBarView.frame = frame
        self.adjustTextViewHeight()
        // UIView.commitAnimations()
        
        //        self.toolBarView.animationWithKeyFrameForEaseIn(CGFloat(time), values: [0,-height], keyPath: KeyPath.PositionY, key: "movetool", additive: true)
    }
    /**
    键盘消失回调
    
    :param: height 键盘高度
    :param: time   键盘消失动画时间
    :param: curve  动画曲线
    */
    func keyboardWillHidenCallback(height:CGFloat,time:NSTimeInterval, curve:Int)->Void{
        self.keyboardHiden = true
        println("hiden \(height)")
        // self.textViewAdustForKeyboardHiden()
        //   self.toolBarView.layer.removeAllAnimations()
        // UIView.beginAnimations("hiden", context: nil)
        //  UIView.setAnimationDuration(time)
        //  if let animationCurve = UIViewAnimationCurve(rawValue: curve){
        //   UIView.setAnimationCurve(animationCurve)
        //  }
        var frame = self.toolBarView.frame
        frame.origin.y += height
        
        self.toolBarView.frame = frame
        // UIView.commitAnimations()
    }
    
    //实现 TextView代理的接口
    /**
    内容变化时候回调
    
    :param: textView
    */
    func textViewDidChange(textView: UITextView) {
        if(textView.text == ""){
            textView.showPlaceholder()
            self.unpdateContenSize()
            return
        }else {
            textView.hidenPlaceholder()
        }
        var frame = textView.frame
        var size = textView.sizeThatFits(CGSizeMake(frame.width, 9999))
        frame.size.height = size.height
        textView.frame = frame
        self.unpdateContenSize()
    }
    /**
    过滤文字内容
    
    :param: textView
    :param: range
    :param: text
    
    :returns:
    */
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        var str = textView.text + text
        if(str.counts() > wordslimit){
            MyToast.getInstance().toastWithText("字数超出\(wordslimit)", showInview: self.view, type: ShowType.Top)
            return false
        }
        return true
    }
    /**
    文字输入框 光标变化时 回调
    
    :param: textView
    */
    func textViewDidChangeSelection(textView: UITextView) {
        self.adjustTextViewHeight()
    }
    
    /**
    调整 输入文本框的高度
    */
    func adjustTextViewHeight(duration:NSTimeInterval = 0.3) {
        var textView = self.textContent
        var index = textView.selectedRange.location
        var text = (textView.text as NSString).substringToIndex(index)
        
        var size = text.sizeThatFitsForTextView(textView.frame.width, font: textView.font)
        // println(size.height)
        var worldPoint = textView.convertPoint(CGPointMake(0 , size.height), toView: self.view)
        // println(worldPoint.y)
        var maxY = self.toolBarView.frame.origin.y
        var offsetY = maxY - worldPoint.y
        // println(offsetY)
        
        var offset = self.bgScrollView.contentOffset
        if(offset.y - offsetY < 0){
            return
        }
        //执行动画
        
        
        UIView.beginAnimations("offsetY", context: nil)
        UIView.setAnimationDuration(duration)
        UIView.setAnimationCurve(UIViewAnimationCurve.EaseIn)
        textViewDidChange(self.textContent)
        offset.y -= offsetY
        self.bgScrollView.contentOffset = offset
        UIView.commitAnimations()
    }
    /**
    ScrollView 开始拖拉回调
    
    :param: scrollView
    */
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.textViewAdustForKeyboardHiden()
    }
    /**
    键盘消失时候 文本框下移动
    */
    func textViewAdustForKeyboardHiden(){
        if(self.keyboardHiden){
            return
        }
        self.view.endEditing(true)
    }
    
    //编辑视频完成回调
    func videoEditorController(editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        var fileUrl = NSURL(fileURLWithPath: editedVideoPath)
        setUpVideoContent(fileUrl!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //选择图片或者视频  导航栏的回调
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.setTitle(self.selectType, color: UIColor.whiteColor(), fontSize: 17)
        
    }
    
    // 导航栏 取消按钮 回调
    func onCancel(){
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // 导航栏 投稿 回调
    func onSubmit(){
        var text = self.textContent.text
        var image = self.imageContent?.image
        var fileURL = self.videoView?.movievc.contentURL
        var path = NSBundle.mainBundle().pathForResource("video", ofType: "mp4")
        fileURL = NSURL(fileURLWithPath: path!)
        var uid = "50"
        var tid = self.getTypeID()
           HttpRequestManager.getInstance().submitValueWithText(text, image: image, videoFileURL: fileURL, uid: uid, tid: tid) { (error) -> Void in
            if(error == nil){
                SVProgressHUD.showSuccessWithStatus("投稿成功")
                self.onCancel()
            }else {
                MyToast.getInstance().toastWithText(error!, showInview: self.view, type: ShowType.Top)
            }
           }
        
    }
    func getTypeID() -> String{
        var tid = "0"
        if(self.imageContent != nil){
            tid = "1"
        }else if(self.videoView != nil) {
            tid = "2"
        }
        return tid
    }
}



