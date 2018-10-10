//
//  CMEmojiCollectionCell.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/8.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMEmojiPageCellPresenter.h"
@interface CMEmojiCollectionCell : UICollectionViewCell
@property (strong, nonatomic) EmojiModel * emojiModel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void)configureWithModel:(EmojiModel *)model;
@end
