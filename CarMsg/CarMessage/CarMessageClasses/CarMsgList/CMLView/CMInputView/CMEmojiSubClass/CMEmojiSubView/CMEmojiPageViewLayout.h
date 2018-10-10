//
//  CMEmojiPageViewLayout.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMEmojiPageViewLayout : UICollectionViewFlowLayout
/// .h 里面都是要外部赋值的
/// 每行几个
@property (assign, nonatomic) NSNumber * HorizontalNumber;
/// 有几行
@property (assign, nonatomic) NSNumber * VerticalNumber;
/// 宽度
@property (assign, nonatomic) CGFloat width;
/// 高度
@property (assign, nonatomic) CGFloat height;
/// 周边距
@property (assign, nonatomic) UIEdgeInsets inset;
/// item之间左右的间距
@property (assign, nonatomic) CGFloat itemLRSpace;

/// item宽高是否相等 Defact NO
@property (assign, nonatomic) BOOL isWidthEqualHeight;

/// 若设置了值  高度根据行数自动计算
/// item之间上下的间距(可选设置 若 isWidthEqualHeight 自动计算)
@property (assign, nonatomic) CGFloat itemTBSpace;

@end
