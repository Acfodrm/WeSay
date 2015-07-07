//
//  打发打发.swift
//  WeSay
//
//  Created by QLX on 15/6/23.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit
let DB = DataContext()!
class DataContext: Context{
    var users: Table<User> {return Table<User>(context:self)}
    var articles: Table<Article>{ return Table<Article>(context:self)}
}