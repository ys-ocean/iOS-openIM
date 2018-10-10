//
//  CMEmojiPageCellPresenter.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/7.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmojiModel.h"
/// 一页26个表情 还有一个删除
static NSUInteger const CMPageViewMaxEmojiCount = 27 - 1;
/// 水平方向1行有9个
static NSUInteger const CMPageViewHorizontalCount = 9;
/// 垂直方向有3行
static NSUInteger const CMPageViewVerticalCount = 3;

@interface CMEmojiPageCellPresenter : NSObject
/// 页数
@property (assign, nonatomic) NSUInteger  page;
/// 这一页的表情数组
@property (strong, nonatomic) NSMutableArray <EmojiModel *> * dataArray;

+ (instancetype)instanceWithPageNumber:(NSUInteger)page;

@end
