//
//  ImageModifyVC.swift
//  WeSay
//
//  Created by QLX on 15/6/28.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class ImageModifyVC: UIViewController {
    var  image : UIImage! //待处理图片
    var  imageView : UIImageView!
    var  waterMarkScrollView : UIScrollView!
    var  waterMarkIV:UIImageView!
    
    var  completed : ((image : UIImage) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        var frame = self.view.frame
        //隐藏状态栏
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    
        //测试图片源
      //  self.image = UIImage(named: "test.jpg")

        //初始化图片显示
        self.initImageView()
        //初始化水印
        self.initWaterMark()
        
        self.updateFrame()
        
    }
    /**
    初始化图片显示
    
    :returns:
    */
    func initImageView(){
      var frame = self.view.frame
      self.image = self.image.updataSizeFitwidth(520)
      self.imageView = UIImageView(image: self.image)
      self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
      self.imageView.userInteractionEnabled = true
      self.imageView.frame = CGRectMake(0, 45, frame.width, frame.height - 90)
      self.view.addSubview(self.imageView)
    }
    func initWaterMark(){
        var waterMarkIV = UIImageView(name: "water_mark.png")
        self.waterMarkIV = waterMarkIV
        self.waterMarkScrollView = UIScrollView()
        self.waterMarkScrollView.bounces = false
        self.waterMarkScrollView.decelerationRate = 0
        self.waterMarkScrollView.showsVerticalScrollIndicator = false
        self.waterMarkScrollView.showsHorizontalScrollIndicator = false
        self.waterMarkScrollView.contentSize = waterMarkIV.image!.size
        self.waterMarkScrollView.addSubview(waterMarkIV)
        self.view.addSubview(self.waterMarkScrollView)
    }
    /**
    更新 窗口的位置和大小
    */
    func updateFrame(){
        var frame = self.imageView.getImageFrame()
        frame = self.imageView.convertRect(frame, toView: self.view)
        self.waterMarkScrollView.frame = frame
        
        var size = self.waterMarkScrollView.contentSize
        self.waterMarkScrollView.contentOffset = CGPointMake(size.width/2 - frame.width/2, size.height/2 - frame.height/2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func composeImage(firstImage : UIImage , secondImage : UIImage ) -> UIImage{
        UIGraphicsBeginImageContext(firstImage.size)
        
        firstImage.drawInRect(CGRectMake(0, 0, firstImage.size.width, firstImage.size.height))
        secondImage.drawInRect(CGRectMake(-10, -10, 600, 600))
        
        var mergeImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        return mergeImage
    }
    
    /**
    取消按钮 回调
    */
    @IBAction func onCancel(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
    /**
    确认按钮 回调
    */
    @IBAction func onConfirm(sender: AnyObject) {
        var size = self.imageView.image!.size
        var imageFrame = self.imageView.getImageFrame()
        var rato = size.width / imageFrame.width
        UIGraphicsBeginImageContext(size)
        //原图
        self.imageView.image!.drawInRect(CGRectMake(0, 0, size.width, size.height))
        //水印
        self.waterMarkIV.image?.drawInRect(self.getFrameForSubviewInModifyView(self.waterMarkIV))
        var mosaics = self.getMosaics()
        
        for mosaic in mosaics {
            var mi = mosaic.imageview
            var frame = self.getFrameForSubviewInModifyView(mi)
            mi.image?.drawInRect(frame)
        }
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.completed?(image:newImage)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //  打码 按钮 回调
    @IBAction func onMosaic(sender: AnyObject) {
        self.createMosaic()
    }
    
    /**
    旋转按钮 回调
    */
    @IBAction func onRatate(sender: AnyObject) {
        var mosaics = self.getMosaics()
        if(mosaics.count > 0 ){
            MyToast.getInstance().toastWithText("打码中不能旋转", showInview: self.view, type: .Center)
            return
        }
        self.image = self.imageView.image?.ratateToNextOrientation(true)
        self.imageView.image = image
        updateFrame()
    }
    /**
    产生一个马赛克
    */
    func createMosaic(){
        var mosaic = NSBundle.mainBundle().loadNibNamed("MosaicView", owner: nil, options: nil)[0] as? MosaicView
        mosaic!.frame = CGRectMake(160, 160, 70, 70)
        mosaic!.center = CGPointMake(self.view.frame.width / 2, self.view.frame.height / 2)
        mosaic?.limitRect = self.getImageFrame()
        mosaic?.tag = 100
        self.view.addSubview(mosaic!)
    }
    //获取 待 修改 图片View 的 在 self.view 下 的 frame
    func getImageFrame() -> CGRect{
        var imageFrame = self.imageView.getImageFrame()
        return self.imageView.convertRect(imageFrame, toView: self.view)
        
    }
    //获取所有马赛克
    func getMosaics() -> [MosaicView]{
        var mosaics = [MosaicView]()
        for view in self.view.subviews {
            if(view.tag == 100){
                mosaics.append(view as! MosaicView)
            }
        }
        return mosaics
    }
    // 获取 在 待绘制 image 下的 frame
    func  getFrameForSubviewInModifyView(view : UIView) -> CGRect {
       var size = self.imageView.image!.size
       var imageFrame = self.imageView.getImageFrame()
       var rato = size.width / imageFrame.width
  
        var frame = self.imageView.convertRect(view.frame, fromView: view.superview!)
        frame.origin.x -= imageFrame.origin.x
        frame.origin.y -= imageFrame.origin.y
        var center = CGPointMake(frame.origin.x + frame.width / 2, frame.origin.y + frame.height / 2)
        
        var centerX = center.x / imageFrame.width * size.width
        var centerY = center.y / imageFrame.height * size.height
        var width = frame.width * rato
        var height = frame.height * rato
        return (CGRectMake(centerX - width / 2 ,centerY - height / 2 , width, height ))
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
