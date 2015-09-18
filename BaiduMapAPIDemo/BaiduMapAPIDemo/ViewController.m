//
//  ViewController.m
//  BaiduMapAPIDemo
//
//  Created by Steven on 15/5/6.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "ViewController.h"
#import <BaiduMapAPI/BMapKit.h>
//#import <BaiduMapAPI/BMKMapView+extend.h>

@interface ViewController () <BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView * mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView = [[BMKMapView alloc] init];
    [self.view addSubview:self.mapView];
    
   // [self.mapView removeBaiduLogo];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.mapView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

@end
