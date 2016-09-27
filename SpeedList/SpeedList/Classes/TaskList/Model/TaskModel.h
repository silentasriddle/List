//
//  TaskModel.h
//  SpeedList
//
//  Created by 李想 on 16/9/22.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject<NSCoding>
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *remark;
@property (nonatomic,strong)NSArray *imagePaths;
@property (nonatomic,strong)NSDate *taskDate;
@property (nonatomic,strong)NSDate *wakeTime;
@property (nonatomic,strong)NSArray *photoDatas;
@property (nonatomic)BOOL isCompleted;
@property (nonatomic,strong)BmobUser *user;
@property(nonatomic,strong)NSString *bmobTaskID;
-(instancetype)initWithBmobObject:(BmobObject *)bObj;
+(TaskModel*)unarchivedWithPath:(NSString*)path;
@end
