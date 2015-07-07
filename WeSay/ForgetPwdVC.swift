//
//  ForgetPwdVC.swift
//  WeSay
//
//  Created by Allone on 15/6/20.
//  Copyright (c) 2015年 qlx. All rights reserved.
//

import UIKit

class ForgetPwdVC: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var vertityCode: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var vertiBtn: UIButton!
    @IBOutlet weak var upodatePwdBtn: UIButton!
    @IBOutlet weak var panelBg: UIView!
    var  countdown=30
    var countdownTimer:NSTimer?
     var vertiCodeiSended=false
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置惦记空白处  键盘自动收起
        self.autoStopKeyboard()
        //设置标题
        self.navigationItem.setTitle("修改密码",color: UIColor.whiteColor(),fontSize: 18)
        //设置验证码背景
        self.vertiBtn.setRoundBg(5,color: UIColor.mainColor())
        self.vertiBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        //设置注册按钮背景
        self.upodatePwdBtn.setRoundBg(20, color: UIColor.mainColor())
        //面板背景圆角
        self.panelBg.layer.cornerRadius=10
        self.panelBg.layer.masksToBounds=true
        // Do any additional setup after loading the view.
        //设置输入框
        self.phoneNum.delegate=self
        self.vertityCode.delegate=self
        self.pwd.delegate=self
    }
    override func viewDidDisappear(animated: Bool) {
        self.countdownTimer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //发送验证码
    @IBAction func onSendVertiCode(sender: AnyObject) {
        self.setVertiCodeBtnSending()
        var phone = self.phoneNum.text
        SMS_SDK.getVerificationCodeBySMSWithPhone(phone, zone: "86") { (error) -> Void in
            if(error == nil){
                self.vertiCodeiSended=true
                self.seVertiCodeDisabel()
            }else{
                self.setVertiCodeBtnEnabled()
                MyToast.getInstance().toastWithText(error.errorDescription, showInview: self.view, type: ShowType.Top)
            }
        }
    }
    //修改密码
    @IBAction func onUpdatePwd(sender: AnyObject) {
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var res=true
        var text=textField.text+string
        if(textField == phoneNum){
            var result=SignUpMannager.checkForPhoneNumInput(text, submit: false)
            if(result.result == false){
                res=false
                phoneNum.animateWithShake()
                AudioToolBoxUtil.systemShake()
                MyToast.getInstance().toastWithText(result.description, showInview: self.view, type: ShowType.Top)
            }
        }else if(textField == vertityCode){
            var result=SignUpMannager.checkForVerifityCodeInput(text, submit: false)
            if(result.result == false){
                res=false
                self.vertityCode.animateWithShake()
                AudioToolBoxUtil.systemShake()
                MyToast.getInstance().toastWithText(result.description, showInview: self.view, type: ShowType.Top)
            }
        }else if(textField == pwd){
            var result=SignUpMannager.checkForPwdInput(text, submit: false)
            if(result.result==false){
                res=false
                self.pwd.animateWithShake()
                AudioToolBoxUtil.systemShake()
                MyToast.getInstance().toastWithText(result.description, showInview: self.view, type: ShowType.Top)
            }
        }
        
        return res
    }
    //设置验证码按钮不可用
    func seVertiCodeDisabel(){
        self.vertiBtn.enabled=false
        self.vertiBtn.backgroundColor=UIColor.grayColor()
        self.countdown=VERTICODE_TIME
        countdownTimer=NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateVertiCodeBtn", userInfo: nil, repeats: true)
        countdownTimer?.fire()
    }
    //每一秒钟回调设置 验证按钮的文本
    func updateVertiCodeBtn(){
        var text=String(countdown)+"s"
        self.vertiBtn.setTitle(text, forState: UIControlState.Disabled)
        if(countdown<0){
            setVertiCodeBtnEnabled()
        }
        countdown--
    }
    //重新激活验证码按扭
    func setVertiCodeBtnEnabled(){
        self.vertiBtn.enabled=true
        self.countdown = VERTICODE_TIME
        self.vertiBtn.backgroundColor=UIColor.mainColor()
        self.vertiBtn.setTitle("验证码", forState: UIControlState.Normal)
        countdownTimer?.invalidate()
        countdownTimer=nil  //如果不设置位nil 造成无法释放
    }
    //验证码按钮设置为正在发送
    func setVertiCodeBtnSending(){
        self.vertiBtn.enabled=false
        self.vertiBtn.setTitle("正在发送", forState: UIControlState.Normal)
    }
    //验证码是否正确
    func checkVertiCodeIsRight(code:String)->Bool{
        var res=true
        SMS_SDK.commitVerifyCode(code, result: { (state:SMS_ResponseState) -> Void in
            res=state.value==1
        })
        return res
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
