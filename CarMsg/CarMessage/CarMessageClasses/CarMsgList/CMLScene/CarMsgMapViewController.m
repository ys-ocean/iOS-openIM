//
//  CarMsgMapViewController.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CarMsgMapViewController.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "CMMapCalloutView.h"
#define DEFAULTSPAN 50
@interface CarMsgMapViewController ()<CLLocationManagerDelegate,MAMapViewDelegate> {
    BOOL isGetUserLocation;
    BOOL isFetchLocation;
}
@property (copy, nonatomic) void(^didLocationBlock)(double longitude,double latitude,NSString * title);
@property (assign, nonatomic) double longitude;
@property (assign, nonatomic) double latitude;

@property (copy, nonatomic) NSString * locationTitle;
@property (weak, nonatomic) UIImageView * pointImageView;
@property (weak, nonatomic) MAMapView * mapView;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLGeocoder * geocoder;
@property (weak, nonatomic) CMMapCalloutView * callOutView;
@end

@implementation CarMsgMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addUI];
    [self configuration];
}

- (void)closeBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)sureBtnClick {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.latitude > 0 && self.longitude > 0 && [self.locationTitle length]) {
        if (self.didLocationBlock) {
            self.didLocationBlock(self.longitude, self.latitude, self.locationTitle);
        }
    }
    else {
        [self showToastWithText:@"定位失败,请确保定位成功再发送位置信息" position:CSToastPositionCenter];
    }
}

- (void)addUI {
    
    UIView * navBarView = [[UIView alloc]init];
    navBarView.userInteractionEnabled = YES;
    navBarView.backgroundColor = [UIColor blackColor];
    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:0];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:0];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"位置";
    titleLabel.textColor = [UIColor whiteColor];
    [navBarView addSubview:closeBtn];
    [navBarView addSubview:titleLabel];
    [navBarView addSubview:sureBtn];
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
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
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

- (void)configuration {
    
    self.geocoder = [[CLGeocoder alloc]init];
    
    [self startLocation];
   
}

- (void)startLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
         [self showToastWithText:@"定位服务当前可能尚未打开，请设置打开" position:CSToastPositionCenter];
        return;
    }
    
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
//        //设置代理
//        self.locationManager.delegate = self;
//        //设置定位精度
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        //定位频率,每隔多少米定位一次
//        CLLocationDistance distance = 10.0;//十米定位一次
//        self.locationManager.distanceFilter = distance;
//        //启动跟踪定位
//        [self.locationManager startUpdatingLocation];
    }
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [self showToastWithText:@"定位失败,定位服务当前可能尚未打开，请设置打开" position:CSToastPositionCenter];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (!isGetUserLocation) {
        if (self.mapView.userLocationVisible) {
            isGetUserLocation = YES;
            [self getAddressByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            [self addCenterLocationViewWithCenterPoint:self.mapView.center];
            
//            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude) zoomLevel:16 animated:YES];
        }
        
    }
    
}

- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    isFetchLocation = YES;
    NSLog(@"mapWillZoomByUser mapWillZoomByUser\n");
}
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    isFetchLocation = YES;
    NSLog(@"mapDidZoomByUser mapDidZoomByUser\n");
}
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    isFetchLocation = YES;
    NSLog(@"mapWillMoveByUser mapWillMoveByUser\n");
}
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    isFetchLocation = YES;
    NSLog(@"mapDidMoveByUser mapDidMoveByUser\n");
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    NSLog(@"regionDidChangeAnimated regionDidChangeAnimated\n");
    if (self.pointImageView && isFetchLocation) {
        CGPoint mapCenter = self.mapView.center;
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:mapCenter toCoordinateFromView:self.mapView];
        [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
        self.pointImageView.center = CGPointMake(mapCenter.x, mapCenter.y - 15);
        self.callOutView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.pointImageView.center = mapCenter;
        }completion:^(BOOL finished){
            if (finished) {
                [UIView animateWithDuration:0.05 animations:^{
                    self.pointImageView.transform = CGAffineTransformMakeScale(1.0, 0.8);
                } completion:^(BOOL finished) {
                    if (finished) {
                        [UIView animateWithDuration:0.1 animations:^{
                            self.pointImageView.transform = CGAffineTransformIdentity;
                        } completion:^(BOOL finished){
                            if (finished) {
                                isFetchLocation = NO;
                            }
                        }];
                    }
                }];
            }
        }];
    }
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation {
    if (!isGetUserLocation) {
        if (self.mapView.userLocationVisible) {
            isGetUserLocation = YES;
            [self getAddressByLatitude:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude];
            [self addCenterLocationViewWithCenterPoint:self.mapView.center];
            [self.mapView setZoomLevel:16 animated:YES];
        }
    }
}

#pragma mark 根据坐标取得地名
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude {
    //反地理编码
    self.latitude = latitude;
    self.longitude = longitude;
    CLLocation * location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self getAroundInfomation:placemarks];
            });
        }else{
            isGetUserLocation = NO;
            NSLog(@"error:%@",error.localizedDescription);
        }
    }];
}

- (void)addCenterLocationViewWithCenterPoint:(CGPoint)point {
    if (!self.pointImageView) {
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2, 100, 18, 38)];
        imageView.center = point;
        imageView.image = [UIImage imageNamed:@"map_location"];
        imageView.center = self.mapView.center;
        [self.view addSubview:imageView];
        
        
        CMMapCalloutView * view = [[CMMapCalloutView alloc]init];
        view.hidden = YES;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(- 10);
            make.centerX.mas_equalTo(0);
        }];
        
        self.callOutView = view;
        self.pointImageView = imageView;
    }
}

- (void)getAroundInfomation:(NSArray *)array {

    for (CLPlacemark * placemark in array) {
        self.locationTitle = placemark.name;
        self.callOutView.title = placemark.name;
    }
    self.callOutView.hidden = NO;
}
#pragma mark - touchs
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    self.callOutView.hidden = YES;
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
    self.geocoder = nil;
    self.mapView.delegate = nil;
    [self.mapView removeFromSuperview];
    self.mapView = nil;
    [self.view removeAllSubviews];
}

- (void)dealloc {
    NSLog(@"CarMsgMapViewController dealloc \n");
}
@end
