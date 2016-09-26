//
//  RegisterViewController.m
//  SpeedList
//
//  Created by 李想 on 16/9/16.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end
NSString *successStr = @"恭喜！注册成功";
NSString *failStr = @"很抱歉，这个账号已被注册，换一个试试吧";
@implementation RegisterViewController
- (IBAction)testAction:(id)sender {
    BmobUser *user = [[BmobUser alloc]init];
    user.username = self.usernameTF.text;
    user.password = self.passwordTF.text;
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        NSString *message = @"";
        if (isSuccessful) {
            message = successStr;
        }else{
            NSLog(@"%@",error);
            message = failStr;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([message isEqualToString:successStr]) {
                [Emanager registerWithUsername:self.usernameTF.text andPassword:@"admin"];
                [((AppDelegate*)Application.delegate) showHomeVC];
            }else{
                return ;
            }
        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    
}
-(void)cornerWithBtn:(UIButton*)btn{
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = LXCyan;
    btn.alpha = .7;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cornerWithBtn:self.testBtn];
    
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
