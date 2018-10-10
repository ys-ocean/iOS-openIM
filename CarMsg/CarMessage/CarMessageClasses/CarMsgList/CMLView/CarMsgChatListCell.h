//
//  CarMsgChatListCell.h
//  CarMessage
//
//  Created by 胡海峰 on 2018/3/2.
//  Copyright © 2018年 xiaohai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMCListCellPresenter.h"
@interface CarMsgChatListCell : UITableViewCell
@property (strong ,nonatomic) CMCListCellPresenter * presenter;
@property (nonatomic, copy) NSString * identifier;
@end
