//
//  Article.swift
//  WeSay
//
//  Created by QLX on 15/7/6.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import Foundation
import CoreData

class Article: NSManagedObject {

    @NSManaged var vid: NSNumber
    @NSManaged var uid: NSNumber
    @NSManaged var tid: NSNumber
    @NSManaged var text: String
    @NSManaged var imagePath: String
    @NSManaged var videoPath: String
    @NSManaged var likeNum: NSNumber
    @NSManaged var unLikeNum: NSNumber
    @NSManaged var comentNum: NSNumber
    @NSManaged var time: NSNumber
    @NSManaged var pass: NSNumber
    @NSManaged var user: User
    
    func initWithJSON(json:JSON){
        var vid = json["vid"].intValue
        self.vid = NSNumber(integer :vid )
        var uid = json["uid"].intValue
        self.uid = NSNumber(integer: uid)
        var tid = json["tid"].intValue
        self.tid = NSNumber(integer :tid)
        self.text = json["vtext"].stringValue
        self.imagePath = json["vimage"].stringValue
        self.videoPath = json["vvideo"].stringValue
        var likeNum = json["vlike"].intValue
        self.likeNum = NSNumber(integer : likeNum)
        var unLikeNum = json["vunlike"].intValue
        self.unLikeNum = NSNumber(integer: unLikeNum)
        var comentNum = json["vcoment"].intValue
        self.comentNum = NSNumber(integer: comentNum)
        var time = json["vtime"].doubleValue
        self.time = NSNumber(double: time)
        var pass = json["vpass"].boolValue
        self.pass = NSNumber(bool: pass)
    }

}
