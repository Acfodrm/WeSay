//
//  UITableViewControllerExt.swift
//  WeSay
//
//  Created by QLX on 15/7/5.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class  UITableViewControllerExt : UITableViewController {
    
    var lastOffset:CGPoint = CGPointZero
    var draging = false
    var scrollOffsetByCallback : ((offsetBy: CGPoint , draging:Bool ) ->Void)?
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetyBy = CGPointMake(scrollView.contentOffset.x - self.lastOffset.x, scrollView.contentOffset.y - self.lastOffset.y)
        self.scrollOffsetByCallback?(offsetBy:offsetyBy , draging: self.draging)
        self.lastOffset = scrollView.contentOffset
    }
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.draging = true
    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.draging = false
        self.scrollViewDidScroll(self.tableView)
    }
}
