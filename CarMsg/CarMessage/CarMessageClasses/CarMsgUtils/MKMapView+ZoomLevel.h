//
//  MKMapView+ZoomLevel.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/14.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

@end
