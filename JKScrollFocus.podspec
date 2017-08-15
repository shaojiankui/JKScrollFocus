version = "1.0";

Pod::Spec.new do |s|
  s.name         = "JKScrollFocus"
  s.version      = version
  s.summary      = "JKScrollFocus,只关注轮播行为的iOS焦点图无限轮播库,UIScrollView图片无限循环滚动,不依赖第三方图片加载库,不内置PageControl与titleLabel"
  s.homepage     = "https://github.com/shaojiankui/JKScrollFocus"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "skyfox" => "i@skyfox.org" }
  s.social_media_url   = "http://www.skyfox.org"
  s.platform     = :ios
  s.requires_arc = true
  s.source       = { :git => "https://github.com/shaojiankui/JKScrollFocus.git", :tag => "#{version}" }
  s.source_files = "JKScrollFocus/JKScrollFocus/JKScrollFocus.{h,m}"
end