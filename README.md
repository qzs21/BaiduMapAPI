# BaiduMapAPI
[![Version](https://img.shields.io/cocoapods/v/BaiduMapAPI.svg?style=flat)](http://cocoadocs.org/docsets/BaiduMapAPI)
[![License](https://img.shields.io/cocoapods/l/BaiduMapAPI.svg?style=flat)](http://cocoadocs.org/docsets/BaiduMapAPI)
[![Platform](https://img.shields.io/cocoapods/p/BaiduMapAPI.svg?style=flat)](http://cocoadocs.org/docsets/BaiduMapAPI)

# 常见问题

### 请一定要注意⚠️！`Info.plist`文件在单元测试目录下也有一个，不要改错了哦。

## 地图可以显示，但是不能使用搜索路线，搜索周边等功能
从2.6.0的百度地图升级上来的同学要注意⚠️了！
配置项有一项很容易被忽略的，官方文档上是这样描述的:

`在使用Xcode6进行SDK开发过程中，需要在info.plist中添加：Bundle display name ，且其值不能为空（Xcode6新建的项目没有此配置，若没有会造成manager start failed）`

具体的设置方法是在`Info.plist`文件中添加一个键`Bundle display name`，类型`String`，值填写你的应用的名字。

## iOS9下百度地图不能联网
苹果在iOS9中默认情况下要去开发者必须全部使用`HTTPS`方式进行安全通信。但是事实是，国内大部分应用使用的都是`HTTP`或者混合使用。总之，由于这个限制，会导致所有`HTTP`方式链接的内容都不能访问。
当然，解决的，同样是修改`Info.plist`:

1. 在`Info.plist`中添加`NSAppTransportSecurity`类型`Dictionary`。
2. 在`NSAppTransportSecurity`下添加`NSAllowsArbitraryLoads`类型`Boolean`,值设为`YES`

想更详细的了解请跳转这个链接：[iOS9 HTTP 不能正常使用的解决办法](http://segmentfault.com/a/1190000002933776)


# Quick start

`BaiduMapAPI` 支持 [CocoaPods](http://cocoapods.org).  添加下面的配置到 `Podfile`:

```ruby
pod 'BaiduMapAPI'
```

引入百度地图扩展功能:
```ruby
pod 'BaiduMapAPI-Extend'
```

# BMKMapView Extend
```objective-c
/**
 *  百度地图扩展方法
 */
@interface BMKMapView (ZoomLevel)

/**
 *  获取当前缩放级别
 */
- (NSUInteger)getZoomLevel;

/**
 *  设置中点和缩放级别
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

/**
 *  自动安装地图上的标记点缩放到合适大小
 */
- (void)zoomToFitMapAnnotations;

/**
 *  删除地图上的百度logo
 */
- (void)removeBaiduLogo;

/**
 *  是否开启缩放按钮
 */
@property (nonatomic, assign) BOOL showZoomButtons;
@property (nonatomic, readonly) UIButton * plusButton; // 放大按钮
@property (nonatomic, readonly) UIButton * lessButton; // 缩小按钮

@end
```

# Official documents
[http://developer.baidu.com/map/index.php?title=iossdk](http://developer.baidu.com/map/index.php?title=iossdk)


# 提交更新到CocoaPods说明
提交或者校验BaiduMapAPI-Extend.podspec文件时，使用下面的命令忽略包中包含二进制文件依赖时的错误（[问题出处](https://github.com/CocoaPods/CocoaPods/issues/3194)）

```
pod trunk push BaiduMapAPI-Extend.podspec --verbose --use-libraries
```