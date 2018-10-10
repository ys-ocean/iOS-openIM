//
//  CarMsgInputController.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/10.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CMMsgInputContentView.h"
#import "CMMsgInputViewPresenter.h"
@interface CarMsgInputController : NSObject

- (CMMsgInputContentView * )contentView;

+ (instancetype)instanceWithPresenter:(CMMsgInputViewPresenter *)presenter;

@end
