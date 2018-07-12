

Pod::Spec.new do |s|

  s.name         = "QDNotificationBar"
  s.version      = "0.1.0"
  s.summary      = "Show a custom view of Notificaation"

  s.homepage     = "https://github.com/QiuDaniel/QDNotificationBar"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "qiudan" => "qiudan-098@163.com" }
  s.source       = { :git => "https://github.com/QiuDaniel/QDNotificationBar.git", :tag => s.version.to_s }

  s.source_files  = "QDNotificationBar/*.{h,m}"
  s.resources = "QDNotificationBar/*.{mp3}"
  s.ios.deployment_target = '8.0'
  s.requires_arc = true


end
