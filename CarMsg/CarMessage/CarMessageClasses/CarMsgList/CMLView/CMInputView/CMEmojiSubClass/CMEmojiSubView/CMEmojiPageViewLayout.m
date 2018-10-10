//
//  CMEmojiPageViewLayout.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMEmojiPageViewLayout.h"
@interface CMEmojiPageViewLayout ()

/// item
@property (assign, nonatomic) CGFloat itemW;
/// item
@property (assign, nonatomic) CGFloat itemH;
@property (strong, nonatomic) NSMutableArray *attrsArray;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat currentHeight;
@property (assign, nonatomic) CGFloat totalWidth;
@property (assign, nonatomic) NSInteger page;
@end

@implementation CMEmojiPageViewLayout

/**  初始化*/
- (void)prepareLayout {
    [super prepareLayout];
    [self.attrsArray removeAllObjects];
    
    self.page = 0;
    self.currentHeight = 0.0;
    self.totalWidth = self.width;
    self.itemW = (self.width - (self.inset.left + self.inset.right) - (self.HorizontalNumber.integerValue - 1) * self.itemLRSpace)/(self.HorizontalNumber.floatValue);
    
    if (self.isWidthEqualHeight) {
        self.itemH = self.itemW;
        self.itemTBSpace = (self.height - (self.inset.top + self.inset.bottom) - self.VerticalNumber.integerValue * self.itemH)/(self.VerticalNumber.floatValue - 1);
    }
    else {
        if (self.itemTBSpace > 0) {
            self.itemH = (self.height - (self.inset.top + self.inset.bottom) - (self.VerticalNumber.integerValue - 1) * self.itemTBSpace)/(self.VerticalNumber.floatValue);
        }
        else {
            self.itemH = (self.height - (self.inset.top + self.inset.bottom))/(self.VerticalNumber.floatValue);
        }
    }
    
    self.x = self.inset.left;
    self.y = self.inset.top;
    for (NSInteger j = 0; j < self.collectionView.numberOfSections; j++) {
        for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:j]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:j];
            //获取indexPath 对应cell 的布局属性
            UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:indexPath];
            [self.attrsArray addObject:attr];
        }
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    NSUInteger remainder = indexPath.row % self.HorizontalNumber.integerValue;
    if (indexPath.section != self.page) {
        self.page = indexPath.section;
        self.currentHeight = 0.0;
        self.totalWidth += self.width;
    }
    
    if (remainder == 0) {
        self.y = self.inset.top + self.currentHeight;
        self.x = self.inset.left + indexPath.section * self.width;
        self.currentHeight += (self.itemH + self.itemTBSpace);
    }
    else {
        self.x = self.inset.left + remainder * (self.itemW + self.itemLRSpace) + indexPath.section * self.width;
    }
    attr.frame = CGRectMake(self.x,self.y,self.itemW,self.itemH);
    return attr;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.totalWidth, self.height);
}
/**
 *  决定cell 的排布
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attrsArray;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (NSMutableArray *)attrsArray {
    if (!_attrsArray) {
        
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}
@end
