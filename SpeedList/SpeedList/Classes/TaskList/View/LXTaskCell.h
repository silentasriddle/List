//
//  LXTaskCell.h
//  SpeedList
//
//  Created by 李想 on 16/9/24.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^FinishBlock)(BmobObject *task);
@interface LXTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;
@property (nonatomic,copy)FinishBlock finishBlock;
@property (nonatomic,strong)BmobObject *task;
@property (nonatomic)BOOL isCompleted;
@end
