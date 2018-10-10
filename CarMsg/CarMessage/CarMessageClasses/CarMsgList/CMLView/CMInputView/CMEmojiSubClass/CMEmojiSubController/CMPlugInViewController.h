//
//  CMPlugInViewController.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/13.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMPlugInPresenter.h"
@interface CMPlugInViewController : NSObject

- (UICollectionView *)collectionView;

+ (instancetype)instanceWithPresenter:(CMPlugInPresenter *)presenter;

- (void)setDidPlugInBlokc:(void (^)(void))didPlugInBlokc;
@end


