//
//  User.swift
//  WeSay
//
//  Created by QLX on 15/7/6.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var bAdmin: NSNumber
    @NSManaged var bigImageUrl: String
    @NSManaged var brithday: String
    @NSManaged var bThirdParty: NSNumber
    @NSManaged var headUrl: String
    @NSManaged var home: String
    @NSManaged var id: NSNumber
    @NSManaged var job: String
    @NSManaged var name: String
    @NSManaged var password: String
    @NSManaged var phoneModel: String
    @NSManaged var phoneNum: String
    @NSManaged var place: String
    @NSManaged var sex: String
    @NSManaged var time: String
    @NSManaged var thridPartyID: NSNumber
    
    func initWithJSON (json:JSON){
        var admin = json["uadmin"].boolValue
        self.bAdmin = NSNumber(bool: admin)
        self.bigImageUrl = json["ubg_image"].stringValue
        self.brithday = json["ubirthday"].stringValue
        var thrirdParty = json["uthird_party"].boolValue
        self.bThirdParty = NSNumber(bool: thrirdParty)
        self.headUrl = json["uhead"].stringValue
        self.home = json["uhome"].stringValue
        var id = json["uid"].intValue
        self.id = NSNumber(integer: id)
        self.job = json["ujob"].stringValue
        self.name = json["uname"].stringValue
        self.password = json["upwd"].stringValue
        self.phoneModel = json["uphone_model"].stringValue
        self.phoneNum = json["uphone_num"].stringValue
        self.place = json["uplace"].stringValue
        self.sex = json["usex"].stringValue
        self.time = json["utime"].stringValue
        var thirdPartyId = json["third_party_id"].intValue
        self.thridPartyID = NSNumber(integer: thirdPartyId)
    }

}
