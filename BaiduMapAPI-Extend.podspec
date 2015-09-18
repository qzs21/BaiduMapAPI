Pod::Spec.new do |s|
  s.name     = 'BaiduMapAPI-Extend'
  s.version  = '2.8.1'
  s.license  = { :type => 'Copyright', :text => 'LICENSE  ©2013 Baidu, Inc. All rights reserved.' }
  s.summary  = 'Baidu Map API Extend. Official home page : http://developer.baidu.com/map/index.php?title=iossdk'
  s.homepage = 'https://github.com/qzs21/BaiduMapAPI'
  s.authors  = { 'Steven' => 'qzs21@qq.com' }
  s.source   = { 
    :git => 'https://github.com/qzs21/BaiduMapAPI.git',
    :tag => s.version
  }
  s.ios.deployment_target = '5.0'
  s.ios.dependency 'BaiduMapAPI', s.version
  s.source_files = 'BaiduMapAPI-Extend/*.{h,m,mm}'
end
