//
//  CMEmojiPageCollectionView.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/9.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMEmojiPageCollectionView.h"
#import "CMEmojiCollectionCell.h"
#import "CMEmojiPreView.h"
@interface CMEmojiPageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) CMEmojiPreView * preView;
@property (assign, nonatomic) BOOL isShowPreView;
@property (weak, nonatomic) CMEmojiCollectionCell * touchCell;
@property (copy, nonatomic) void(^addEmojiBlock)(CMTextAttachment *);
@property (copy, nonatomic) void(^deleteEmoji)(void);

@end
@implementation CMEmojiPageCollectionView
static NSString * identify = @"CMEmojiCollectionCell";
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = EMOJI_BG_COLOR;
        self.delegate = self;
        self.dataSource = self;
        self.pagingEnabled = YES;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.canCancelContentTouches = NO;
        FETCHCOLLECTIONVIEW_CELL_NIB(self, identify, identify);
        self.presenter = [CMDefaultEmojiPresenter instanceWithEmojiPlistName:EmoticonInfoPlistName];
    }
    return self;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.pageControl.currentPage = index;
    self.lastSelectIndex = index;
}

#pragma mark - UICollectionViewDataSource
#pragma mark  设置CollectionView的组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.presenter.dataArray.count;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CMEmojiPageCellPresenter * p = self.presenter.dataArray[section];
    return p.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMEmojiCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    CMEmojiPageCellPresenter * p = self.presenter.dataArray[indexPath.section];
    [cell configureWithModel:p.dataArray[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    CMEmojiPageCellPresenter * p = self.presenter.dataArray[indexPath.section];
//    EmojiModel * m = p.dataArray[indexPath.row];
//    if (self.didSelectedEmoji) {
//        self.didSelectedEmoji(m.attach);
//    }
}

- (void)onClickOverlay {
    self.isShowPreView = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isShowPreView = NO;
    [self performSelector:@selector(onClickOverlay) withObject:nil afterDelay:0.2];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(onClickOverlay) withObject:nil afterDelay:0.2];
    
    if (self.isShowPreView) {
        CMEmojiCollectionCell * cell = [self cellForTouches:touches];
        if ([cell.emojiModel.imageId length] && ![cell.emojiModel.imageId isEqualToString:CarMsgEmojiDeleteKey]) {
            [self showPreViewForEmoji:cell];
        }
        else {
            [self hidePreViewForEmoji];
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hidePreViewForEmoji];
    CMEmojiCollectionCell * cell = [self cellForTouches:touches];
    if ([cell.emojiModel.imageId length] && ![cell.emojiModel.imageId isEqualToString:CarMsgEmojiDeleteKey]) {
        /// 添加 音效
        [[UIDevice currentDevice] playInputClick];

        CMTextAttachment * attach = [CMTextAttachment new];
        attach.image = cell.emojiModel.image;
        attach.imageName = cell.emojiModel.descName;
        attach.bounds = CGRectMake(0, -4, EMOJI_SIZE, EMOJI_SIZE);
        
        self.addEmojiBlock ? self.addEmojiBlock(attach) : nil;

    }
    else if([cell.emojiModel.imageId isEqualToString:CarMsgEmojiDeleteKey]) {
        /// 删除
        self.deleteEmoji ? self.deleteEmoji() : nil;

    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (CMEmojiCollectionCell *)cellForTouches:(NSSet<UITouch *> *)touches {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:point];
    if (indexPath) {
        CMEmojiCollectionCell *cell = (CMEmojiCollectionCell *)[self cellForItemAtIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)showPreViewForEmoji:(CMEmojiCollectionCell *)cell {
    CGRect rect = [self convertRect:cell.frame toViewOrWindow:self.window];
    CGFloat viewW = 60;
    CGFloat viewH = 90;
    
    if (self.preView) {
        self.preView.emojiView.image = cell.emojiModel.image;
        self.preView.frame = CGRectMake((rect.origin.x + cell.frame.size.width/2) - viewW/2, rect.origin.y - viewH, viewW, viewH);
        return;
    }
    CMEmojiPreView * view = FETCHVIEW_XIB(@"CMEmojiPreView", self, nil, 0);
    view.emojiView.image = cell.emojiModel.image;
    view.frame = CGRectMake((rect.origin.x + cell.frame.size.width/2) - viewW/2, rect.origin.y - viewH, viewW, viewH);
    ///获取最上层的window
    UIWindow * window = [UIApplication sharedApplication].windows.lastObject;
    if (window) {
        [window addSubview:view];
        self.preView = view;
    }
}
- (void)hidePreViewForEmoji {
    self.isShowPreView = NO;
    [self.preView removeFromSuperview];
}
@end
