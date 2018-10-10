//
//  CMMsgAllEmojiView.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/5.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMMsgAllEmojiView : UIView

@property (assign, nonatomic) NSUInteger selectIndex;
- (void)setDidPlugInKeyboardBlock:(void (^)(void))didPlugInKeyboardBlock;
@end
