//
//  CMLPeopleMsg.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/1.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMLBaseMsg.h"

@interface CMLPeopleMsg : CMLBaseMsg
@property (copy, nonatomic) NSString * url;
@property (copy, nonatomic) NSString * nick;
@property (copy, nonatomic) NSString * time;
@property (copy, nonatomic) NSString * content;
@property (copy, nonatomic) NSString * number;
@end
