//
//  SayCellItem.swift
//  WeSay
//
//  Created by QLX on 15/7/4.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class ArticleCellItem: NSObject {
    var text : String? // 文本
    var imagePath : String?
    var videoPath : String?
    
    var headImagePath : String? // 头像
    var name : String? // 名字
    var likeNum : String? //好笑数目
    var comentNum : String? //评论数
    var uid : Int = 0
    var tid: Int = 0
    var fun : Bool?
}
