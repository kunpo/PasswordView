//
//  PasswordActionSheet.swift
//  PasswordViewDemo
//
//  Created by kunpo on 2019/2/13.
//  Copyright © 2019 kunpo. All rights reserved.
//

import Foundation
import UIKit

public protocol PasswordActionSheetDelegate: class {
    //密码输入完成
    func accomplised(actionSheet view: PasswordActionSheetDismissProtocol, password: String)
    //未输入完，关闭了键盘
    func close(actionSheet view: PasswordActionSheetDismissProtocol) -> Bool
    //点击了忘记密码btn时
    func forget(actionSheet sheet: PasswordActionSheetDismissProtocol)
    
}

public protocol PasswordActionSheetDismissProtocol {
    func dismiss()
}

//MARK:------------PasswordActionSheet-------------------
//仿支付宝
public class PasswordActionSheet: UIView {
    
    let alertW: CGFloat = UIScreen.main.bounds.width
    
    let titleH: CGFloat = 35.0
    let detailH: CGFloat = 25.0
    let explainH: CGFloat = 50.0
    let segmentationH: CGFloat = 10.0
    let partingLineH: CGFloat = 1.0
    let passwordViewH: CGFloat = 54
    var passwordView: PasswordView?
    var background: UIView!
    weak var delegate: PasswordActionSheetDelegate?
    var viewH: CGFloat = 0
    let btnH: CGFloat = 25.0
    let btnW = UIScreen.main.bounds.width * 0.3
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public convenience init(title: String?,cancelImage: String?, btnTitle: String?, delegate: PasswordActionSheetDelegate?) {
        let frame = UIScreen.main.bounds
        self.init(frame: frame)
        self.delegate = delegate
        background = UIView(frame: CGRect(origin: CGPoint(x: 0, y: frame.height), size: frame.size))
        addSubview(background)
        
        if title != nil {
            let titleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: segmentationH), size: CGSize(width: alertW, height: titleH)))
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 23.0)
            background.addSubview(titleLabel)
        }
        
        let cancel = UIButton(type: .custom)
        cancel.frame = CGRect(origin: CGPoint(x: segmentationH, y: segmentationH), size: CGSize(width: titleH, height: titleH))
        cancel.addTarget(self, action: #selector(closePassword), for: .touchUpInside)
        
        if let imageName = cancelImage, let cancelImage = UIImage(named: imageName) {
            cancel.setImage(cancelImage, for: .normal)
        } else {
            cancel.setTitle("X", for: .normal)
        }
        cancel.setTitleColor(UIColor.lightGray, for: .normal)
        background.addSubview(cancel)
        
        viewH = segmentationH + titleH + segmentationH
        let partingLine = UIView(frame: CGRect(x: 0, y: viewH, width: alertW, height: partingLineH))
        partingLine.backgroundColor = UIColor.lightGray
        background.addSubview(partingLine)
        viewH += (partingLineH + segmentationH)
        
        passwordView = PasswordView(frame: CGRect(x: 15.0, y: viewH, width: (alertW - 30), height: passwordViewH))
        passwordView?.delegate = self
        background.addSubview(passwordView!)
        viewH += (passwordViewH + segmentationH)
        
        if let btnT = btnTitle {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: alertW - 15 - btnW, y: viewH, width: btnW, height: btnH)
            btn.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
            btn.setTitle(btnT, for: .normal)
            btn.setTitleColor(UIColor(red: 81.0 / 255.0, green: 141.0 / 255.0, blue: 234.0 / 255.0, alpha: 1.0), for: .normal)
            btn.contentHorizontalAlignment = .right
            background.addSubview(btn)
            viewH += (btnH + segmentationH)
        }
        viewH += (3 * segmentationH)
        background.backgroundColor = UIColor.white
        backgroundColor = UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 0.4)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name:UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    public func show() {
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(self)
            let _ = passwordView?.becomeFirstResponder()
        }
    }
    
    @objc fileprivate func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let keyBoardBounds = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardH = keyBoardBounds.size.height
        let size = UIScreen.main.bounds.size
        let y = size.height - viewH - keyboardH
        let origin = CGPoint(x: 0, y: y)
        background.frame = CGRect(origin: origin, size: size)
    }
    
    fileprivate func removeSelf() {
        passwordView?.endEditing(true)
        self.removeFromSuperview()
    }
    
    @objc fileprivate func closePassword() {
        removeSelf()
    }
    
    @objc fileprivate func forgetPassword() {
        self.delegate?.forget(actionSheet: self)
    }
    
}

extension PasswordActionSheet: PasswordActionSheetDismissProtocol {
    public func dismiss() {
        passwordView?.endEditing(true)
        self.removeFromSuperview()
    }
}

extension PasswordActionSheet: PasswordViewDelegate {
    
    func accomplished(passwordView: PasswordView, password: String) {
        self.delegate?.accomplised(actionSheet: self, password: password)
        self.removeSelf()
    }
    
    func close(passwordView: PasswordView) -> Bool {
        
        let canClose = delegate?.close(actionSheet: self)
        if (canClose == true) || (canClose == nil) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.removeSelf()
            })
        }
        
        return canClose != nil ? canClose! : true
    }
    
}

