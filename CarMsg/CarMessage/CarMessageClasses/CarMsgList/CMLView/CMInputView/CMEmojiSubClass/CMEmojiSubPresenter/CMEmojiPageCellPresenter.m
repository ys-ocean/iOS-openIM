//
//  CMEmojiPageCellPresenter.m
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/7.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import "CMEmojiPageCellPresenter.h"


@implementation CMEmojiPageCellPresenter

+ (instancetype)instanceWithPageNumber:(NSUInteger)page {
    CMEmojiPageCellPresenter * obj = [[CMEmojiPageCellPresenter alloc]init];
    obj.page = page;
    obj.dataArray = [NSMutableArray new];
    return obj;
}

@end
