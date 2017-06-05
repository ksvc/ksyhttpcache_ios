
Pod::Spec.new do |s|
  s.name         = 'ksyhttpcache'
  s.version      = '1.0.10'
  s.license      = {
:type => 'Proprietary',
:text => <<-LICENSE
      Copyright 2015 kingsoft Ltd. All rights reserved.
      LICENSE
  }
  s.homepage     = 'https://github.com/ksvc/ksyhttpcache_ios'
  s.authors      = { 'ksyun' => 'zengfanping@kingsoft.com' }
  s.summary      = 'KSYHTTPCache 金山云iOS平台http缓存SDK.'
  s.description  = <<-DESC
      * 金山云ios平台http缓存SDK，可方便地与播放器集成，实现http视频边播放边下载（缓存）功能。
      * ksyun http cache sdk for ios platform, it's easy to integrated with media players to provide caching capability when watching http videos.
  DESC
  s.platform     = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  

  s.requires_arc = true
  s.source       = { 
    :git => 'https://github.com/ksvc/ksyhttpcache_ios.git', 
    :tag => 'v'+s.version.to_s 
  }
  s.dependency 'CocoaAsyncSocket'
  s.dependency 'CocoaLumberjack'
  s.vendored_frameworks = 'framework/KSYHTTPCache.framework'


end
