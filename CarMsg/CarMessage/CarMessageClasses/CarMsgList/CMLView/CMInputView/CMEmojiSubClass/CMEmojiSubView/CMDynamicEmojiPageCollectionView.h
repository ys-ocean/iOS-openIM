//
//  CMDynamicEmojiPageCollectionView.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/17.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 一页26个表情
static NSUInteger const CMDynamicPageMaxEmojiCount = 8;
/// 水平方向1行有9个
static NSUInteger const CMDynamicPageHorizontalCount = 4;
/// 垂直方向有3行
static NSUInteger const CMDynamicPageVerticalCount = 2;

@interface CMDynamicEmojiPageCollectionView : UICollectionView
@property (weak, nonatomic) UIPageControl * pageControl;
@property (strong ,nonatomic) NSMutableArray * itemArray;
@property (assign, nonatomic) NSInteger lastSelectIndex;
/// 选择一张动态图片
- (void)setDidSelectDynamicEmojiBlock:(void (^)(NSString *))didSelectDynamicEmojiBlock;
@end
