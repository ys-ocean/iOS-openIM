//
//  CMEmojiPageCollectionView.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/9.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMDefaultEmojiPresenter.h"
@interface CMEmojiPageCollectionView : UICollectionView
@property (weak, nonatomic) UIPageControl * pageControl;
@property (strong, nonatomic) CMDefaultEmojiPresenter * presenter;
@property (assign, nonatomic) NSInteger lastSelectIndex;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout;
/// 点击添加
- (void)setAddEmojiBlock:(void (^)(CMTextAttachment *))addEmojiBlock;
/// 点击删除
- (void)setDeleteEmoji:(void (^)(void))deleteEmoji;
@end
