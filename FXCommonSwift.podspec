Pod::Spec.new do |s|
  s.name         = "FXCommonSwift"
  s.version      = "1.0.1"
  s.summary      = "FX通用框架"

  s.homepage     = "https://github.com/zqw87699/FXCommonSwift"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = {"zhangdazong" => "929013100@qq.com"}

  s.source       = { :git => "https://github.com/zqw87699/FXCommonSwift.git", :tag => "#{s.version}"}

  s.platform     = :ios, "8.0"

  s.frameworks = "Foundation", "UIKit"

  s.module_name = 'FXCommonSwift'

  s.requires_arc = true

s.subspec 'Base' do |base|
    base.source_files = 'Classes/Base/*.{swift}'
    base.dependency 'FXJsonSwift'
    base.dependency 'Alamofire'
    base.dependency 'FXHttpEngineSwift/API'
    base.dependency 'FXRoutableSwift/API'
    base.dependency 'SnapKit', '3.2.0'

end

end
