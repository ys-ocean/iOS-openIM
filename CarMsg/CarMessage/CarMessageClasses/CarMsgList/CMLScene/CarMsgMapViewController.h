//
//  CarMsgMapViewController.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMBaseViewController.h"

@interface CarMsgMapViewController : CMBaseViewController

- (void)setDidLocationBlock:(void (^)(double, double, NSString *))didLocationBlock;

@end
