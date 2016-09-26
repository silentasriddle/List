//
//  LXTaskListViewController.h
//  SpeedList
//
//  Created by 李想 on 16/9/21.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXTaskListViewController : UIViewController
@property (nonatomic,copy)NSString *listTitle;
@property (nonatomic)BOOL isAllowToAdd;
@property (nonatomic,strong)NSMutableArray *tasks;
@end
