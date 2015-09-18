//
//  BMKMapView+extend.m
//  iAuto360
//
//  Created by Steven on 15/1/8.
//  Copyright (c) 2015年 YaMei. All rights reserved.
//

#import "BMKMapView+extend.h"

#define MERCATOR_OFFSET 268435456
#define MERCATOR_RADIUS 85445659.44705395

@implementation BMKMapView (ZoomLevel)

#pragma mark - Map conversion methods

- (double)longitudeToPixelSpaceX:(double)longitude
{
    return round(MERCATOR_OFFSET + MERCATOR_RADIUS * longitude * M_PI / 180.0);
}

- (double)latitudeToPixelSpaceY:(double)latitude
{
    return round(MERCATOR_OFFSET - MERCATOR_RADIUS * logf((1 + sinf(latitude * M_PI / 180.0)) / (1 - sinf(latitude * M_PI / 180.0))) / 2.0);
}

- (double)pixelSpaceXToLongitude:(double)pixelX
{
    return ((round(pixelX) - MERCATOR_OFFSET) / MERCATOR_RADIUS) * 180.0 / M_PI;
}

- (double)pixelSpaceYToLatitude:(double)pixelY
{
    return (M_PI / 2.0 - 2.0 * atan(exp((round(pixelY) - MERCATOR_OFFSET) / MERCATOR_RADIUS))) * 180.0 / M_PI;
}

#pragma mark - Helper methods

- (BMKCoordinateSpan)coordinateSpanWithMapView:(BMKMapView *)mapView
                             centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                 andZoomLevel:(NSUInteger)zoomLevel
{
    // convert center coordiate to pixel space
    double centerPixelX = [self longitudeToPixelSpaceX:centerCoordinate.longitude];
    double centerPixelY = [self latitudeToPixelSpaceY:centerCoordinate.latitude];
    
    // determine the scale value from the zoom level
    NSInteger zoomExponent = 20 - zoomLevel;
    double zoomScale = pow(2, zoomExponent);
    
    // scale the map’s size in pixel space
    CGSize mapSizeInPixels = mapView.bounds.size;
    double scaledMapWidth = mapSizeInPixels.width * zoomScale;
    double scaledMapHeight = mapSizeInPixels.height * zoomScale;
    
    // figure out the position of the top-left pixel
    double topLeftPixelX = centerPixelX - (scaledMapWidth / 2);
    double topLeftPixelY = centerPixelY - (scaledMapHeight / 2);
    
    // find delta between left and right longitudes
    CLLocationDegrees minLng = [self pixelSpaceXToLongitude:topLeftPixelX];
    CLLocationDegrees maxLng = [self pixelSpaceXToLongitude:topLeftPixelX + scaledMapWidth];
    CLLocationDegrees longitudeDelta = maxLng - minLng;
    
    // find delta between top and bottom latitudes
    CLLocationDegrees minLat = [self pixelSpaceYToLatitude:topLeftPixelY];
    CLLocationDegrees maxLat = [self pixelSpaceYToLatitude:topLeftPixelY + scaledMapHeight];
    CLLocationDegrees latitudeDelta = -1 * (maxLat - minLat);
    
    // create and return the lat/lng span
    BMKCoordinateSpan span = BMKCoordinateSpanMake(latitudeDelta, longitudeDelta);
    return span;
}

#pragma mark - Public methods

- (NSUInteger)getZoomLevel
{
    return 21-round(log2(self.region.span.longitudeDelta * MERCATOR_RADIUS * M_PI / (180.0 * self.bounds.size.width)));
}

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated
{
    // clamp large numbers to 28
    zoomLevel = MIN(zoomLevel, 28);
    
    // use the zoom level to compute the region
    BMKCoordinateSpan span = [self coordinateSpanWithMapView:self centerCoordinate:centerCoordinate andZoomLevel:zoomLevel];
    BMKCoordinateRegion region = BMKCoordinateRegionMake(centerCoordinate, span);
    
    // set the region like normal
    [self setRegion:region animated:animated];
}

