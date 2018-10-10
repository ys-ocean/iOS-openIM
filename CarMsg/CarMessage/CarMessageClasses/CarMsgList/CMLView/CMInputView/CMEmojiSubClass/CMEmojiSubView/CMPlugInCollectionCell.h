//
//  CMPlugInCollectionCell.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlugInProtocol.h"

@interface CMPlugInCollectionCell : UICollectionViewCell

- (void)configureWithModel:(PlugInModel *)model;

@end

