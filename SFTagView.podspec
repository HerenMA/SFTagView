Pod::Spec.new do |s|
  s.name         = "SFTagView"
  s.version      = "0.9"
  s.summary      = "SFTagView is a powerful UIView subclass"
  s.description  = <<-DESC
                    SFTagView is a view for display tags
                     - flexible layout, dynamic view height
                     - support depends autolayout constraints to get SFTagView's width, It's useful
                     - support specify set view's width of frame

                   DESC
  s.homepage     = "http://github.com/shiweifu/SFTagView"
  s.license      = "MIT"
  s.author       = { "shiweifu" => "shiweifu@gmail.com" }
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/HerenMA/SFTagView.git", :tag => s.version.to_s }

  s.ios.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.ios.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  s.requires_arc = true
  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files  = "WrapViewWithAutolayout/*.{h,m}"
    ss.exclude_files = "WrapViewWithAutolayout/AppDelegate.{h,m}", "WrapViewWithAutolayout/ViewController.{h,m}", "WrapViewWithAutolayout/main.m"
  end

  #s.subspec 'Framework' do |ss|
  #  ss.ios.vendored_framework   = 'ios/SFTagView.framework'
  #end
  
  s.framework  = "UIKit", "Foundation"
    
end