- (void)zoomToFitMapAnnotations
{
    if ([self.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<BMKAnnotation> annotation in self.annotations) {
        if ([annotation isKindOfClass:[BMKUserLocation class]]) {
            continue;
        }
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    BMKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.2;
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.2;
    
    region = [self regionThatFits:region];
    [self setRegion:region animated:YES];
}

/// 百度地图2.8.0，删除地图上的百度logo
- (void)removeBaiduLogo {
    for (UIView *view in [self.subviews[0] subviews]) {
        if ([view isKindOfClass:UIImageView.class]) {
            view.hidden = YES;
            break;
        }
    }
}


#pragma mark - 缩放按钮
- (void)updateButtonEnabled:(float)zoomLevel {
    self.plusButton.enabled = zoomLevel < 19;
    self.lessButton.enabled = zoomLevel > 3;
}
- (void)onPlusButtonTouch:(UIButton *)sender {
    float zoomLevel = self.zoomLevel;
    if (zoomLevel < 19) {
        zoomLevel++;
        self.zoomLevel = zoomLevel;
    }
    [self updateButtonEnabled:zoomLevel];
}
- (void)onLessButtonTouch:(UIButton *)sender {
    float zoomLevel = self.zoomLevel;
    if (self.zoomLevel > 3) {
        zoomLevel--;
        self.zoomLevel = zoomLevel;
    }
    [self updateButtonEnabled:zoomLevel];
}
#define TAG_ZOOM_BUTTON_BASE 9876
- (UIButton *)plusButton {
    UIButton * plus = (UIButton *)[self viewWithTag:TAG_ZOOM_BUTTON_BASE+0];
    if ( plus==nil ) {
        plus = [UIButton buttonWithType:UIButtonTypeCustom];
        [plus setBackgroundImage:[UIImage imageWithContentsOfFile:[self.class getResourceWithPath:@"images/btn_zoom_plus_N@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [plus setTag:TAG_ZOOM_BUTTON_BASE+0];
        [plus setFrame:CGRectMake(self.frame.size.width - 50, 20, 35, 35)];
        [plus addTarget:self action:@selector(onPlusButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:plus];
    }
    return plus;
}
- (UIButton *)lessButton {
    UIButton * less = (UIButton *)[self viewWithTag:TAG_ZOOM_BUTTON_BASE+1];
    if ( less==nil ) {
        less = [UIButton buttonWithType:UIButtonTypeCustom];
        [less setBackgroundImage:[UIImage imageWithContentsOfFile:[self.class getResourceWithPath:@"images/btn_zoom_less_N@2x" ofType:@"png"]] forState:UIControlStateNormal];
        [less setTag:TAG_ZOOM_BUTTON_BASE+1];
        [less addTarget:self action:@selector(onLessButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        [less setFrame:CGRectMake(self.frame.size.width - 50, 65, 35, 35)];
        [self addSubview:less];
    }
    return less;
}

- (void)setShowZoomButtons:(BOOL)showZoomButtons {
    [self.plusButton setHidden:!showZoomButtons];
    [self.lessButton setHidden:!showZoomButtons];
    [self updateButtonEnabled:self.zoomLevel];
}

- (BOOL)showZoomButtons {
    UIButton * plus = (UIButton *)[self viewWithTag:TAG_ZOOM_BUTTON_BASE+0];
    return (plus != nil) && (!plus.hidden);
}

/**
 *  读取资源文件
 *  @param  path 资源相对路径
 *  @return 资源绝对路径
 */
+ (NSString *)getResourceWithPath:(NSString *)path ofType:(NSString *)type {
    return [[NSBundle mainBundle] pathForResource:[@"mapapi.bundle" stringByAppendingPathComponent:path] ofType:type];
}


@end