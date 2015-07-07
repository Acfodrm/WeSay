//
//  TextAndImageCell.swift
//  WeSay
//
//  Created by QLX on 15/7/3.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var unLikeBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var headIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var textLbl: UILabel!
    
    @IBOutlet weak var comentLabel: UILabel!
    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var imageIv: UIImageView!
    var firstLoad = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.headIV.setCircleEdge()
        self.likeBtn.setImage(UIImage(named: "like_press.png"), forState: UIControlState.Selected)
        self.unLikeBtn.setImage(UIImage(named : "unlikepress.png"), forState: UIControlState.Selected)
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    @IBAction func onLike(sender: AnyObject) {
        var likeBtn = sender as! UIButton
        if(likeBtn.selected) {
            //likeBtn.selected = false
            
        }else {
            self.unLikeBtn.selected = false
            likeBtn.selected = true
             likeBtn.animationWithKeyFrameForEaseIn(0.5, values: [1 , 1.8 , 1,1.4,1], keyPath: KeyPath.Scale, key: "zoomOut", additive: false)
        }
    }
    
    @IBAction func onUnLike(sender: AnyObject) {
        var unLikeBtn = sender as! UIButton
        if(unLikeBtn.selected) {
            //likeBtn.selected = false
            
        }else {
            self.likeBtn.selected = false
            unLikeBtn.selected = true
            unLikeBtn.animationWithKeyFrameForEaseIn(0.5, values: [1 , 1.8 , 1,1.4,1], keyPath: KeyPath.Scale, key: "zoomOut", additive: false)
        }

    }
    @IBAction func onComent(sender: AnyObject) {
    }
    @IBAction func onShare(sender: AnyObject) {
    }
    // 设置头像
    func setHeadWithImage(image : UIImage){
        
        self.headIV.image = image
    }
    //设置姓名
    func setNameWithName(name : String){
        self.nameLbl.text = name
    }
    // 设置文本内容
    func setContentWithText(text:String){
        self.textLbl.text = text
    }
    // 设置图片内容
    func setContentWithImage(image : UIImage){
        self.imageIv.image = image
        self.imageIv.layer.cornerRadius = 5
        self.imageIv.layer.masksToBounds = true
        self.imageIv.contentMode = UIViewContentMode.ScaleAspectFill
    }
    // 设置 笑点数 
    func setLikeNumWithNum(num : String){
        self.likeLbl.text = num + "好笑"
    }
    // 设置 评论数
    func setComentNumWithNum(num : String){
        self.comentLabel.text = num + "评论"
    }
    // 设置 是否参与点赞
    func setIsLike(like : Bool){
        if(like){
            self.likeBtn.selected = true
            self.likeBtn.selected = false
        }else {
            self.likeBtn.selected = true
            self.likeBtn.selected = false
        }
    }
    // 获取 理论的高度
    func getPerferHeightWithWidth(width : CGFloat) -> CGFloat{
        var textHeight = self.textLbl.sizeThatFits(CGSizeMake(width - 32, 9999)).height
        var imageHeight = self.imageIv.getHeightWithWidth(width - 32)
        imageHeight = 0
        return 178 + textHeight + imageHeight
    }
    
}
