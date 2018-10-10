//
//  CMEmojiCollectionCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMEmojiCollectionCell.h"
#import "CMEmojiPreView.h"

@interface CMEmojiCollectionCell ()
@property (weak, nonatomic) UIView * preView;
@end

@implementation CMEmojiCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /// 异步绘制 内容需要反复重绘的情况设置为false
    self.layer.drawsAsynchronously = YES;
    /// cell优化尽量减少图层的数量，相当于就只有一层，相对画面中移动但自身外观不变的对象
    self.layer.shouldRasterize = YES;
    /// 必须制定分辨率
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)configureWithModel:(EmojiModel *)model {
    _emojiModel = model;
    
    if ([model.imageId length]>0) {
        /// 不推荐使用 imageNamed ，先取然后加入缓存 虽然下次从缓存取加载更快 但是大量表情图片加载到缓存会卡顿一下
//        UIImage * image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@@2x",model.descName] ofType:@"png"]];
        self.imageView.image = model.image;
    }
    else {
        self.imageView.image = nil;
    }
}


@end
