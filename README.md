# PasswordView
# 效果图
![效果如图](https://github.com/kunpo/PasswordView/blob/master/DocumentAssets/demo.gif)

# Installation
可以使用 CocoaPods导入项目
```
pod pod 'PasswordView'
```
# 使用
可参考demo里的使用方法。
## v 0.0.5
```
/*
弹出仿支付宝的弹框
实现PasswordActionSheetDelegate代理方法
*/
PasswordActionSheet(title: "标题", cancelImage: nil, btnTitle: "忘记密码?", delegate: self).show()

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
```

```
/*
弹出仿微信的弹框
实现PasswordAlertDelegate代理方法
*/

PasswordAlert(title: "标题", detail: "请输入密码", explain: "这是要输入密码", delegate: self).show()

extension ViewController: PasswordAlertDelegate {
func accomplised(passwordAlert view: PasswordAlert, password: String) {
print("输入的密码是" + password)
}

func close(passwordAlert view: PasswordAlert) -> Bool {
return true
}
}

```


