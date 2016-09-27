//
//  MainTabbarController.m
//  SpeedList
//
//  Created by 李想 on 16/9/16.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "MainTabbarController.h"
#import "HomeViewController.h"
#import "UserViewController.h"
#import "LXFriendsViewController.h"
@interface MainTabbarController ()

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HomeViewController *home = [[HomeViewController alloc]init];
    home.title = @"首页";
    home.tabBarItem.image = [UIImage imageNamed:@"推荐_默认"];
    
    UserViewController *user = [[UserViewController alloc]init];
    user.title = @"用户";
    user.tabBarItem.image = [UIImage imageNamed:@"我的_默认"];
    LXFriendsViewController *friends = [[LXFriendsViewController alloc]init];
    friends.title = @"好友";
    friends.tabBarItem.image = [UIImage imageNamed:@"栏目_默认"];
    self.viewControllers = @[MainNavi(home),MainNavi(friends),MainNavi(user)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
