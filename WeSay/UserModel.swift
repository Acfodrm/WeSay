//
//  UserModel.swift
//  WeSay
//
//  Created by QLX on 15/7/2.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class UserModel: NSObject {
     var id: Int
     var name: String
     var password: String
     var phoneNum: String
     var headUrl: String
     var sex: String
     var brithday: String
     var job: String
     var home: String
     var phoneModel: String
     var place: String
     var bigImageUrl: String
     var time: String
     var bAdmin: Bool
     var bThirdParty: Bool
 
    init(json: JSON){
       
        self.id = json["uid"].intValue
        self.name = json["uname"].stringValue
        self.password = json["upwd"].stringValue
        self.phoneNum = json["uphone_num"].stringValue
        self.headUrl = json["uhead"].stringValue
        self.sex = json["usex"].stringValue
        self.brithday = json["ubirthday"].stringValue
        self.job = json["ujob"].stringValue
        self.home = json["uhome"].stringValue
        self.phoneModel = json["uphone_model"].stringValue
        self.place = json["uplace"].stringValue
        self.bigImageUrl = json["ubg_image"].stringValue
        self.time = json["utime"].stringValue
        self.bAdmin = json["uadmin"].boolValue
        self.bThirdParty = json["uthird_party"].boolValue
    }
    func convertByJSON( json : JSON ){
        println(json.description)
        
    }
}
