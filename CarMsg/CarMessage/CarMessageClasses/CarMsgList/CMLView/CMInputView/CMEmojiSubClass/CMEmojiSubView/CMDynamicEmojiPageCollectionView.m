//
//  CMDynamicEmojiPageCollectionView.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/17.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMDynamicEmojiPageCollectionView.h"
#import "CMDynamicEmojiCell.h"
@interface CMDynamicEmojiPageCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak , nonatomic) NSMutableArray * pageArray;
@property (copy, nonatomic) void(^didSelectDynamicEmojiBlock)(NSString *);

@end

@implementation CMDynamicEmojiPageCollectionView
#define DynamicCount 30
/// 只准备了29个动态表情
static NSString * identify = @"CMDynamicEmojiCell";
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
    return self.itemArray.count;
}

#pragma mark  设置CollectionView每组所包含的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray * array = self.itemArray[section];
    return [array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CMDynamicEmojiCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    NSArray * pageArr = self.itemArray[indexPath.section];
    NSString * imageName = pageArr[indexPath.row];
    YYImage * image = [YYImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",imageName] ofType:@"gif"]];
    cell.imageView.image = image;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * pageArr = self.itemArray[indexPath.section];
    NSString * imageName = pageArr[indexPath.row];
    self.didSelectDynamicEmojiBlock ? self.didSelectDynamicEmojiBlock(imageName) : nil;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray new];
        for (int i = 1; i< DynamicCount; i++) {
            NSString * name;
            if (i<10) {
                name = [NSString stringWithFormat:@"00%d",i];
            }
            else if (i<100) {
                name = [NSString stringWithFormat:@"0%d",i];
            }
            else {
                name = [NSString stringWithFormat:@"%d",i];
            }
            NSString * imageName = [NSString stringWithFormat:@"dbq_%@",name];
            if ((i - 1) % CMDynamicPageMaxEmojiCount == 0) {
                NSMutableArray * array = [NSMutableArray new];
                [_itemArray addObject:array];
                self.pageArray = array;
            }
            [self.pageArray addObject:imageName];
        }
    }
    return _itemArray;
}
@end
