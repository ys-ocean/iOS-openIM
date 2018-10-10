//
//  CMPlugInCollectionCell.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMPlugInCollectionCell.h"

@interface CMPlugInCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CMPlugInCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    /// 异步绘制 内容需要反复重绘的情况设置为false
    self.layer.drawsAsynchronously = YES;
    /// cell优化尽量减少图层的数量，相当于就只有一层，相对画面中移动但自身外观不变的对象
    self.layer.shouldRasterize = YES;
    /// 必须制定分辨率
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (void)configureWithModel:(PlugInModel *)model {
    self.titleLabel.text = model.title;
    self.imageView.image = [UIImage imageNamed:model.imageName];
}
@end
