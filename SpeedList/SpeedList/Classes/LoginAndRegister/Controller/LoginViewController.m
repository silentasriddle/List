//
//  LoginViewController.m
//  SpeedList
//
//  Created by 李想 on 16/9/16.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation LoginViewController
-(void)cornerWithBtn:(UIButton*)btn{
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = LXCyan;
    btn.alpha = .7;
}
-(void)initUI{
    [self cornerWithBtn:self.loginBtn];
    [self cornerWithBtn:self.registerBtn];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.navigationController.navigationBar.subviews.firstObject.hidden = YES;
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark RegisterAndLogin
- (IBAction)loginAction:(id)sender {
    [BmobUser loginWithUsernameInBackground:self.usernameTF.text password:self.passwordTF.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [Emanager loginWithUsername:self.usernameTF.text andPassword:@"admin"];
            [((AppDelegate*)Application.delegate) showHomeVC];
        }
    }];
}
- (IBAction)registerAction:(id)sender {
    RegisterViewController *regVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:regVC animated:YES];
}

- (IBAction)accountFinish:(id)sender {
    [self.passwordTF becomeFirstResponder];
}
- (IBAction)passwordFinish:(id)sender {
    [self loginAction:self.loginBtn];
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
