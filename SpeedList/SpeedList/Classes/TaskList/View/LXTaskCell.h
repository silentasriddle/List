//
//  LXTaskCell.h
//  SpeedList
//
//  Created by 李想 on 16/9/24.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
typedef void (^FinishBlock)(TaskModel *task);
@interface LXTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;
@property (nonatomic,copy)FinishBlock finishBlock;
@property (nonatomic)BOOL isCompleted;
@property (nonatomic,strong)TaskModel *taskModel;
@end
