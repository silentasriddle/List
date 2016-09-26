//
//  Utils.h
//  SpeedList
//
//  Created by 李想 on 16/9/17.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^MyCallback)(id obj);
@interface Utils : NSObject
+(void)archiveTaskWithPath:(NSString *)path andPhotos:(NSArray *)photos andTask:(BmobObject*)task;
+(void)cacheTaskWithTask:(BmobObject*)task andPhotos:(NSArray *)photos;
@end
