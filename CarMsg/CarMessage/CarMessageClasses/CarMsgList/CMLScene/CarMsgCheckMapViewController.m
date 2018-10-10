//
//  CarMsgCheckMapViewController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/15.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgCheckMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
@interface CarMsgCheckMapViewController ()<MAMapViewDelegate>
@property (weak, nonatomic) MAMapView * mapView;
@end

@implementation CarMsgCheckMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addUI];
    
    [self configuration];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mapView setZoomLevel:16 animated:NO];
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)configuration {
    MAPointAnnotation * annotation = [[MAPointAnnotation alloc]init];
    annotation.coordinate = self.coordinate;
    annotation.title = self.name;
    [self.mapView addAnnotation:annotation];

}

/*!
 @brief 根据anntation生成对应的View
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                     = 0;
        
        return annotationView;
    }
    
    return nil;
}

- (void)addUI {
    
    UIView * navBarView = [[UIView alloc]init];
    navBarView.userInteractionEnabled = YES;
    navBarView.backgroundColor = [UIColor blackColor];
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:0];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"位置";
    titleLabel.textColor = [UIColor whiteColor];
    [navBarView addSubview:closeBtn];
    [navBarView addSubview:titleLabel];

    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(- 12);
    }];

    [self.view addSubview:navBarView];
    [navBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(NAVBAR_HEIGHT);
    }];
    ///初始化地图
    MAMapView *_mapView = [[MAMapView alloc] init];
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.delegate = self;
    ///把地图添加至view
    [self.view addSubview:_mapView];
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVBAR_HEIGHT);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.mapView = _mapView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = self;
    [_mapView removeFromSuperview];
    _mapView = nil;
}


@end
