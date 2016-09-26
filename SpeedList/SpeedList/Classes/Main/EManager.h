//
//  EManager.h
//  SpeedList
//
//  Created by 李想 on 16/9/17.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EaseMob.h>
@interface EManager : NSObject<EMChatManagerDelegate>
+(instancetype)sharedEmanager;
-(void)registerWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)loginWithUsername:(NSString *)username andPassword:(NSString*)password;
-(void)logoutAction;
-(void)addFriendWithUsername:(NSString *)username andMessage:(NSString *)message;
@end
