//
//  ViewController.swift
//  PasswordViewDemo
//
//  Created by kunpo on 2018/4/5.
//  Copyright © 2018年 kunpo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

  
    
    @IBAction func wechat(_ sender: Any) {
        PasswordAlert(title: "标题", detail: "请输入密码", explain: "这是要输入密码", delegate: self).show()
    }
    
    
    @IBAction func ali(_ sender: Any) {
        PasswordActionSheet(title: "标题", cancelImage: nil, btnTitle: "忘记密码?", delegate: self).show()
    }
    
    
}

extension ViewController: PasswordAlertDelegate {
    func accomplised(passwordAlert view: PasswordAlert, password: String) {
        print("输入的密码是" + password)
    }
    
    func stop(passwordAlert view: PasswordAlert) -> Bool {
        return true
    }
    
    
}

extension ViewController: PasswordActionSheetDelegate {
    func accomplised(actionSheet view: PasswordActionSheet, password: String) {
        print("输入的密码是" + password)
    }
    
    func close(actionSheet view: PasswordActionSheet) -> Bool {
        return true
    }
    
    func forget(actionSheet sheet: PasswordActionSheet) {
        sheet.dismiss()
        print("忘记密码了，😂，你自己看着办吧")
    }
    
    
}

class SecondVC: UIViewController {
    
    @IBOutlet weak var passwordView: PasswordView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordView.delegate = self
        let _ = passwordView.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
}

extension SecondVC: PasswordViewDelegate {
    func accomplished(passwordView: PasswordView, password: String) {
        print("输入的密码是" + password)
    }
    
    func close(passwordView: PasswordView) -> Bool {
        
        print("没输完密码就关闭了键盘")
        return true
    }
    
    
}

