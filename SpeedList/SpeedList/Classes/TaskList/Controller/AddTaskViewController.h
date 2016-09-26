//
//  AddTaskViewController.h
//  SpeedList
//
//  Created by 李想 on 16/9/21.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
@interface AddTaskViewController : UIViewController
@property (nonatomic,strong)NSString *taskType;
@property (nonatomic,strong)TaskModel *task;
@end
