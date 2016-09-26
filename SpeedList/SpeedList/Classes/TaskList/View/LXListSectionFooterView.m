//
//  LXListSectionFooterView.m
//  SpeedList
//
//  Created by 李想 on 16/9/25.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "LXListSectionFooterView.h"
@interface LXListSectionFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *showCompletedTaskBtn;

@end
@implementation LXListSectionFooterView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.showCompletedTaskBtn.layer.cornerRadius = 5;
    self.showCompletedTaskBtn.layer.masksToBounds = YES;
    self.showCompletedTaskBtn.backgroundColor = LXCyan;
}
- (IBAction)loadCompletedTasks:(id)sender {
    [self.delegate showCompletedTasks];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