//MARK: -------------------PasswordActionSheetStyle1-------------------
//与支付宝相似，但❌放在了右边且没有分割线
public class PasswordActionSheetStyle1: UIView {
    
    let alertW: CGFloat = UIScreen.main.bounds.width
    let titleTop: CGFloat = 12.0 //title距顶部高度
    let titleH: CGFloat = 23.0
    let passwordViewTop: CGFloat = 20.0 //密码框距title距离
    let passwordViewH: CGFloat = 47.0
    let forgetBtnTop: CGFloat = 20.0 //忘记密码距passwordview距离
    let keyboardTop: CGFloat = 36.0 //键盘距忘记密码距离
    
    var passwordView: PasswordView?
    var background: UIView!
    weak var delegate: PasswordActionSheetDelegate?
    var viewH: CGFloat = 0
    let btnH: CGFloat = 25.0
    let btnW = UIScreen.main.bounds.width * 0.3

    public var titleLabel = UILabel(frame: .zero)
    public var cancel = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public convenience init(title: String?,cancelImage: String?, btnTitle: String?, delegate: PasswordActionSheetDelegate?) {
        let frame = UIScreen.main.bounds
        self.init(frame: frame)
        self.delegate = delegate
        background = UIView(frame: CGRect(origin: CGPoint(x: 0, y: frame.height), size: frame.size))
        addSubview(background)
        
        if title != nil {
            titleLabel.frame = CGRect(origin: CGPoint(x: 0, y: titleTop), size: CGSize(width: alertW, height: titleH))
            titleLabel.text = title
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 18.0)
            titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            background.addSubview(titleLabel)
        }
        
        //X是根据UI图确定的没有原因
        cancel.frame = CGRect(origin: CGPoint(x: alertW - 35.0, y: titleTop), size: CGSize(width: titleH, height: titleH))
        cancel.addTarget(self, action: #selector(closePassword), for: .touchUpInside)
        
        if let imageName = cancelImage, let cancelImage = UIImage(named: imageName) {
            cancel.setImage(cancelImage, for: .normal)
        } else {
            cancel.setTitle("×", for: .normal)
        }
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 40.0)
        cancel.setTitleColor(UIColor(red: 68.0 / 255.0, green: 68.0 / 255.0, blue: 68.0 / 255.0, alpha: 1.0), for: .normal)
        background.addSubview(cancel)
        
        viewH = titleTop + titleH + passwordViewTop
        passwordView = PasswordView(frame: CGRect(x: 15.0, y: viewH, width: (alertW - 30), height: passwordViewH))
        passwordView?.delegate = self
        background.addSubview(passwordView!)
        viewH += (passwordViewH + forgetBtnTop)
        
        if let btnT = btnTitle {
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: alertW - 15 - btnW, y: viewH, width: btnW, height: btnH)
            btn.addTarget(self, action: #selector(forgetPassword), for: .touchUpInside)
            btn.setTitle(btnT, for: .normal)
            btn.setTitleColor(UIColor(red: 16.0 / 255.0, green: 142.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0), for: .normal)
            btn.contentHorizontalAlignment = .right
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
            background.addSubview(btn)
            viewH += btnH
        }
        viewH += keyboardTop
        background.backgroundColor = UIColor.white
        backgroundColor = UIColor(red: 102.0 / 255.0, green: 102.0 / 255.0, blue: 102.0 / 255.0, alpha: 0.4)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(note:)), name:UIResponder.keyboardWillShowNotification , object: nil)
    }
    
    public func show() {
        if let keyWindow = UIApplication.shared.keyWindow {
            keyWindow.addSubview(self)
            let _ = passwordView?.becomeFirstResponder()
        }
    }
    
    @objc fileprivate func keyboardWillShow(note: NSNotification) {
        let userInfo = note.userInfo!
        let keyBoardBounds = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardH = keyBoardBounds.size.height
        let size = UIScreen.main.bounds.size
        let y = size.height - viewH - keyboardH
        let origin = CGPoint(x: 0, y: y)
        background.frame = CGRect(origin: origin, size: size)
    }
    
    fileprivate func removeSelf() {
        passwordView?.endEditing(true)
        self.removeFromSuperview()
    }
    
    @objc fileprivate func closePassword() {
        removeSelf()
    }
    
    @objc fileprivate func forgetPassword() {
        self.delegate?.forget(actionSheet: self)
    }
    
}

extension PasswordActionSheetStyle1: PasswordActionSheetDismissProtocol {
    public func dismiss() {
        passwordView?.endEditing(true)
        self.removeFromSuperview()
    }
}

extension PasswordActionSheetStyle1: PasswordViewDelegate {
    
    func accomplished(passwordView: PasswordView, password: String) {
        self.delegate?.accomplised(actionSheet: self, password: password)
        self.removeSelf()
    }
    
    func close(passwordView: PasswordView) -> Bool {
        
        let canClose = delegate?.close(actionSheet: self)
        if (canClose == true) || (canClose == nil) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.removeSelf()
            })
        }
        
        return canClose != nil ? canClose! : true
    }
    
}

