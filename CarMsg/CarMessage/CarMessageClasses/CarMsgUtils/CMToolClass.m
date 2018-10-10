//
//  CMToolClass.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/20.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMToolClass.h"

@implementation CMToolClass

+ (NSString *)weekdayStringForInteger:(NSInteger)number {
    NSString * weekDay = @"";
    switch (number) {
        case 1:
            weekDay = @"星期天";
            break;
        case 2:
            weekDay = @"星期一";
            break;
        case 3:
            weekDay = @"星期二";
            break;
        case 4:
            weekDay = @"星期三";
            break;
        case 5:
            weekDay = @"星期四";
            break;
        case 6:
            weekDay = @"星期五";
            break;
        case 7:
            weekDay = @"星期六";
            break;
        default:
            weekDay = @"";
            break;
    }
    return weekDay;
}

@end
