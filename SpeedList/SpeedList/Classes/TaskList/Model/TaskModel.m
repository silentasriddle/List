//
//  TaskModel.m
//  SpeedList
//
//  Created by 李想 on 16/9/22.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.remark = [aDecoder decodeObjectForKey:@"remark"];
//        self.imagePaths = [aDecoder decodeObjectForKey:@"imagePaths"];
        self.taskDate = [aDecoder decodeObjectForKey:@"taskDate"];
        self.wakeTime = [aDecoder decodeObjectForKey:@"wakeTime"];
        self.photoDatas = [aDecoder decodeObjectForKey:@"photoDatas"];
        self.isCompleted = [[aDecoder decodeObjectForKey:@"isCompleted"]boolValue];
        self.bmobTaskID = [aDecoder decodeObjectForKey:@"bmobTaskID"];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.remark forKey:@"remark"];
//    [aCoder encodeObject:self.imagePaths forKey:@"imagePaths"];
    [aCoder encodeObject:self.taskDate forKey:@"taskDate"];
    [aCoder encodeObject:self.wakeTime forKey:@"wakeTime"];
    [aCoder encodeObject:self.photoDatas forKey:@"photoDatas"];
    [aCoder encodeObject:@(self.isCompleted) forKey:@"isCompleted"];
    [aCoder encodeObject:self.bmobTaskID forKey:@"bmobTaskID"];
}
-(instancetype)initWithBmobObject:(BmobObject *)bObj{
    self = [super init];
    if (self) {
        self.type = [bObj objectForKey:@"type"];
        self.title = [bObj objectForKey:@"title"];
        self.remark = [bObj objectForKey:@"remark"];
        self.imagePaths = [bObj objectForKey:@"imagePaths"];
        self.user = [bObj objectForKey:@"user"];
        self.taskDate = [bObj objectForKey:@"taskDate"];
        self.wakeTime = [bObj objectForKey:@"wakeTime"];
        self.bmobTaskID = bObj.objectId;
        self.isCompleted = [[bObj objectForKey:@"isCompleted"]boolValue];
    }
    return self;
}
+(TaskModel *)unarchivedWithPath:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    TaskModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return model;
}
@end
