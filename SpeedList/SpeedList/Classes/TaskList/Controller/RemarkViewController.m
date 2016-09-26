//
//  RemarkViewController.m
//  SpeedList
//
//  Created by 李想 on 16/9/22.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "RemarkViewController.h"

@interface RemarkViewController ()
@property (nonatomic,strong)UITextView *textView;
@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    
}
//布置界面
-(void)layoutUI{
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:@"备注\n我"];
    [titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:2] range:NSMakeRange(0, 2)];
    [titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:1] range:NSMakeRange(3, 1)];
    [titleStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(3, 1)];
    titleLabel.attributedText = titleStr;
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.barTintColor = LXBeige;
    self.textView = [[UITextView alloc]initWithFrame:MainFrame];
    self.textView.backgroundColor = LXBeige;
    self.textView.text = self.text;
    [self.view addSubview:self.textView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
}
-(void)finishAction{
    self.callback(self.textView.text);
    [self dismissViewControllerAnimated:YES completion:nil];
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
