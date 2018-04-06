

Pod::Spec.new do |s|



  s.name         = "PasswordView"
  s.version      = "0.0.2"
  s.summary      = "仿微信支付宝密码输入"


  s.description  = <<-DESC
  自定义的密码输入，仿微信、支付宝
                   DESC

  s.homepage     = "https://github.com/kunpo/PasswordView"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "kunpo" => "594966623@qq.com" }
  
  

  s.platform     = :ios
  s.ios.deployment_target = "8.0"


  s.source       = { :git => "https://github.com/kunpo/PasswordView.git", :tag => "#{s.version}" }




  s.source_files  = "PasswordViewDemo/KPOPasswordView/PasswordAlert.swift", "PasswordViewDemo/KPOPasswordView/PasswordView.swift"
  # s.exclude_files = "Classes/Exclude"


  s.requires_arc = true

  

end
