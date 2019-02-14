//
//  PasswordAlert.swift
//  nearby
//
//  Created by kunpo on 2018/3/27.
//  Copyright © 2018年 best-inc. All rights reserved.
//

import Foundation
import UIKit

public protocol PasswordAlertDelegate: class {
    //完成输入密码
    func accomplised(passwordAlert view: PasswordAlert, password: String)
    //密码未输入完，关闭了键盘
    func close(passwordAlert view: PasswordAlert) -> Bool
}

public class PasswordAlert: UIView {
    
    weak var delegate: PasswordAlertDelegate?
    
    let alertW: CGFloat = UIScreen.main.bounds.width * 0.8
    var alertH: CGFloat = 200.0
    
    let titleH: CGFloat = 35.0
    let detailH: CGFloat = 25.0
    let explainH: CGFloat = 50.0
    let segmentationH: CGFloat = 10.0
    let partingLineH: CGFloat = 1.0
    let passwordViewH: CGFloat = 40
    var passwordView: PasswordView?
    var background: UIView!
    
    public convenience init(title: String?, detail: String?, explain:String?, delegate: PasswordAlertDelegate? ) {
         self.init(frame: UIScreen.main.bounds)
        background = UIView(frame: .zero)
        var viewH: CGFloat = 0
        if title != nil {
            let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: segmentationH), size: CGSize(width: alertW, height: titleH)))
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 23.0)
            background.addSubview(titleLabel)
        }
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(origin: CGPoint(x: segmentationH, y: segmentationH), size: CGSize(width: titleH, height: titleH))
        btn.addTarget(self, action: #selector(closePassword), for: .touchUpInside)
        btn.setTitle("X", for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        background.addSubview(btn)
        
        viewH = segmentationH + titleH + segmentationH
        let partingLine = UIView(frame: CGRect(x: 0, y: viewH, width: alertW, height: partingLineH))
        partingLine.backgroundColor = UIColor.lightGray
        background.addSubview(partingLine)
        viewH += (partingLineH + segmentationH)
        
        if detail != nil {
            let detailLabel = UILabel(frame: CGRect(x: 0, y: viewH, width: alertW, height: detailH))
            detailLabel.text = detail
            viewH += (detailH + segmentationH)
            detailLabel.textAlignment = .center
            background.addSubview(detailLabel)
        }
        
        if explain != nil {
            let explainLabel = UILabel(frame: CGRect(x: 0, y: viewH, width: alertW, height: explainH))
            explainLabel.text = explain
            explainLabel.textAlignment = .center
            viewH += (explainH + segmentationH)
            explainLabel.font = UIFont.systemFont(ofSize: 35.0)
            background.addSubview(explainLabel)
        }
        
        passwordView = PasswordView(frame: CGRect(x: 0, y: viewH, width: alertW, height: passwordViewH))
        passwordView?.delegate = self
        background.addSubview(passwordView!)
        viewH += (passwordViewH + segmentationH)
        background.frame = CGRect(origin: .zero, size: CGSize(width: alertW, height: viewH))
        background.layer.cornerRadius = 5.0
        background.backgroundColor = UIColor.white
        addSubview(background)
        backgroundColor = UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 0.4)
    }
    
    @objc fileprivate func closePassword() {
        removeSelf()
    }
    
    public func show() {
        if let keyWindow = UIApplication.shared.keyWindow {
            var center = self.center
            center.y -= 100.0
            background.center = center
            background.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
            background.alpha = 0
            keyWindow.addSubview(self)
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIView.AnimationOptions(), animations: ({
                let _ = self.passwordView?.becomeFirstResponder()
                self.background.transform = CGAffineTransform(scaleX: 1, y: 1)
                self.background.alpha = 1.0
                
            }), completion: nil)
        }

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func removeSelf() {
        passwordView?.endEditing(true)
        self.removeFromSuperview()
    }
    
}

extension PasswordAlert: PasswordViewDelegate {
    
    func accomplished(passwordView: PasswordView, password: String) {
        self.delegate?.accomplised(passwordAlert: self, password: password)
        self.removeSelf()
    }
    
    func close(passwordView: PasswordView) -> Bool {
        
        let canClose = delegate?.close(passwordAlert: self)
        if (canClose == true) || (canClose == nil) {
           
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.removeSelf()
            })
            
        }
        
        return canClose != nil ? canClose! : true
    }
}


