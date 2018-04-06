//
//  PasswordView.swift
//  nearby
//
//  Created by kunpo on 2018/3/26.
//  Copyright © 2018年 best-inc. All rights reserved.
//

import Foundation
import UIKit

protocol PasswordViewDelegate: class {
    //完成输入密码
    func accomplished(passwordView: PasswordView, password: String)
    //密码未输完时关闭键盘
    func close(passwordView: PasswordView) -> Bool
}

enum SecretType {
    case asterisk, point
}

public class PasswordView: UIView {
    
    var count = 6
    let textField = UITextField(frame: .zero)
    var password = ""
    var partitionColor = UIColor.lightGray
    var partitionWidth: CGFloat = 1.0
    weak var delegate: PasswordViewDelegate?
    
    var wordView: UIView?
    var secretLabels = [UILabel]()
    var secretViews = [UIView]()
    var secretType = SecretType.point
    var initalized = false
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if initalized == false {
            initalizeUI(frame: self.frame)
            initalized = true
        }
        
    }
    
    func initalizeUI(frame: CGRect) {
        textField.frame = .zero
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.clear
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChange(sender:)), for: .editingChanged)
        addSubview(textField)
        wordView = createWordView(size: frame.size)
        addSubview(wordView!)
        self.backgroundColor = UIColor.clear
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createWordView(size: CGSize) -> UIView {
        var h = size.height
        var w = size.width
        let center = CGPoint(x: frame.width / 2.0, y: frame.height / 2.0)
        let labelH1 = h - 2.0 * partitionWidth
        let labelH2 = (w - CGFloat(count) * partitionWidth) / CGFloat(count)
        let labelH = min(labelH1, labelH2)
        h = labelH + 2.0 * partitionWidth
        w = (labelH + partitionWidth) * CGFloat(count) + partitionWidth
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: w, height: h)))
        view.center = center
        view.backgroundColor = partitionColor
        
        for i in 0..<count {
            
            let x = CGFloat(i) * (labelH + partitionWidth) + partitionWidth
            let y = partitionWidth
            if secretType == .asterisk {
                let label = UILabel(frame: CGRect(x: x, y: y, width: labelH, height: labelH))
                label.backgroundColor = UIColor.white
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 40)
                label.adjustsFontSizeToFitWidth = true
                view.addSubview(label)
                secretLabels.append(label)
            } else {
                let v = UIView(frame: CGRect(x: x, y: y, width: labelH, height: labelH))
                v.backgroundColor = UIColor.white
                view.addSubview(v)
                secretViews.append(v)
            }
            
        }
        //仅仅是为了加个圆角而已，太坑了
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        view.layer.borderWidth = 1.0
        view.layer.borderColor = partitionColor.cgColor
        return view
    }
    
    func accomplished() {
        updateView(count: 0)
        textField.resignFirstResponder()
        textField.text = nil
    }
    
    public override func becomeFirstResponder() -> Bool {
        textField.text = nil
        return textField.becomeFirstResponder()
    }
    
    @objc func textFieldChange(sender: UITextField) {
        let text = textField.text == nil ? "" : textField.text!
        
        let textCount = text.count
        
        updateView(count: textCount)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if textCount == self.count {
                //输入完成
                let _ = self.resignFirstResponder()
                self.accomplished()
                self.delegate?.accomplished(passwordView: self, password: text)
            }
        }        
    }

    func updateView(count: Int) {
        
        if secretType == .asterisk {
            for i in 0..<secretLabels.count {
                if i < count {
                    secretLabels[i].text = "*"
                } else {
                    secretLabels[i].text = ""
                }
            }
        } else {
            secretViews.forEach({ view in
                view.subviews.forEach({ point in
                    point.removeFromSuperview()
                })
            })
            for i in 0..<secretViews.count {
                if i < count {
                    let view = secretViews[i]
                    let size = view.bounds.size
                    let w = size.width
                    let point = UIView(frame: CGRect(origin: .zero, size: CGSize(width: w * 0.25, height: w * 0.25)))
                    point.center = CGPoint(x: w / 2.0, y: w / 2.0)
                    point.layer.cornerRadius = w / 8.0
                    point.clipsToBounds = true
                    point.backgroundColor = UIColor.darkText
                    view.addSubview(point)
                }
            }
        }
    }
    
}

extension PasswordView: UITextFieldDelegate {
    
    public func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let count = textField.text?.count, count == 6 {
            return true
        }
        if let delegate = self.delegate {
            return delegate.close(passwordView: self)
        }
        return true
    }
    
}


