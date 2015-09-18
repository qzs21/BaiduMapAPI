Pod::Spec.new do |s|

  s.name     = 'BaiduMapAPI'
  s.version  = '2.8.1'
  s.license  = { :type => 'Copyright', :text => 'LICENSE  ©2013 Baidu, Inc. All rights reserved.' }
  s.summary  = 'Baidu Map API For iOS. Official home page : http://developer.baidu.com/map/index.php?title=iossdk'
  s.homepage = 'https://github.com/qzs21/BaiduMapAPI'
  s.authors  = { 'Steven' => 'qzs21@qq.com' }
  s.source   = { 
    :http => 'http://wiki.lbsyun.baidu.com/cms/iossdk/doc/v2_8_1/output_ios/map_search_cloud_loc_util_radar/BaiduMap_IOSSDK_v2.8.1_Lib.zip',
    :sha1 => '7abf46aedbe73c9ea8b4046fe83567dfed31f7fb'
  }

  s.default_subspec = 'Default'
  s.subspec 'Default' do |spec|
    spec.ios.dependency 'BaiduMapAPI/Universal'
  end

  s.ios.deployment_target = '5.0'
  s.libraries = [ "stdc++", "stdc++.6" ]
  s.requires_arc = true
  s.compiler_flags = '-ObjC'
  s.frameworks = [
    'UIKit',
    'CoreLocation',
    'QuartzCore',
    'OpenGLES',
    'SystemConfiguration',
    'CoreGraphics',
    'Security'
  ]

  s.prepare_command = \
    <<-CMD
      if [ ! -d "Release-universal" ]; then mkdir Release-universal; fi
      rm -rf Release-universal/*
      cp -rf Release-iphoneos/BaiduMapAPI.framework Release-universal/
      rm -rf Release-Universal/BaiduMapAPI.framework/BaiduMapAPI
      lipo -create Release-iphoneos/BaiduMapAPI.framework/BaiduMapAPI Release-iphonesimulator/BaiduMapAPI.framework/BaiduMapAPI -output Release-Universal/BaiduMapAPI.framework/BaiduMapAPI
    CMD

  s.subspec 'Universal' do |spec|
    spec.ios.vendored_frameworks = 'Release-universal/BaiduMapAPI.framework'
    spec.resources = 'Release-universal/BaiduMapAPI.framework/Resources/mapapi.bundle'
    spec.public_header_files = [
      'Release-universal/BaiduMapAPI.framework/Headers/*.h'
    ]
  end

  s.subspec 'iPhoneSimulator' do |spec|
    spec.ios.vendored_frameworks = 'Release-iphonesimulator/BaiduMapAPI.framework'
    spec.resources = 'Release-iphonesimulator/BaiduMapAPI.framework/Resources/mapapi.bundle'
    spec.public_header_files = [
      'Release-iphonesimulator/BaiduMapAPI.framework/Headers/*.h'
    ]
  end

  s.subspec 'iPhoneOS' do |spec|
    spec.ios.vendored_frameworks = 'Release-iphoneos/BaiduMapAPI.framework'
    spec.resources = 'Release-iphoneos/BaiduMapAPI.framework/Resources/mapapi.bundle'
    spec.public_header_files = [
      'Release-iphoneos/BaiduMapAPI.framework/Headers/*.h'
    ]
  end

end