//public protocol PasswordActionSheetDelegate: class {
//    //密码输入完成
//    func accomplised(actionSheet view: PasswordActionSheet, password: String)
//    //未输入完，关闭了键盘
//    func close(actionSheet view: PasswordActionSheet) -> Bool
//    //点击了忘记密码btn时
//    func forget(actionSheet sheet: PasswordActionSheet)
//    
//}
//
//public class PasswordActionSheet: UIView {
//    
//    let alertW: CGFloat = UIScreen.main.bounds.width
//    
//    let titleH: CGFloat = 35.0
//    let detailH: CGFloat = 25.0
//    let explainH: CGFloat = 50.0
//    let segmentationH: CGFloat = 10.0
//    let partingLineH: CGFloat = 1.0
//    let passwordViewH: CGFloat = 54
//    var passwordView: PasswordView?
//    var background: UIView!
//    weak var delegate: PasswordActionSheetDelegate?
//    var viewH: CGFloat = 0
//    let btnH: CGFloat = 25.0
//    let btnW = UIScreen.main.bounds.width * 0.3
//    
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required public init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    public convenience init(title: String?,cancelImage: String?, btnTitle: String?, delegate: PasswordActionSheetDelegate?) {
//        let frame = UIScreen.main.bounds
//        self.init(frame: frame)
//        self.delegate = delegate
//        background = UIView(frame: CGRect(origin: CGPoint(x: 0, y: frame.height), size: frame.size))
//        addSubview(background)
//        
//        if title != nil {
//            let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: segmentationH), size: CGSize(width: alertW, height: titleH)))
//            titleLabel.text = title
//            titleLabel.textAlignment = .center
//            titleLabel.font = UIFont.systemFont(ofSize: 23.0)
//            background.addSubview(titleLabel)
//        }
//        
//        let cancel = UIButton(type: .custom)
//        cancel.frame = CGRect(origin: CGPoint(x: segmentationH, y: segmentationH), size: CGSize(width: titleH, height: titleH))
//        cancel.addTarget(self, action: #selector(closePassword), for: .touchUpInside)
//        
//        if let imageName = cancelImage, let cancelImage = UIImage(named: imageName) {
//            cancel.setImage(cancelImage, for: .normal)
//        } else {
//            cancel.setTitle("X", for: .normal)
//        }
//        cancel.setTitleColor(UIColor.lightGray, for: .normal)
//        background.addSubview(cancel)
//        
//        viewH = segmentationH + titleH + segmentationH
//        let partingLine = UIView(frame: CGRect(x: 0, y: viewH, width: alertW, height: partingLineH))
//        partingLine.backgroundColor = UIColor.lightGray
//        background.addSubview(partingLine)
//        viewH += (partingLineH + segmentationH)
//        
//        passwordView = PasswordView(frame: CGRect(x: 15.0, y: viewH, width: (alertW - 30), height: passwordViewH))
//        passwordView?.delegate = self
//        background.addSubview(passwordView!)
//        viewH += (passwordViewH + segmentationH)
//        
//        if let btnT = btnTitle {
//            let btn = UIButton(type: .custom)
//            btn.frame = CGRect(x: alertW - 15 - btnW, y: viewH, width: btnW, height: btnH)
//            btn.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
//            btn.setTitle(btnT, for: .normal)
//            btn.setTitleColor(UIColor(red: 81.0 / 255.0, green: 141.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0), for: .normal)
//            btn.contentHorizontalAlignment = .right
//            background.addSubview(btn)
//            viewH += (btnH + segmentationH)
//        }
//        viewH += (3 * segmentationH)
//        background.backgroundColor = UIColor.white
//        backgroundColor = UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 0.4)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name:Notification.Name.UIKeyboardWillShow , object: nil)
//    }
//    
//    public func show() {
//        if let keyWindow = UIApplication.shared.keyWindow {
//            keyWindow.addSubview(self)
//            let _ = passwordView?.becomeFirstResponder()
//        }
//    }
//    
//    @objc fileprivate func keyboardWillShow(note: NSNotification) {
//        let userInfo = note.userInfo!
//        let keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardH = keyBoardBounds.size.height
//        let size = UIScreen.main.bounds.size
//        let y = size.height - viewH - keyboardH
//        let origin = CGPoint(x: 0, y: y)
//        background.frame = CGRect(origin: origin, size: size)
//    }
//
//    public func dismiss() {
//        passwordView?.endEditing(true)
//        self.removeFromSuperview()
//    }
//    
//    fileprivate func removeSelf() {
//        passwordView?.endEditing(true)
//        self.removeFromSuperview()
//    }
//    
//    @objc fileprivate func closePassword() {
//        removeSelf()
//    }
//    
//    @objc fileprivate func forgetPassword() {
//        self.delegate?.forget(actionSheet: self)
//    }
//
//}
//
//extension PasswordActionSheet: PasswordViewDelegate {
//    
//    func accomplished(passwordView: PasswordView, password: String) {
//        self.delegate?.accomplised(actionSheet: self, password: password)
//        self.removeSelf()
//    }
//    
//    func close(passwordView: PasswordView) -> Bool {
//        
//        let canClose = delegate?.close(actionSheet: self)
//        if (canClose == true) || (canClose == nil) {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
//                self.removeSelf()
//            })
//        }
//        
//        return canClose != nil ? canClose! : true
//    }
//    
//}
//
