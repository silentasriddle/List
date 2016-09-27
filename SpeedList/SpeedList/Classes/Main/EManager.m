//
//  EManager.m
//  SpeedList
//
//  Created by 李想 on 16/9/17.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "EManager.h"
EManager *_emanager = nil;
@implementation EManager
-(NSMutableArray *)requests{
    if (!_requests) {
        _requests = [NSMutableArray array];
    }return  _requests;
}
+(instancetype)sharedEmanager{
    @synchronized (self) {
        if (_emanager == nil) {
            _emanager = [[EManager alloc]init];
            [[EaseMob sharedInstance].chatManager addDelegate:_emanager delegateQueue:nil];
        }
    }
    return _emanager;
}
-(void)registerWithUsername:(NSString *)username andPassword:(NSString *)password{
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:username password:password withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"EaseMob注册成功");
            [self loginWithUsername:username andPassword:password];
        }
    } onQueue:nil];
}
-(void)loginWithUsername:(NSString *)username andPassword:(NSString *)password{
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username password:password completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"EaseMob登录成功");
        }else{
            [self registerWithUsername:username andPassword:password];
            NSLog(@"%@",error);
        }
    } onQueue:nil];
}
-(void)logoutAction{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
}
-(void)addFriendWithUsername:(NSString *)username andMessage:(NSString *)message{
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:username message:message error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
    }
}


#pragma mark <EaseMobDelegate>
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    if (!message) {
        message = [username stringByAppendingFormat:@"请求加你为好友:%@",message];
    }
    NSDictionary *request = @{@"username":username,@"message":message};
    [self.requests addObject:request];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshFriendList" object:nil];
}
@end
