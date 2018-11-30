#
#  Be sure to run `pod spec lint JKAlertManager.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "JKAlertManager"
  s.version      = "1.2.2"
  s.summary      = "深度封装UIAlertController,良好兼容UIAlertControllerStyleAlert和UIAlertControllerStyleActionSheet"
  s.homepage     = "https://github.com/XiFengLang/JKAlertManager"
  
  s.license      = "MIT"
  s.author       = { "XiFengLang" => "lang131jp@vip.qq.com" }
  s.source       = { :git => "https://github.com/XiFengLang/JKAlertManager.git", :tag => "#{s.version}" }

  s.platform     = :ios,"8.0"
  s.framework    = "UIKit"
  s.requires_arc = true

  s.source_files = "src/*.{h,m}"


end