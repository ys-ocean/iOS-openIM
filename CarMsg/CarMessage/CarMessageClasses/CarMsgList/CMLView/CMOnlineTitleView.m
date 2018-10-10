//
//  CMOnlineTitleView.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/3.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMOnlineTitleView.h"

@interface CMOnlineTitleView ()
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineView;

@end

@implementation CMOnlineTitleView

- (void)setName:(NSString *)name {
    self.nickLabel.text = name;
}

- (void)setIsOnline:(BOOL)isOnline {
    self.onlineView.backgroundColor = isOnline ? [UIColor greenColor] : [UIColor lightGrayColor];
}
@end
