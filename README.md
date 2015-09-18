# BaiduMapAPI
[![Version](https://img.shields.io/cocoapods/v/BaiduMapAPI.svg?style=flat)](http://cocoadocs.org/docsets/BaiduMapAPI)
[![License](https://img.shields.io/cocoapods/l/BaiduMapAPI.svg?style=flat)](http://cocoadocs.org/docsets/BaiduMapAPI)
[![Platform](https://img.shields.io/cocoapods/p/BaiduMapAPI.svg?style=flat)](http://cocoadocs.org/docsets/BaiduMapAPI)

# Quick start

`BaiduMapAPI` 支持 [CocoaPods](http://cocoapods.org).  添加下面的配置到 `Podfile`:

```ruby
pod 'BaiduMapAPI'
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
