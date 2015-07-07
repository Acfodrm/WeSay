//
//  LoginViewController.swift
//  WeSay
//
//  Created by 邱良雄 on 15/6/13.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit
import Foundation

enum LoginType:Int{
    case  QQ
    case  Sina
    case  WeiXi
    case None
}
class SignInVC: UIViewController ,UITextFieldDelegate,UIGestureRecognizerDelegate{
    
    @IBOutlet weak var headIcon: UIImageView!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var pwdInput: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var otherLoginButton: UIButton!
    var loginList:ActionSheet?
    var complete : (()->Void)?
    //入口
    override func viewDidLoad() {
        super.viewDidLoad()
        // 导航栏  取消返回 按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "onBack")
        //初始化 用户名输入框
        initTextField(nameInput, iconName: "user_name_icon.png")
        //初始化  密码款输入框
        initTextField(pwdInput, iconName: "password_icon.png")
        //点击空白处 自动收起键盘
        self.autoStopKeyboard()
        //初始化头像
        initHeadIcon()
        //标题
        self.navigationItem.setTitle("登录")
        //设置登录按钮样式
        self.loginButton.setRoundBg(20, color: UIColor.mainColor())
        //设置其他帐号登录样式
        self.otherLoginButton.setRoundBg(20, color: UIColor.mainColor())
//        var iv = UIImageView(frame: self.view.frame)
//        iv.setImageWithUrlString("http://localhost:8888/WeSayServer/2.png")
//        self.view.addSubview(iv)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //初始化 输入框
    func initTextField(tf: UITextField , iconName :String){
        //设置输入框的左View
        var icon = UIImageView(name: iconName, contentMode:.Center)
        icon.frame = CGRectMake(0, 0, 43, tf.frame.height)
        tf.leftViewMode = UITextFieldViewMode.Always
        tf.leftView = icon
        
        //设置输入框的背景
        var bg = UIImage(named: "text_field.png")
        bg=bg?.resizableImageWithCapInsets(UIEdgeInsetsMake(10, 44, 10, 10), resizingMode: UIImageResizingMode.Stretch)
        tf.background = bg
        tf.tintColor = UIColor.mainColor()
        tf.delegate = self
        tf.clearButtonMode = UITextFieldViewMode.WhileEditing
        tf.layer.cornerRadius = 11
        tf.layer.masksToBounds = true
        tf.keyboardAppearance = UIKeyboardAppearance.Light
//        tf.addTarget(self, action: "onEditingChanged:", forControlEvents: UIControlEvents.EditingChanged)
    }
//    // 解决 单行输入框  中文联想输入 字数限制问题
//    func onEditingChanged(textfield : UITextField){
//        if(textfield == self.pwdInput){
//            if(textfield.text.counts() > 10){
//                var text = textfield.text.substringToIndex(10)
//                textfield.text = text
//            }
//        }
//    }
    //初始化 头像
    func initHeadIcon(){
        headIcon.layer.cornerRadius = headIcon.frame.width/2
        headIcon.layer.borderWidth = 3
        headIcon.layer.masksToBounds = true
        headIcon.layer.borderColor = UIColor.whiteColor().CGColor
    }
    //-------------UITextFieldDelegate   ----------------------------
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        //println("beginEditing")
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        var res=true
        if(textField == nameInput){
            var result=SignInManager.checkForPhoneNumInput(textField.text+string)
            if(result.result==false){
                res=false
                textField.animateWithShake()
                AudioToolBoxUtil.systemShake()
                MyToast.getInstance().toastWithText(result.description, showInview: self.view,type: ShowType.Top)
            }
        }
        else {
            var result=SignInManager.checkPwdInput(textField.text+string, submit: false)
            if(result.result==false){
                res=false
                textField.animateWithShake()
                AudioToolBoxUtil.systemShake()
                MyToast.getInstance().toastWithText(result.description, showInview: self.view,type: ShowType.Top)
                
            }
        }
        //println(string)
        return res
    }
    // 登录 按钮回调用
    @IBAction func onLogin(sender: AnyObject) {
        var num = self.nameInput.text
        var pwd = self.pwdInput.text
       MyToast.getInstance().toastOfWaitingWithText("正在登录", showInView: self.view)
       HttpRequestManager.getInstance().login(num, pwd: pwd) { (error, userinfo) -> Void in
         //登录回调
        if let info = userinfo { //登录成功
            println(info)
             MyToast.getInstance().dismissInView(self.view)
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                 LoginStatus.getInstance().user = info
                
            })
            
        }else {  //登录失败
            MyToast.getInstance().toastWithText(error!, showInview: self.view, type: ShowType.Top)
        }
      }
    }
    
    // 使用其他帐号登录回调
    @IBAction func onLoginWithOtherAccount(sender: AnyObject) {
        loginList=ActionSheet()
        var width=self.view.frame.width
        loginList!.addCellWithButton("QQ登录", width: width)
        loginList!.addCellWithButton("微博登录", width: width)
        loginList!.addCellWithButton("微信登录", width: width)
        loginList!.selectedCallabck=didSelectedWithOtherAccout
        loginList!.show(self.view)
    }
    // 注册
    @IBAction func onSignUp(sender: AnyObject) {
    }
    //忘记密码
    @IBAction func onFindPwd(sender: AnyObject) {
    }
    //第三方帐号选择登录
    func didSelectedWithOtherAccout(index:Int){
        var type=LoginType(rawValue: index)
        switch type!{
        case LoginType.QQ:
            loginThreePartyAcoountWithType(ShareTypeQQSpace)
        case LoginType.Sina:
            loginThreePartyAcoountWithType(ShareTypeSinaWeibo)
        case LoginType.WeiXi:
            loginThreePartyAcoountWithType(ShareTypeWeixiSession)
        case LoginType.None:
            loginList!.hiden()
        default:
            break;
        }
        
    }
    //第三方登录 帐号
    func loginThreePartyAcoountWithType(type:ShareType){
        //ShareSDK.cancelAuthWithType(type)//## 带删除
        ShareSDK.getUserInfoWithType(type, authOptions: nil) { (result, userinfo, error) -> Void in
            if(result){
                var uid=userinfo.uid()
                var nickName=userinfo.nickname()
                var iconURL=userinfo.profileImage()
                self.loginSuccessCallaback(uid, nickName:nickName, iconURL: iconURL)
            }else{
                self.loginList!.hiden()
                println(error.errorDescription())
            }
        }
    }
    //登录成功回调
    func loginSuccessCallaback(uid:String,nickName:String?,iconURL:String?){
        println("loginSuccess")
    }
    // 取消登录
    func onBack(){
        MyToast.getInstance().dismissInView(self.view)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
