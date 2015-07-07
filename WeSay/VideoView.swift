//
//  VideoView.swift
//  WeSay
//
//  Created by QLX on 15/6/29.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class VideoView: UIView {
    var movievc:MPMoviePlayerController!
    var playBtn : UIButton!
    var firstImageView: UIImageView!
    var firstEnter = true
    var autoRepeat = false
    var frameUpdateCallback: (( frame:CGRect) -> Void )?
    var _shouldAutoplay:Bool = false
    var shouldAutoplay:Bool {
        set {
            self._shouldAutoplay = newValue
            self.movievc.shouldAutoplay = newValue
        }get{
            return self._shouldAutoplay
        }
    }
    init(contentURL :NSURL!){
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.movievc = MPMoviePlayerController(contentURL: contentURL)
        self.addSubview(self.movievc.view)
        self.movievc.requestThumbnailImagesAtTimes([NSNumber(float: 0.0)], timeOption: MPMovieTimeOption.NearestKeyFrame)
        self.movievc.controlStyle = MPMovieControlStyle.None
        self.movievc.view.hidden = true
        // self.movievc.view.backgroundColor = UIColor.clearColor()
        self.movievc.shouldAutoplay = true
        self.movievc.scalingMode = MPMovieScalingMode.AspectFit
        self.movievc.view.frame = CGRectMake(8, 100, 100, 200)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMoviePlayerPlaybackStateDidChange:", name: MPMediaPlaybackIsPreparedToPlayDidChangeNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMoviePlayerPlaybackDidFinish:", name: MPMoviePlayerPlaybackDidFinishNotification, object:nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onMoviePlayerThumbnailImageRequestDidFinish:", name: MPMoviePlayerThumbnailImageRequestDidFinishNotification, object:nil)
        
        
        
        //第一张图片
        self.firstImageView = UIImageView()
        self.addSubview(self.firstImageView)
        
        
        // playBtn
        self.playBtn = UIButton()
        self.playBtn.setImage(UIImage(named: "play.png"), forState: UIControlState.allZeros)
        self.playBtn.addTarget(self, action: "onPlay", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.playBtn)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func onPlay(){
        self.play()
    }
    func pause(){
        self.movievc.pause()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if(!self.firstEnter){
            return
        }
        
    }
    
    func onMoviePlayerPlaybackStateDidChange(notify :NSNotification){
        var size = self.movievc.naturalSize
        var rato = size.width / self.frame.width
        self.movievc.view.frame = CGRectMake(0, 0, self.frame.width, size.height / rato)
        self.movievc.view.hidden = false
        
        var frame = self.frame
        frame.size.height = size.height / rato
        self.frame = frame
        self.frameUpdateCallback?(frame: frame)
        frame = self.frame
        var width = frame.width*0.3
        self.playBtn.frame = CGRectMake(0, 0, width, width)
        self.playBtn.center = CGPointMake(frame.width / 2, frame.height / 2)
        self.firstImageView.frame = self.bounds
        self.firstImageView.contentMode = UIViewContentMode.ScaleAspectFit
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMediaPlaybackIsPreparedToPlayDidChangeNotification, object: nil)
        
        if self.shouldAutoplay {
            self.play()
        }else {
            self.stop()
        }
    }
    func onMoviePlayerPlaybackDidFinish(notify :NSNotification){
        if self.autoRepeat {
            self.play()
        }else {
            self.stop()
        }
        
        //NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func onMoviePlayerThumbnailImageRequestDidFinish(notify :NSNotification){
        var info = notify.userInfo!
        
        var firstImage = info[MPMoviePlayerThumbnailImageKey] as! UIImage
        self.firstImageView.image = firstImage
    }
    func stop(){
        self.movievc.stop()
        self.firstImageView.hidden = false
        self.playBtn.hidden = false
        self.movievc.play()
        self.movievc.pause()
    }
    func play(){
        self.movievc.play()
        self.firstImageView.hidden = true
        self.playBtn.hidden = true
        
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.movievc.view.removeFromSuperview()
        self.movievc.stop()
        self.movievc = nil
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
